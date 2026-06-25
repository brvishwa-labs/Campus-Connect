from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from typing import List, Optional
from app.database import get_db
from app.models.department import Department
from app.models.user import User, UserRole
from app.models.faculty import Faculty
from app.models.student import Student
from app.schemas.admin import DepartmentCreate, DepartmentUpdate, DepartmentResponse
from app.middleware.auth import require_admin

router = APIRouter(prefix="/api/v1/admin/departments", tags=["Admin - Departments"])


@router.get("/", response_model=List[DepartmentResponse])
async def get_departments(
    is_active: Optional[bool] = None,
    search: Optional[str] = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Get all departments with optional filters."""
    query = select(Department)
    if is_active is not None:
        query = query.where(Department.is_active == is_active)
    if search:
        query = query.where(Department.name.ilike(f"%{search}%"))
    query = query.order_by(Department.name)

    result = await db.execute(query)
    departments = result.scalars().all()

    response = []
    for dept in departments:
        # Get HOD name
        hod_name = None
        if dept.hod_id:
            hod_result = await db.execute(select(User).where(User.id == dept.hod_id))
            hod = hod_result.scalar_one_or_none()
            if hod:
                hod_name = hod.full_name

        # Get counts
        student_count_result = await db.execute(
            select(func.count(Student.id)).where(Student.department_id == dept.id)
        )
        faculty_count_result = await db.execute(
            select(func.count(Faculty.id)).where(Faculty.department_id == dept.id)
        )

        response.append(DepartmentResponse(
            id=dept.id,
            name=dept.name,
            code=dept.code,
            description=dept.description,
            is_active=dept.is_active,
            hod_id=dept.hod_id,
            hod_name=hod_name,
            student_count=student_count_result.scalar() or 0,
            faculty_count=faculty_count_result.scalar() or 0,
            created_at=dept.created_at,
        ))

    return response


@router.get("/{department_id}", response_model=DepartmentResponse)
async def get_department(
    department_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Get a single department by ID."""
    result = await db.execute(select(Department).where(Department.id == department_id))
    dept = result.scalar_one_or_none()
    if not dept:
        raise HTTPException(status_code=404, detail="Department not found")

    hod_name = None
    if dept.hod_id:
        hod_result = await db.execute(select(User).where(User.id == dept.hod_id))
        hod = hod_result.scalar_one_or_none()
        if hod:
            hod_name = hod.full_name

    return DepartmentResponse(
        id=dept.id, name=dept.name, code=dept.code,
        description=dept.description, is_active=dept.is_active,
        hod_id=dept.hod_id, hod_name=hod_name, created_at=dept.created_at,
    )


@router.post("/", response_model=DepartmentResponse, status_code=201)
async def create_department(
    data: DepartmentCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Create a new department."""
    existing = await db.execute(select(Department).where(
        (Department.name == data.name) | (Department.code == data.code)
    ))
    if existing.scalar_one_or_none():
        raise HTTPException(status_code=400, detail="Department name or code already exists")

    dept = Department(**data.model_dump())
    db.add(dept)
    await db.flush()
    await db.refresh(dept)

    return DepartmentResponse(
        id=dept.id, name=dept.name, code=dept.code,
        description=dept.description, is_active=dept.is_active,
        hod_id=dept.hod_id, created_at=dept.created_at,
    )


@router.put("/{department_id}", response_model=DepartmentResponse)
async def update_department(
    department_id: int,
    data: DepartmentUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Update a department."""
    result = await db.execute(select(Department).where(Department.id == department_id))
    dept = result.scalar_one_or_none()
    if not dept:
        raise HTTPException(status_code=404, detail="Department not found")

    update_data = data.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(dept, key, value)

    await db.flush()
    await db.refresh(dept)

    return DepartmentResponse(
        id=dept.id, name=dept.name, code=dept.code,
        description=dept.description, is_active=dept.is_active,
        hod_id=dept.hod_id, created_at=dept.created_at,
    )


@router.delete("/{department_id}")
async def delete_department(
    department_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Delete a department."""
    result = await db.execute(select(Department).where(Department.id == department_id))
    dept = result.scalar_one_or_none()
    if not dept:
        raise HTTPException(status_code=404, detail="Department not found")

    await db.delete(dept)
    return {"message": "Department deleted successfully"}


@router.patch("/{department_id}/toggle-status")
async def toggle_department_status(
    department_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Toggle department active/inactive status."""
    result = await db.execute(select(Department).where(Department.id == department_id))
    dept = result.scalar_one_or_none()
    if not dept:
        raise HTTPException(status_code=404, detail="Department not found")

    dept.is_active = not dept.is_active
    await db.flush()

    return {"message": f"Department {'activated' if dept.is_active else 'deactivated'}", "is_active": dept.is_active}
