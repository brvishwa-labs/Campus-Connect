from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.models.department import Department
from app.models.faculty import Faculty
from app.models.student import Student
from app.models.academic import Course
from app.models.user import User
from app.core.security import get_current_active_user

router = APIRouter()

@router.get("/stats")
def get_admin_stats(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Get live metrics for the Admin Dashboard.
    """
    dept_count = db.query(Department).count()
    faculty_count = db.query(Faculty).count()
    student_count = db.query(Student).count()
    course_count = db.query(Course).count()
    
    # Calculate active users vs total records roughly
    total_records = dept_count + faculty_count + student_count + course_count
    active_users = db.query(User).filter(User.is_active == True).count()
    
    return {
        "departments": dept_count,
        "faculty": faculty_count,
        "students": student_count,
        "courses": course_count,
        "total_records": total_records,
        "active_users": active_users
    }
