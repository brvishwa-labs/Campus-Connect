"""
Campus Connect ERP — User & Authentication Model

This is the central authentication table. Every person who logs into the
system (admin, hod, faculty, student, authority) has exactly one row here.
The `role` column determines which portal they access.
"""

from sqlalchemy import (
    Column, Integer, String, Boolean, DateTime, Enum as SQLEnum
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum

from app.core.database import Base


class UserRole(str, enum.Enum):
    ADMIN = "admin"
    HOD = "hod"
    FACULTY = "faculty"
    STUDENT = "student"
    AUTHORITY = "authority"
    LATE_TRACKER = "late_tracker"
    ACCOUNTANT = "accountant"


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), unique=True, nullable=False, index=True)
    hashed_password = Column(String(255), nullable=False)
    role = Column(SQLEnum(UserRole), nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships — one user can be linked to one profile
    student_profile = relationship("Student", back_populates="user", uselist=False)
    faculty_profile = relationship("Faculty", back_populates="user", uselist=False)
    authority_profile = relationship("Authority", back_populates="user", uselist=False)


class PasswordResetRequest(Base):
    __tablename__ = "password_reset_requests"

    id = Column(Integer, primary_key=True, index=True)
    role = Column(String(50), nullable=False)
    name = Column(String(255), nullable=False)
    college_id = Column(String(100), nullable=False)
    department = Column(String(100), default="")
    email = Column(String(255), nullable=False)
    status = Column(String(50), default="pending")  # pending, resolved
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    resolved_at = Column(DateTime(timezone=True), nullable=True)
