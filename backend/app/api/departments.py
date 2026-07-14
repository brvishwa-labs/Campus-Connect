from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from app.core.database import get_db
from app.models.department import Department, ProgramOutcome
from app.schemas.department import (
    DepartmentCreate, DepartmentUpdate, DepartmentResponse,
    ProgramOutcomeUpdate, ProgramOutcomeResponse
)
from app.core.security import get_current_active_user
from app.models.user import User

router = APIRouter()

# ── Program Outcomes (must be declared BEFORE /{department_id}) ────────────

@router.get("/program-outcomes", response_model=ProgramOutcomeResponse)
def get_program_outcomes(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Retrieve the institution-wide Program Outcomes (POs).
    Accessible to all authenticated users.
    """
    po = db.query(ProgramOutcome).filter(ProgramOutcome.id == 1).first()
    if not po:
        # Return a placeholder empty record — it will be created on first PUT
        return ProgramOutcomeResponse(id=1, outcomes=None, updated_at=None)
    return po


@router.put("/program-outcomes", response_model=ProgramOutcomeResponse)
def update_program_outcomes(
    po_in: ProgramOutcomeUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Upsert the institution-wide Program Outcomes (POs).
    Admin-only.
    """
    if current_user.role != "admin":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

    po = db.query(ProgramOutcome).filter(ProgramOutcome.id == 1).first()
    if po:
        po.outcomes = po_in.outcomes
        po.updated_by_id = current_user.id
    else:
        po = ProgramOutcome(
            id=1,
            outcomes=po_in.outcomes,
            updated_by_id=current_user.id
        )
        db.add(po)

    db.commit()
    db.refresh(po)
    return po


# ── Departments ─────────────────────────────────────────────────────────────

@router.get("/", response_model=List[DepartmentResponse])
def get_departments(
    skip: int = 0, 
    limit: int = 100, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Retrieve all departments.
    """
    departments = db.query(Department).offset(skip).limit(limit).all()
    return departments

@router.get("/{department_id}", response_model=DepartmentResponse)
def get_department(
    department_id: int, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Get a specific department by ID.
    """
    department = db.query(Department).filter(Department.id == department_id).first()
    if not department:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Department not found")
    return department

@router.post("/", response_model=DepartmentResponse, status_code=status.HTTP_201_CREATED)
def create_department(
    dept_in: DepartmentCreate, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Create a new department. Admin only.
    """
    if current_user.role != "admin":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")
        
    db_dept = db.query(Department).filter(Department.code == dept_in.code).first()
    if db_dept:
        raise HTTPException(status_code=400, detail="Department with this code already exists")
        
    department = Department(
        name=dept_in.name,
        code=dept_in.code,
        vision=dept_in.vision,
        mission=dept_in.mission,
        peos=dept_in.peos,
        psos=dept_in.psos,
        hod_id=dept_in.hod_id
    )
    db.add(department)
    db.commit()
    db.refresh(department)
    return department

@router.put("/{department_id}", response_model=DepartmentResponse)
def update_department(
    department_id: int,
    dept_in: DepartmentUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Update a department. Admin only.
    """
    if current_user.role != "admin":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")
        
    department = db.query(Department).filter(Department.id == department_id).first()
    if not department:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Department not found")
        
    update_data = dept_in.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(department, field, value)
        
    db.add(department)
    db.commit()
    db.refresh(department)
    return department

@router.delete("/{department_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_department(
    department_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Delete a department. Admin only.
    """
    if current_user.role != "admin":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")
        
    department = db.query(Department).filter(Department.id == department_id).first()
    if not department:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Department not found")
        
    db.delete(department)
    db.commit()
    return None
