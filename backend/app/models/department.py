"""
Campus Connect ERP — Department Model

Represents an academic department (e.g., Computer Science, Mechanical).
All faculty and students belong to exactly one department.
"""

from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.core.database import Base


class Department(Base):
    __tablename__ = "departments"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(150), unique=True, nullable=False)         # e.g., "Computer Science & Engineering"
    code = Column(String(20), unique=True, nullable=False)          # e.g., "CSE"
    hod_id = Column(Integer, ForeignKey("faculty.id"), nullable=True)  # Nullable until HOD is assigned
    vision = Column(Text, nullable=True)                             # Department Vision
    mission = Column(Text, nullable=True)                            # Department Mission
    peos = Column(Text, nullable=True)                               # Programme Educational Objectives
    psos = Column(Text, nullable=True)                               # Programme Specific Outcomes
    current_sem_start_date = Column(DateTime(timezone=True), nullable=True)
    attendance_closed = Column(Boolean, default=False)
    is_common_first_year = Column(Boolean, default=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    hod = relationship("Faculty", foreign_keys=[hod_id], back_populates="headed_department")
    faculty_members = relationship("Faculty", foreign_keys="Faculty.department_id", back_populates="department")
    students = relationship("Student", foreign_keys="Student.department_id", back_populates="department")
    courses = relationship("Course", back_populates="department")
    sections = relationship("Section", back_populates="department")


class ProgramOutcome(Base):
    """
    Institution-wide Program Outcomes (POs).
    Only one row is maintained (id=1). Editable only by Admin.
    Viewable by all authenticated users.
    """
    __tablename__ = "program_outcomes"

    id = Column(Integer, primary_key=True, index=True)
    outcomes = Column(Text, nullable=True)                           # Full POs text
    updated_by_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    # Relationship
    updated_by = relationship("User", foreign_keys=[updated_by_id])
