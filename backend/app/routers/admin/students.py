from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from typing import List, Optional
from app.database import get_db
from app.models.student import Student
from app.models.user import User, UserRole
from app.models.department import Department
from app.schemas.admin import StudentCreate, StudentUpdate, StudentResponse, BatchPromoteRequest
from app.middleware.auth import require_admin
from app.utils.hashing import hash_password

router = APIRouter(prefix="/api/v1/admin/students", tags=["Admin - Students"])


@router.get("/", response_model=List[StudentResponse])
async def get_students(
    department_id: Optional[int] = None,
    year: Optional[int] = None,
    semester: Optional[int] = None,
    section: Optional[str] = None,
    is_active: Optional[bool] = None,
    search: Optional[str] = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Get all students with optional filters."""
    query = select(Student)
    if department_id:
        query = query.where(Student.department_id == department_id)
    if year:
        query = query.where(Student.year == year)
    if semester:
        query = query.where(Student.semester == semester)
    if section:
        query = query.where(Student.section == section)
    if is_active is not None:
        query = query.where(Student.is_active == is_active)
    if search:
        query = query.where(
            (Student.name.ilike(f"%{search}%")) | (Student.register_no.ilike(f"%{search}%"))
        )
    query = query.order_by(Student.register_no)

    result = await db.execute(query)
    students = result.scalars().all()

    response = []
    for s in students:
        dept_result = await db.execute(select(Department).where(Department.id == s.department_id))
        dept = dept_result.scalar_one_or_none()
        user_result = await db.execute(select(User).where(User.id == s.user_id))
        user = user_result.scalar_one_or_none()

        response.append(StudentResponse(
            id=s.id, user_id=s.user_id, register_no=s.register_no,
            name=s.name, department_id=s.department_id,
            department_name=dept.name if dept else None,
            year=s.year, semester=s.semester, section=s.section,
            batch=s.batch, academic_year=s.academic_year,
            phone=s.phone, parent_phone=s.parent_phone,
            email=user.email if user else None,
            is_active=s.is_active, created_at=s.created_at,
        ))

    return response


@router.post("/", response_model=StudentResponse, status_code=201)
async def create_student(
    data: StudentCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Create a new student with user account."""
    existing_user = await db.execute(select(User).where(User.email == data.email))
    if existing_user.scalar_one_or_none():
        raise HTTPException(status_code=400, detail="Email already registered")

    existing_student = await db.execute(select(Student).where(Student.register_no == data.register_no))
    if existing_student.scalar_one_or_none():
        raise HTTPException(status_code=400, detail="Register number already exists")

    user = User(
        email=data.email,
        password_hash=hash_password(data.password),
        full_name=data.name,
        role=UserRole.STUDENT,
        phone=data.phone,
    )
    db.add(user)
    await db.flush()

    student = Student(
        user_id=user.id,
        register_no=data.register_no,
        name=data.name,
        department_id=data.department_id,
        year=data.year,
        semester=data.semester,
        section=data.section,
        batch=data.batch,
        academic_year=data.academic_year,
        phone=data.phone,
        parent_phone=data.parent_phone,
        address=data.address,
    )
    db.add(student)
    await db.flush()
    await db.refresh(student)

    dept_result = await db.execute(select(Department).where(Department.id == data.department_id))
    dept = dept_result.scalar_one_or_none()

    return StudentResponse(
        id=student.id, user_id=user.id, register_no=student.register_no,
        name=student.name, department_id=student.department_id,
        department_name=dept.name if dept else None,
        year=student.year, semester=student.semester, section=student.section,
        batch=student.batch, academic_year=student.academic_year,
        phone=student.phone, parent_phone=student.parent_phone,
        email=user.email, is_active=student.is_active, created_at=student.created_at,
    )


@router.put("/{student_id}", response_model=StudentResponse)
async def update_student(
    student_id: int,
    data: StudentUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Update a student."""
    result = await db.execute(select(Student).where(Student.id == student_id))
    student = result.scalar_one_or_none()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    update_data = data.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(student, key, value)

    await db.flush()
    await db.refresh(student)

    dept_result = await db.execute(select(Department).where(Department.id == student.department_id))
    dept = dept_result.scalar_one_or_none()
    user_result = await db.execute(select(User).where(User.id == student.user_id))
    user = user_result.scalar_one_or_none()

    return StudentResponse(
        id=student.id, user_id=student.user_id, register_no=student.register_no,
        name=student.name, department_id=student.department_id,
        department_name=dept.name if dept else None,
        year=student.year, semester=student.semester, section=student.section,
        batch=student.batch, academic_year=student.academic_year,
        phone=student.phone, parent_phone=student.parent_phone,
        email=user.email if user else None,
        is_active=student.is_active, created_at=student.created_at,
    )


@router.delete("/{student_id}")
async def delete_student(
    student_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Delete a student and their user account."""
    result = await db.execute(select(Student).where(Student.id == student_id))
    student = result.scalar_one_or_none()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    user_result = await db.execute(select(User).where(User.id == student.user_id))
    user = user_result.scalar_one_or_none()

    await db.delete(student)
    if user:
        await db.delete(user)

    return {"message": "Student deleted successfully"}


@router.patch("/{student_id}/toggle-status")
async def toggle_student_status(
    student_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Toggle student active/inactive status."""
    result = await db.execute(select(Student).where(Student.id == student_id))
    student = result.scalar_one_or_none()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    student.is_active = not student.is_active
    user_result = await db.execute(select(User).where(User.id == student.user_id))
    user = user_result.scalar_one_or_none()
    if user:
        user.is_active = student.is_active

    await db.flush()
    return {"message": f"Student {'activated' if student.is_active else 'deactivated'}", "is_active": student.is_active}


@router.post("/batch-promote")
async def batch_promote(
    data: BatchPromoteRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Promote students batch-wise."""
    query = select(Student).where(
        Student.year == data.from_year,
        Student.semester == data.from_semester,
        Student.is_active == True,
    )
    if data.department_id:
        query = query.where(Student.department_id == data.department_id)

    result = await db.execute(query)
    students = result.scalars().all()

    count = 0
    for student in students:
        student.year = data.to_year
        student.semester = data.to_semester
        count += 1

    await db.flush()
    return {"message": f"Successfully promoted {count} students", "count": count}
