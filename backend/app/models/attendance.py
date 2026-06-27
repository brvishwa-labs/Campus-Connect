"""
Campus Connect ERP — Attendance & Leave Models

Tracks per-class attendance and student leave request workflow.
"""

from sqlalchemy import (
    Column, Integer, String, Date, DateTime, ForeignKey, Boolean,
    Text, Enum as SQLEnum
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum

from app.core.database import Base


# ──────────────────────────────────────────────────
# ATTENDANCE (Per student, per course, per date)
# ──────────────────────────────────────────────────
class AttendanceStatus(str, enum.Enum):
    PRESENT = "present"
    ABSENT = "absent"
    ON_DUTY = "on_duty"
    LATE = "late"


class Attendance(Base):
    __tablename__ = "attendance"

    id = Column(Integer, primary_key=True, index=True)
    student_id = Column(Integer, ForeignKey("students.id"), nullable=False)
    course_id = Column(Integer, ForeignKey("courses.id"), nullable=False)
    date = Column(Date, nullable=False)
    hour = Column(Integer, nullable=True)                     # 1-7 period number
    status = Column(SQLEnum(AttendanceStatus), nullable=False, default=AttendanceStatus.PRESENT)
    marked_by_id = Column(Integer, ForeignKey("faculty.id"), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    student = relationship("Student", back_populates="attendance_records")
    course = relationship("Course", back_populates="attendance_records")
    marked_by = relationship("Faculty")


# ──────────────────────────────────────────────────
# LEAVE REQUEST (Multi-step approval workflow)
# ──────────────────────────────────────────────────
class LeaveStatus(str, enum.Enum):
    PENDING = "pending"
    APPROVED_MENTOR = "approved_mentor"
    APPROVED_HOD = "approved_hod"
    REJECTED = "rejected"
    CANCELLED = "cancelled"


class LeaveType(str, enum.Enum):
    SICK = "sick"
    PERSONAL = "personal"
    ON_DUTY = "on_duty"
    EMERGENCY = "emergency"


class LeaveRequest(Base):
    __tablename__ = "leave_requests"

    id = Column(Integer, primary_key=True, index=True)
    student_id = Column(Integer, ForeignKey("students.id"), nullable=False)
    leave_type = Column(SQLEnum(LeaveType), nullable=False)
    from_date = Column(Date, nullable=False)
    to_date = Column(Date, nullable=False)
    reason = Column(Text, nullable=False)
    status = Column(SQLEnum(LeaveStatus), default=LeaveStatus.PENDING)
    
    # Approval tracking
    mentor_approved_by = Column(Integer, ForeignKey("faculty.id"), nullable=True)
    mentor_approved_at = Column(DateTime(timezone=True), nullable=True)
    hod_approved_by = Column(Integer, ForeignKey("faculty.id"), nullable=True)
    hod_approved_at = Column(DateTime(timezone=True), nullable=True)
    rejection_reason = Column(Text, nullable=True)

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    student = relationship("Student", back_populates="leave_requests")
    mentor_approver = relationship("Faculty", foreign_keys=[mentor_approved_by])
    hod_approver = relationship("Faculty", foreign_keys=[hod_approved_by])
