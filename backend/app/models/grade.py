"""
Campus Connect ERP — Grading & Assessment Models
"""

from sqlalchemy import (
    Column, Integer, String, DateTime, ForeignKey, Numeric, Text, Enum as SQLEnum
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum

from app.core.database import Base


class GradeType(str, enum.Enum):
    INTERNAL_1 = "internal_1"
    INTERNAL_2 = "internal_2"
    INTERNAL_3 = "internal_3"
    ASSIGNMENT = "assignment"
    LAB = "lab"
    EXTERNAL = "external"


class Grade(Base):
    __tablename__ = "grades"

    id = Column(Integer, primary_key=True, index=True)
    student_id = Column(Integer, ForeignKey("students.id"), nullable=False)
    course_id = Column(Integer, ForeignKey("courses.id"), nullable=False)
    grade_type = Column(SQLEnum(GradeType), nullable=False)
    marks_obtained = Column(Numeric(6, 2), nullable=False)
    max_marks = Column(Numeric(6, 2), nullable=False, default=100)
    academic_year = Column(String(20), nullable=False)
    semester = Column(Integer, nullable=False)
    graded_by_id = Column(Integer, ForeignKey("faculty.id"), nullable=True)
    remarks = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    student = relationship("Student", back_populates="grades")
    course = relationship("Course", back_populates="grades")
    graded_by = relationship("Faculty")
