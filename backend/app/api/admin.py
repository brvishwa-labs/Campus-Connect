from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import and_
from pydantic import BaseModel
from typing import Optional
from datetime import date as date_type

from app.core.database import get_db
from app.models.department import Department
from app.models.faculty import Faculty
from app.models.student import Student
from app.models.academic import Course
from app.models.user import User
from app.models.attendance import Holiday
from app.core.security import get_current_active_user, get_password_hash
from app.core.holidays import get_academic_year_bounds

router = APIRouter()


# ─────────────────────────────────────────────────────────
# Pydantic schemas
# ─────────────────────────────────────────────────────────
class PasswordResetRequest(BaseModel):
    new_password: str


class HolidayCreate(BaseModel):
    date: date_type
    name: str


# ─────────────────────────────────────────────────────────
# Admin stats
# ─────────────────────────────────────────────────────────
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


# ─────────────────────────────────────────────────────────
# Password reset
# ─────────────────────────────────────────────────────────
@router.post("/users/{user_id}/reset-password")
def reset_user_password(
    user_id: int,
    request: PasswordResetRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Reset a user's password to a new temporary password.
    Only accessible by Admin.
    """
    if current_user.role != "admin":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only admins can reset passwords")
        
    db_user = db.query(User).filter(User.id == user_id).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
        
    if not request.new_password or len(request.new_password) < 6:
        raise HTTPException(status_code=400, detail="Password must be at least 6 characters long")
        
    db_user.hashed_password = get_password_hash(request.new_password)
    db.commit()
    
    return {"message": "Password successfully reset"}


# ─────────────────────────────────────────────────────────
# Holiday CRUD  (GET is public; POST/DELETE require admin)
# ─────────────────────────────────────────────────────────

@router.get("/holidays")
def list_holidays(
    academic_year: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Return all admin-marked holidays for the given academic year (e.g. '2025-2026').
    If no academic_year is supplied, the current academic year is used.
    The response also includes the year bounds so the frontend can render the calendar.
    Sundays are NOT returned here — they are computed client-side.
    """
    start, end = get_academic_year_bounds(academic_year)

    holidays = db.query(Holiday).filter(
        and_(Holiday.date >= start, Holiday.date <= end)
    ).order_by(Holiday.date).all()

    return {
        "academic_year_start": start.isoformat(),
        "academic_year_end": end.isoformat(),
        "holidays": [
            {
                "id": h.id,
                "date": h.date.isoformat(),
                "name": h.name,
                "created_at": h.created_at.isoformat() if h.created_at else None,
            }
            for h in holidays
        ],
    }


@router.post("/holidays", status_code=201)
def create_holiday(
    payload: HolidayCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Mark a date as a holiday. Admin only.
    Sundays cannot be explicitly added (they are already holidays by default).
    """
    if current_user.role != "admin":
        raise HTTPException(status_code=403, detail="Only admins can manage holidays")

    # Reject Sundays — they're already holidays
    if payload.date.weekday() == 6:
        raise HTTPException(status_code=400, detail="Sundays are already holidays by default. No need to add them.")

    if not payload.name or not payload.name.strip():
        raise HTTPException(status_code=400, detail="Holiday name cannot be empty")

    existing = db.query(Holiday).filter(Holiday.date == payload.date).first()
    if existing:
        raise HTTPException(status_code=409, detail=f"A holiday already exists on {payload.date}: '{existing.name}'")

    holiday = Holiday(
        date=payload.date,
        name=payload.name.strip(),
        created_by_id=current_user.id,
    )
    db.add(holiday)
    db.commit()
    db.refresh(holiday)

    return {
        "id": holiday.id,
        "date": holiday.date.isoformat(),
        "name": holiday.name,
        "created_at": holiday.created_at.isoformat() if holiday.created_at else None,
    }


@router.delete("/holidays/{holiday_date}")
def delete_holiday(
    holiday_date: date_type,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Remove a holiday marking by date. Admin only.
    """
    if current_user.role != "admin":
        raise HTTPException(status_code=403, detail="Only admins can manage holidays")

    holiday = db.query(Holiday).filter(Holiday.date == holiday_date).first()
    if not holiday:
        raise HTTPException(status_code=404, detail="No holiday found on this date")

    db.delete(holiday)
    db.commit()
    return {"message": f"Holiday on {holiday_date} removed successfully"}

# ─────────────────────────────────────────────────────────
# Password Reset Requests
# ─────────────────────────────────────────────────────────
@router.get("/password-resets")
def list_password_resets(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    if current_user.role != "admin":
        raise HTTPException(status_code=403, detail="Only admins can view password reset requests")
        
    from app.models.user import PasswordResetRequest
    requests = db.query(PasswordResetRequest).order_by(PasswordResetRequest.created_at.desc()).all()
    return requests

@router.put("/password-resets/{request_id}/resolve")
def resolve_password_reset(
    request_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    if current_user.role != "admin":
        raise HTTPException(status_code=403, detail="Only admins can manage password reset requests")
        
    from app.models.user import PasswordResetRequest
    from datetime import datetime, timezone
    
    req = db.query(PasswordResetRequest).filter(PasswordResetRequest.id == request_id).first()
    if not req:
        raise HTTPException(status_code=404, detail="Request not found")
        
    req.status = "resolved"
    req.resolved_at = datetime.now(timezone.utc)
    db.commit()
    return {"message": "Request marked as resolved"}
