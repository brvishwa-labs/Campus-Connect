from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from app.core.database import get_db
from app.models.authority import Authority
from app.models.user import User
from app.schemas.authority import AuthorityCreate, AuthorityUpdate, AuthorityResponse
from app.core.security import get_current_active_user, get_password_hash

router = APIRouter()

@router.get("/", response_model=List[AuthorityResponse])
def get_authorities(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Retrieve all authorities."""
    return db.query(Authority).all()

@router.post("/", response_model=AuthorityResponse, status_code=status.HTTP_201_CREATED)
def create_authority(
    data: AuthorityCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Onboard a new authority (Principal, VP, Dean, etc.)."""
    if current_user.role != "admin":
        raise HTTPException(status_code=403, detail="Only admins can onboard authorities")

    if db.query(User).filter(User.email == data.email).first():
        raise HTTPException(status_code=400, detail="Email already registered")

    if db.query(Authority).filter(Authority.employee_id == data.employee_id).first():
        raise HTTPException(status_code=400, detail="Employee ID already exists")

    # 1. Create User account
    new_user = User(
        email=data.email,
        hashed_password=get_password_hash(data.password),
        role="authority",
        is_active=True
    )
    db.add(new_user)
    db.flush()

    # 2. Create Authority profile
    new_authority = Authority(
        user_id=new_user.id,
        first_name=data.first_name,
        last_name=data.last_name,
        title=data.title,
        email=data.email,
        phone=data.phone,
        employee_id=data.employee_id
    )
    db.add(new_authority)
    db.commit()
    db.refresh(new_authority)
    return new_authority

@router.put("/{authority_id}", response_model=AuthorityResponse)
def update_authority(
    authority_id: int,
    data: AuthorityUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Update an authority member."""
    if current_user.role != "admin":
        raise HTTPException(status_code=403, detail="Only admins can update authorities")

    db_auth = db.query(Authority).filter(Authority.id == authority_id).first()
    if not db_auth:
        raise HTTPException(status_code=404, detail="Authority not found")

    update_data = data.model_dump(exclude_unset=True)

    if "employee_id" in update_data and update_data["employee_id"] != db_auth.employee_id:
        if db.query(Authority).filter(Authority.employee_id == update_data["employee_id"]).first():
            raise HTTPException(status_code=400, detail="Employee ID already in use")

    for field, value in update_data.items():
        setattr(db_auth, field, value)

    db.commit()
    db.refresh(db_auth)
    return db_auth

@router.delete("/{authority_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_authority(
    authority_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Delete an authority (and their user account)."""
    if current_user.role != "admin":
        raise HTTPException(status_code=403, detail="Only admins can delete authorities")

    db_auth = db.query(Authority).filter(Authority.id == authority_id).first()
    if not db_auth:
        raise HTTPException(status_code=404, detail="Authority not found")

    db_user = db.query(User).filter(User.id == db_auth.user_id).first()

    db.delete(db_auth)
    if db_user:
        db.delete(db_user)

    db.commit()
    return None


# ── Faculty Management (Dean, Principal, OM) ──────────────

from app.models.faculty import Faculty
from app.models.department import Department

@router.get("/faculty")
def get_all_faculty(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Get all faculty across all departments (for Dean, Principal, OM)"""
    # Check if user has authority role
    if current_user.role != "authority":
        raise HTTPException(status_code=403, detail="Access restricted to authorities")
    
    # Fetch all faculty with their department info
    faculty = db.query(Faculty).join(Department, Faculty.department_id == Department.id, isouter=True).all()
    
    return [
        {
            "id": f.id,
            "first_name": f.first_name,
            "last_name": f.last_name,
            "employee_id": f.employee_id,
            "designation": f.designation,
            "college_email": f.college_email,
            "phone": f.phone,
            "department_name": f.department.name if f.department else "N/A",
        }
        for f in faculty
    ]


@router.get("/faculty/{faculty_id}/profile")
def get_faculty_profile(
    faculty_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Get detailed profile of any faculty member (for Dean, Principal, OM)"""
    # Check if user has authority role
    if current_user.role != "authority":
        raise HTTPException(status_code=403, detail="Access restricted to authorities")
    
    faculty = db.query(Faculty).filter(Faculty.id == faculty_id).first()
    
    if not faculty:
        raise HTTPException(status_code=404, detail="Faculty not found")
    
    department = db.query(Department).filter(Department.id == faculty.department_id).first()
    
    return {
        "id": faculty.id,
        "first_name": faculty.first_name,
        "last_name": faculty.last_name,
        "employee_id": faculty.employee_id,
        "designation": faculty.designation,
        "department_name": department.name if department else "N/A",
        "college_email": faculty.college_email,
        "personal_email": faculty.personal_email,
        "phone": faculty.phone,
        "gender": faculty.gender,
        "date_of_birth": faculty.date_of_birth.isoformat() if faculty.date_of_birth else None,
        "blood_group": faculty.blood_group,
        "highest_qualification": faculty.qualification,
        "date_of_joining": faculty.date_of_joining.isoformat() if faculty.date_of_joining else None,
    }
