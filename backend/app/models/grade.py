"""
Campus Connect ERP — Grading & Assessment Models
"""

from sqlalchemy import (
    Column, Integer, String, DateTime, Date, ForeignKey, Numeric, Text, Boolean,
    Enum as SQLEnum, UniqueConstraint
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum

from app.core.database import Base


class GradeType(str, enum.Enum):
    INTERNAL_1  = "internal_1"   # CIA 1  — max 50
    INTERNAL_2  = "internal_2"   # CIA 2  — max 50
    MODEL_EXAM  = "model_exam"   # Model Exam — max 60
    ASSIGNMENT  = "assignment"
    LAB         = "lab"
    EXTERNAL    = "external"


# Fixed max marks per assessment type
GRADE_MAX_MARKS = {
    GradeType.INTERNAL_1: 50,
    GradeType.INTERNAL_2: 50,
    GradeType.MODEL_EXAM: 60,
    GradeType.ASSIGNMENT: 100,
    GradeType.LAB:        100,
    GradeType.EXTERNAL:   100,
}

# Passing threshold per assessment type
GRADE_PASS_MARKS = {
    GradeType.INTERNAL_1: 25,
    GradeType.INTERNAL_2: 25,
    GradeType.MODEL_EXAM: 30,
}


class Grade(Base):
    __tablename__ = "grades"

    id             = Column(Integer, primary_key=True, index=True)
    student_id     = Column(Integer, ForeignKey("students.id"), nullable=False)
    course_id      = Column(Integer, ForeignKey("courses.id"), nullable=False)
    grade_type     = Column(SQLEnum(GradeType), nullable=False)
    marks_obtained = Column(Numeric(6, 2), nullable=True)   # nullable = absent
    max_marks      = Column(Numeric(6, 2), nullable=False, default=100)
    academic_year  = Column(String(20), nullable=False)
    semester       = Column(Integer, nullable=False)
    graded_by_id   = Column(Integer, ForeignKey("faculty.id"), nullable=True)
    remarks        = Column(Text, nullable=True)
    is_published   = Column(Boolean, default=False, nullable=False)
    is_absent      = Column(Boolean, default=False, nullable=False)
    test_date      = Column(Date, nullable=True)                            # Date the test was conducted
    created_at     = Column(DateTime(timezone=True), server_default=func.now())
    updated_at     = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    student    = relationship("Student", back_populates="grades")
    course     = relationship("Course", back_populates="grades")
    graded_by  = relationship("Faculty")


class AssignmentGrade(Base):
    __tablename__ = "assignment_grades"

    id             = Column(Integer, primary_key=True, index=True)
    assignment_id  = Column(Integer, ForeignKey("lms_resources.id", ondelete="CASCADE"), nullable=False)
    student_id     = Column(Integer, ForeignKey("students.id", ondelete="CASCADE"), nullable=False)
    marks_obtained = Column(Numeric(6, 2), nullable=True)
    max_marks      = Column(Numeric(6, 2), nullable=False, default=100)
    is_absent      = Column(Boolean, default=False, nullable=False)
    is_published   = Column(Boolean, default=False, nullable=False)
    remarks        = Column(Text, nullable=True)
    created_at     = Column(DateTime(timezone=True), server_default=func.now())
    updated_at     = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    assignment     = relationship("LMSResource")
    student        = relationship("Student")


class Seminar(Base):
    __tablename__ = "seminars"

    id                    = Column(Integer, primary_key=True, index=True)
    course_assignment_id  = Column(Integer, ForeignKey("course_assignments.id", ondelete="CASCADE"), nullable=False)
    student_id            = Column(Integer, ForeignKey("students.id", ondelete="CASCADE"), nullable=False)
    seminar_date          = Column(DateTime(timezone=True), nullable=True)
    seminar_topic         = Column(Text, nullable=True)
    marks_obtained            = Column(Numeric(6, 2), nullable=True)
    max_marks                 = Column(Numeric(6, 2), nullable=False, default=100)
    is_topic_published        = Column(Boolean, default=False, nullable=False)
    is_marks_published        = Column(Boolean, default=False, nullable=False)
    # Rubric scoring columns
    rubric_content_relevance  = Column(Numeric(4, 2), nullable=True)    # out of configured max
    rubric_presentation_skills= Column(Numeric(4, 2), nullable=True)
    rubric_resources_used     = Column(Numeric(4, 2), nullable=True)
    rubric_time_management    = Column(Numeric(4, 2), nullable=True)
    rubric_question_handling  = Column(Numeric(4, 2), nullable=True)    # max 2
    rubric_team_coordination  = Column(Numeric(4, 2), nullable=True)    # max 1
    created_at                = Column(DateTime(timezone=True), server_default=func.now())
    updated_at                = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    course_assignment     = relationship("CourseAssignment")
    student               = relationship("Student")



# ──────────────────────────────────────────────────
# LAB MARK (Per student per course assignment)
# Stores: Record (/30), IA-1 (/15), IA-2 (/15), Viva (/5)
# Computed: Avg IA = (IA-1+IA-2)/2, Att marks /10, Total /60
# ──────────────────────────────────────────────────
class LabMark(Base):
    __tablename__ = "lab_marks"

    id                   = Column(Integer, primary_key=True, index=True)
    course_assignment_id = Column(Integer, ForeignKey("course_assignments.id", ondelete="CASCADE"), nullable=False)
    student_id           = Column(Integer, ForeignKey("students.id", ondelete="CASCADE"), nullable=False)

    # Manual entry columns
    record_marks         = Column(Numeric(5, 2), nullable=True)   # /30
    ia1_marks            = Column(Numeric(5, 2), nullable=True)   # /15
    ia2_marks            = Column(Numeric(5, 2), nullable=True)   # /15
    viva_marks           = Column(Numeric(5, 2), nullable=True)   # /5

    # Published flag — once True, students can see their marks
    is_published         = Column(Boolean, default=False, nullable=False)

    graded_by_id         = Column(Integer, ForeignKey("faculty.id"), nullable=True)
    created_at           = Column(DateTime(timezone=True), server_default=func.now())
    updated_at           = Column(DateTime(timezone=True), onupdate=func.now())

    # Unique: one mark row per student per course assignment
    __table_args__ = (
        UniqueConstraint("course_assignment_id", "student_id", name="uq_lab_mark_assignment_student"),
    )

    # Relationships
    course_assignment    = relationship("CourseAssignment")
    student              = relationship("Student")
    graded_by            = relationship("Faculty")
