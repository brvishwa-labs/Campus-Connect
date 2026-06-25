from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from typing import List, Optional
from app.database import get_db
from app.models.faculty import Faculty
from app.models.user import User, UserRole
from app.models.department import Department
from app.schemas.admin import FacultyCreate, FacultyUpdate, FacultyResponse
from app.middleware.auth import require_admin
from app.utils.hashing import hash_password

router = APIRouter(prefix="/api/v1/admin/faculty", tags=["Admin - Faculty"])


@router.get("/", response_model=List[FacultyResponse])
async def get_faculty(
    department_id: Optional[int] = None,
    is_active: Optional[bool] = None,
    search: Optional[str] = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Get all faculty with optional filters."""
    query = select(Faculty)
    if department_id:
        query = query.where(Faculty.department_id == department_id)
    if is_active is not None:
        query = query.where(Faculty.is_active == is_active)
    if search:
        query = query.where(Faculty.name.ilike(f"%{search}%"))
    query = query.order_by(Faculty.name)

    result = await db.execute(query)
    faculty_list = result.scalars().all()

    response = []
    for f in faculty_list:
        dept_result = await db.execute(select(Department).where(Department.id == f.department_id))
        dept = dept_result.scalar_one_or_none()
        user_result = await db.execute(select(User).where(User.id == f.user_id))
        user = user_result.scalar_one_or_none()

        response.append(FacultyResponse(
            id=f.id, user_id=f.user_id, faculty_code=f.faculty_code,
            name=f.name, department_id=f.department_id,
            department_name=dept.name if dept else None,
            designation=f.designation, qualification=f.qualification,
            experience_years=f.experience_years, specialization=f.specialization,
            phone=f.phone, email=user.email if user else None,
            is_active=f.is_active, created_at=f.created_at,
        ))

    return response


@router.post("/", response_model=FacultyResponse, status_code=201)
async def create_faculty(
    data: FacultyCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Create a new faculty member with user account."""
    # Check email uniqueness
    existing_user = await db.execute(select(User).where(User.email == data.email))
    if existing_user.scalar_one_or_none():
        raise HTTPException(status_code=400, detail="Email already registered")

    # Check faculty code uniqueness
    existing_faculty = await db.execute(select(Faculty).where(Faculty.faculty_code == data.faculty_code))
    if existing_faculty.scalar_one_or_none():
        raise HTTPException(status_code=400, detail="Faculty code already exists")

    # Create user account
    user = User(
        email=data.email,
        password_hash=hash_password(data.password),
        full_name=data.name,
        role=UserRole.FACULTY,
        phone=data.phone,
    )
    db.add(user)
    await db.flush()

    # Create faculty record
    faculty = Faculty(
        user_id=user.id,
        faculty_code=data.faculty_code,
        name=data.name,
        department_id=data.department_id,
        designation=data.designation,
        qualification=data.qualification,
        experience_years=data.experience_years,
        specialization=data.specialization,
        phone=data.phone,
    )
    db.add(faculty)
    await db.flush()
    await db.refresh(faculty)

    dept_result = await db.execute(select(Department).where(Department.id == data.department_id))
    dept = dept_result.scalar_one_or_none()

    return FacultyResponse(
        id=faculty.id, user_id=user.id, faculty_code=faculty.faculty_code,
        name=faculty.name, department_id=faculty.department_id,
        department_name=dept.name if dept else None,
        designation=faculty.designation, qualification=faculty.qualification,
        experience_years=faculty.experience_years, specialization=faculty.specialization,
        phone=faculty.phone, email=user.email,
        is_active=faculty.is_active, created_at=faculty.created_at,
    )


@router.put("/{faculty_id}", response_model=FacultyResponse)
async def update_faculty(
    faculty_id: int,
    data: FacultyUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Update a faculty member."""
    result = await db.execute(select(Faculty).where(Faculty.id == faculty_id))
    faculty = result.scalar_one_or_none()
    if not faculty:
        raise HTTPException(status_code=404, detail="Faculty not found")

    update_data = data.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(faculty, key, value)

    await db.flush()
    await db.refresh(faculty)

    dept_result = await db.execute(select(Department).where(Department.id == faculty.department_id))
    dept = dept_result.scalar_one_or_none()
    user_result = await db.execute(select(User).where(User.id == faculty.user_id))
    user = user_result.scalar_one_or_none()

    return FacultyResponse(
        id=faculty.id, user_id=faculty.user_id, faculty_code=faculty.faculty_code,
        name=faculty.name, department_id=faculty.department_id,
        department_name=dept.name if dept else None,
        designation=faculty.designation, qualification=faculty.qualification,
        experience_years=faculty.experience_years, specialization=faculty.specialization,
        phone=faculty.phone, email=user.email if user else None,
        is_active=faculty.is_active, created_at=faculty.created_at,
    )


@router.delete("/{faculty_id}")
async def delete_faculty(
    faculty_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Delete a faculty member and their user account."""
    result = await db.execute(select(Faculty).where(Faculty.id == faculty_id))
    faculty = result.scalar_one_or_none()
    if not faculty:
        raise HTTPException(status_code=404, detail="Faculty not found")

    user_result = await db.execute(select(User).where(User.id == faculty.user_id))
    user = user_result.scalar_one_or_none()

    await db.delete(faculty)
    if user:
        await db.delete(user)

    return {"message": "Faculty deleted successfully"}


@router.patch("/{faculty_id}/toggle-status")
async def toggle_faculty_status(
    faculty_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Toggle faculty active/inactive status."""
    result = await db.execute(select(Faculty).where(Faculty.id == faculty_id))
    faculty = result.scalar_one_or_none()
    if not faculty:
        raise HTTPException(status_code=404, detail="Faculty not found")

    faculty.is_active = not faculty.is_active

    # Also toggle user account
    user_result = await db.execute(select(User).where(User.id == faculty.user_id))
    user = user_result.scalar_one_or_none()
    if user:
        user.is_active = faculty.is_active

    await db.flush()

    return {"message": f"Faculty {'activated' if faculty.is_active else 'deactivated'}", "is_active": faculty.is_active}
