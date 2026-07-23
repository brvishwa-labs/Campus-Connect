"""
Campus Connect ERP — Fees Module Models

New tables (additive — existing tables unchanged):
  1. fee_structures           — flat fee per department + semester + year
  2. student_fee_assignments  — links a student to a fee structure
  3. payments                 — individual payment records (manual or tally_upload)
  4. tally_ledger_mappings    — confirmed ledger_name → student_id mappings
  5. unmapped_ledger_entries  — Tally rows that could not be auto-matched
"""

from sqlalchemy import (
    Column, Integer, String, Numeric, Date, DateTime,
    ForeignKey, Enum as SQLEnum, Text, UniqueConstraint
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum

from app.core.database import Base


# ── Enums ────────────────────────────────────────────────────────────────────

class PaymentMode(str, enum.Enum):
    CASH = "cash"
    DD = "dd"
    CHEQUE = "cheque"
    BANK_TRANSFER = "bank_transfer"
    TALLY_SYNC = "tally_sync"


class PaymentSource(str, enum.Enum):
    MANUAL = "manual"
    TALLY_UPLOAD = "tally_upload"


class UnmappedStatus(str, enum.Enum):
    PENDING = "pending"
    RESOLVED = "resolved"
    SKIPPED = "skipped"


# ── Models ───────────────────────────────────────────────────────────────────

class FeeStructure(Base):
    """
    Flat fee amount for a given department + semester combination.
    One row per (department_id, semester, academic_year).
    """
    __tablename__ = "fee_structures"

    id = Column(Integer, primary_key=True, index=True)
    department_id = Column(Integer, ForeignKey("departments.id"), nullable=False)
    semester = Column(Integer, nullable=False)       # 1–8
    amount = Column(Numeric(12, 2), nullable=False)  # total flat fee
    academic_year = Column(String(20), nullable=False)  # e.g. "2024-2025"
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    __table_args__ = (
        UniqueConstraint("department_id", "semester", "academic_year",
                         name="uq_fee_structure_dept_sem_year"),
    )

    # Relationships
    department = relationship("Department", foreign_keys=[department_id])
    assignments = relationship("StudentFeeAssignment", back_populates="fee_structure",
                               cascade="all, delete-orphan")


class StudentFeeAssignment(Base):
    """
    Assigns a FeeStructure to a specific student for a semester.
    Created manually via the admin portal or triggered after promotion.
    """
    __tablename__ = "student_fee_assignments"

    id = Column(Integer, primary_key=True, index=True)
    student_id = Column(Integer, ForeignKey("students.id"), nullable=False, index=True)
    fee_structure_id = Column(Integer, ForeignKey("fee_structures.id"), nullable=True)  # nullable: opening balances don't require a fee structure
    amount_due = Column(Numeric(12, 2), nullable=False)
    semester = Column(Integer, nullable=False)
    academic_year = Column(String(20), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    __table_args__ = (
        UniqueConstraint("student_id", "semester", "academic_year",
                         name="uq_fee_assignment_student_sem_year"),
    )

    # Relationships
    student = relationship("Student", foreign_keys=[student_id])
    fee_structure = relationship("FeeStructure", back_populates="assignments")


class Payment(Base):
    """
    Individual payment record.
    source='manual'        — entered directly by accountant
    source='tally_upload'  — imported from a Tally CSV/Excel export
    """
    __tablename__ = "payments"

    id = Column(Integer, primary_key=True, index=True)
    student_id = Column(Integer, ForeignKey("students.id"), nullable=False, index=True)
    amount = Column(Numeric(12, 2), nullable=False)
    payment_date = Column(Date, nullable=False)
    mode = Column(SQLEnum(PaymentMode), nullable=False, default=PaymentMode.CASH)
    receipt_no = Column(String(100), nullable=True)
    voucher_no = Column(String(100), nullable=True, index=True)
    ledger_name_raw = Column(String(500), nullable=True)  # original Tally ledger string
    source = Column(SQLEnum(PaymentSource), nullable=False, default=PaymentSource.MANUAL)
    uploaded_by = Column(Integer, ForeignKey("users.id"), nullable=True)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Prevent duplicate Tally imports: same voucher + same ledger = duplicate
    __table_args__ = (
        UniqueConstraint("voucher_no", "ledger_name_raw",
                         name="uq_payment_voucher_ledger"),
    )

    # Relationships
    student = relationship("Student", foreign_keys=[student_id])
    uploader = relationship("User", foreign_keys=[uploaded_by])


class TallyLedgerMapping(Base):
    """
    Confirmed mapping from a Tally ledger name string to a student.
    Once confirmed, future uploads with the same ledger_name_raw will
    auto-match to this student without manual intervention.
    """
    __tablename__ = "tally_ledger_mappings"

    id = Column(Integer, primary_key=True, index=True)
    ledger_name_raw = Column(String(500), unique=True, nullable=False, index=True)
    student_id = Column(Integer, ForeignKey("students.id"), nullable=False, index=True)
    confirmed_by = Column(Integer, ForeignKey("users.id"), nullable=True)
    confirmed_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    student = relationship("Student", foreign_keys=[student_id])
    confirmer = relationship("User", foreign_keys=[confirmed_by])


class UnmappedLedgerEntry(Base):
    """
    Tally rows that could not be auto-matched to a student.
    Accountant manually reviews these and either resolves (links to student)
    or skips them.
    """
    __tablename__ = "unmapped_ledger_entries"

    id = Column(Integer, primary_key=True, index=True)
    ledger_name_raw = Column(String(500), nullable=False)
    amount = Column(Numeric(12, 2), nullable=False)
    payment_date = Column(Date, nullable=True)
    voucher_no = Column(String(100), nullable=True, index=True)
    status = Column(SQLEnum(UnmappedStatus), nullable=False, default=UnmappedStatus.PENDING)
    entry_type = Column(String(50), nullable=False, default="payment")  # payment or opening_balance
    suggested_student_id = Column(Integer, ForeignKey("students.id"), nullable=True)
    upload_batch = Column(String(100), nullable=True)  # timestamp/identifier of the upload batch
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    suggested_student = relationship("Student", foreign_keys=[suggested_student_id])
