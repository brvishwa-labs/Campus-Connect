from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from typing import List, Optional
from app.database import get_db
from app.models.course import Course
from app.models.user import User
from app.models.department import Department
from app.schemas.admin import CourseCreate, CourseUpdate, CourseResponse
from app.middleware.auth import require_admin

router = APIRouter(prefix="/api/v1/admin/courses", tags=["Admin - Courses"])


@router.get("/", response_model=List[CourseResponse])
async def get_courses(
    department_id: Optional[int] = None,
    semester: Optional[int] = None,
    regulation: Optional[str] = None,
    is_active: Optional[bool] = None,
    search: Optional[str] = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Get all courses with optional filters."""
    query = select(Course)
    if department_id:
        query = query.where(Course.department_id == department_id)
    if semester:
        query = query.where(Course.semester == semester)
    if regulation:
        query = query.where(Course.regulation == regulation)
    if is_active is not None:
        query = query.where(Course.is_active == is_active)
    if search:
        query = query.where(
            (Course.name.ilike(f"%{search}%")) | (Course.course_code.ilike(f"%{search}%"))
        )
    query = query.order_by(Course.course_code)

    result = await db.execute(query)
    courses = result.scalars().all()

    response = []
    for c in courses:
        dept_result = await db.execute(select(Department).where(Department.id == c.department_id))
        dept = dept_result.scalar_one_or_none()
        response.append(CourseResponse(
            id=c.id, course_code=c.course_code, name=c.name,
            department_id=c.department_id,
            department_name=dept.name if dept else None,
            semester=c.semester, credits=c.credits,
            regulation=c.regulation, academic_year=c.academic_year,
            course_type=c.course_type, description=c.description,
            is_active=c.is_active, created_at=c.created_at,
        ))

    return response


@router.post("/", response_model=CourseResponse, status_code=201)
async def create_course(
    data: CourseCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Create a new course."""
    existing = await db.execute(select(Course).where(Course.course_code == data.course_code))
    if existing.scalar_one_or_none():
        raise HTTPException(status_code=400, detail="Course code already exists")

    course = Course(**data.model_dump())
    db.add(course)
    await db.flush()
    await db.refresh(course)

    dept_result = await db.execute(select(Department).where(Department.id == course.department_id))
    dept = dept_result.scalar_one_or_none()

    return CourseResponse(
        id=course.id, course_code=course.course_code, name=course.name,
        department_id=course.department_id,
        department_name=dept.name if dept else None,
        semester=course.semester, credits=course.credits,
        regulation=course.regulation, academic_year=course.academic_year,
        course_type=course.course_type, description=course.description,
        is_active=course.is_active, created_at=course.created_at,
    )


@router.put("/{course_id}", response_model=CourseResponse)
async def update_course(
    course_id: int,
    data: CourseUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Update a course."""
    result = await db.execute(select(Course).where(Course.id == course_id))
    course = result.scalar_one_or_none()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    update_data = data.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(course, key, value)

    await db.flush()
    await db.refresh(course)

    dept_result = await db.execute(select(Department).where(Department.id == course.department_id))
    dept = dept_result.scalar_one_or_none()

    return CourseResponse(
        id=course.id, course_code=course.course_code, name=course.name,
        department_id=course.department_id,
        department_name=dept.name if dept else None,
        semester=course.semester, credits=course.credits,
        regulation=course.regulation, academic_year=course.academic_year,
        course_type=course.course_type, description=course.description,
        is_active=course.is_active, created_at=course.created_at,
    )


@router.delete("/{course_id}")
async def delete_course(
    course_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Delete a course."""
    result = await db.execute(select(Course).where(Course.id == course_id))
    course = result.scalar_one_or_none()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    await db.delete(course)
    return {"message": "Course deleted successfully"}
