from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from app.database import get_db
from app.models.user import User, UserRole
from app.models.department import Department
from app.models.student import Student
from app.models.faculty import Faculty
from app.models.course import Course
from app.middleware.auth import require_admin

router = APIRouter(prefix="/api/v1/dashboard", tags=["Dashboard"])


@router.get("/admin")
async def get_admin_dashboard_stats(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Get aggregated statistics for the admin dashboard."""
    # Counts
    students_count = await db.execute(select(func.count(Student.id)).where(Student.is_active == True))
    faculty_count = await db.execute(select(func.count(Faculty.id)).where(Faculty.is_active == True))
    departments_count = await db.execute(select(func.count(Department.id)).where(Department.is_active == True))
    courses_count = await db.execute(select(func.count(Course.id)).where(Course.is_active == True))
    hods_count = await db.execute(select(func.count(Department.id)).where(Department.hod_id.isnot(None)))
    active_users_count = await db.execute(select(func.count(User.id)).where(User.is_active == True))

    return {
        "stats": {
            "total_students": students_count.scalar() or 0,
            "total_faculty": faculty_count.scalar() or 0,
            "total_departments": departments_count.scalar() or 0,
            "total_courses": courses_count.scalar() or 0,
            "total_hods": hods_count.scalar() or 0,
            "active_users": active_users_count.scalar() or 0,
        }
    }
