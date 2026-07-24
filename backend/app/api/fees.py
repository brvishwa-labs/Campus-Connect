"""
Campus Connect ERP — Fees & Accounts API Router

Prefix : /api/fees
Auth   : get_current_active_user (JWT Bearer)
Roles  : admin-only for management endpoints; student can read own data

Endpoints:
  Upload & Parsing
    POST   /upload                     — parse CSV/Excel Tally export
    GET    /uploads/history            — list past uploads

  Unmapped Queue
    GET    /unmapped                   — list pending unmapped entries
    POST   /unmapped/{id}/resolve      — link entry to student + create Payment
    POST   /unmapped/{id}/skip         — mark entry as skipped

  Manual Payment
    GET    /students/search            — search students (admin use)
    POST   /payments/manual            — create manual Payment

  Fee Structure (CRUD)
    GET    /structure                  — list all FeeStructures
    POST   /structure                  — create FeeStructure
    PUT    /structure/{id}             — update FeeStructure
    DELETE /structure/{id}             — delete FeeStructure

  Student Fee Assignments
    GET    /assignments                — list all assignments (admin)
    POST   /assignments/generate       — generate assignments for a semester batch

  Student-Facing
    GET    /student/{student_id}/summary — total_due, total_paid, balance
    GET    /student/{student_id}/history — full payment list for student

  Ledger Mapping Management
    GET    /mappings                   — list confirmed mappings
    PUT    /mappings/{id}              — update a mapping
    DELETE /mappings/{id}              — delete a mapping

  Reports
    GET    /reports/defaulters         — students with balance > 0
    GET    /reports/collection-summary — monthly totals by department
"""

import csv
import io
import re
import datetime
from typing import Optional, List
from decimal import Decimal, InvalidOperation

from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Query, status
from pydantic import BaseModel
from sqlalchemy.orm import Session
from sqlalchemy import func, or_

from app.core.database import get_db
from app.core.security import get_current_active_user
from app.models.user import User
from app.models.student import Student
from app.models.department import Department
from app.models.fees import (
    FeeStructure, StudentFeeAssignment, Payment,
    TallyLedgerMapping, UnmappedLedgerEntry, UploadBatch,
    PaymentMode, PaymentSource, UnmappedStatus,
)

router = APIRouter()


# ─────────────────────────────────────────────────────────────────────────────
# Auth helpers
# ─────────────────────────────────────────────────────────────────────────────

def require_admin(current_user: User = Depends(get_current_active_user)) -> User:
    role = current_user.role.value if hasattr(current_user.role, "value") else current_user.role
    if role not in ("admin", "accountant"):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access restricted to admin or accountant users"
        )
    return current_user


def require_student_or_admin(
    student_id: int,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
) -> User:
    """Allow admin to read any student's data; allow student to read only their own."""
    role = current_user.role.value if hasattr(current_user.role, "value") else current_user.role
    if role in ("admin", "accountant"):
        return current_user
    if role == "student":
        student = db.query(Student).filter(Student.user_id == current_user.id).first()
        if student and student.id == student_id:
            return current_user
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="Access denied"
    )


# ─────────────────────────────────────────────────────────────────────────────
# Pydantic Schemas (inline — keeps fees self-contained)
# ─────────────────────────────────────────────────────────────────────────────

class FeeStructureCreate(BaseModel):
    department_id: int
    semester: int
    amount: float
    academic_year: str


class FeeStructureUpdate(BaseModel):
    department_id: Optional[int] = None
    semester: Optional[int] = None
    amount: Optional[float] = None
    academic_year: Optional[str] = None


class ManualPaymentCreate(BaseModel):
    student_id: int
    amount: float
    payment_date: str          # ISO date string: "2024-03-15"
    mode: str = "cash"         # PaymentMode value
    receipt_no: Optional[str] = None
    notes: Optional[str] = None


class ResolveUnmappedRequest(BaseModel):
    student_id: int


class AssignmentGenerateRequest(BaseModel):
    department_id: int
    semester: int
    academic_year: str


class LedgerMappingUpdate(BaseModel):
    student_id: int


# ─────────────────────────────────────────────────────────────────────────────
# Utility: parse CSV or Excel file into list of dicts
# ─────────────────────────────────────────────────────────────────────────────

def _parse_file(file: UploadFile) -> List[dict]:
    """
    Parse uploaded CSV or Excel file.
    Returns list of row dicts with normalised keys:
      ledger_name, amount, payment_date, voucher_no
    Raises HTTPException on format errors.
    """
    filename = (file.filename or "").lower()
    content = file.file.read()

    if filename.endswith(".csv"):
        return _parse_csv(content)
    elif filename.endswith((".xlsx", ".xls")):
        return _parse_excel(content)
    else:
        raise HTTPException(
            status_code=400,
            detail="Unsupported file format. Upload a .csv or .xlsx file."
        )


def _normalise_header(header: str) -> str:
    return header.strip().lower().replace(" ", "_").replace("/", "_")


def _coerce_amount(val) -> Optional[Decimal]:
    if val is None:
        return None
    try:
        cleaned = str(val).replace(",", "").replace(" ", "").strip()
        if not cleaned or cleaned in ("-", ""):
            return None
        return Decimal(cleaned)
    except InvalidOperation:
        return None


def _coerce_date(val) -> Optional[datetime.date]:
    if not val:
        return None
    if isinstance(val, datetime.datetime):
        return val.date()
    if isinstance(val, datetime.date):
        return val
    s = str(val).strip()
    for fmt in ("%d-%m-%Y", "%d/%m/%Y", "%Y-%m-%d", "%m/%d/%Y", "%d-%b-%Y"):
        try:
            return datetime.datetime.strptime(s, fmt).date()
        except ValueError:
            continue
    return None


def _parse_raw_rows(all_rows: List[list]) -> List[dict]:
    # 1. Scan first 20 rows to find header
    header_row_idx = -1
    ledger_col_idx = -1
    
    ledger_keywords = {"particulars", "ledger_name", "name"}
    
    for i in range(min(20, len(all_rows))):
        row = all_rows[i]
        if not row: continue
        for j, cell in enumerate(row):
            if cell:
                val = str(cell).strip().lower().replace(" ", "_")
                if val in ledger_keywords:
                    header_row_idx = i
                    ledger_col_idx = j
                    break
        if header_row_idx != -1:
            break
            
    if header_row_idx == -1:
        raise HTTPException(
            status_code=422,
            detail="Could not find a Particulars/Ledger Name column in this file — please check the export format."
        )

    # 2. Extract column mappings
    header_row = all_rows[header_row_idx]
    
    date_col_idx = -1
    vch_col_idx = -1
    amount_col_idx = -1
    debit_col_idx = -1
    credit_col_idx = -1
    
    sub_header_row = all_rows[header_row_idx + 1] if header_row_idx + 1 < len(all_rows) else []
    
    def normalize(val):
        if not val: return ""
        return str(val).strip().lower().replace(" ", "_").replace("/", "_")

    for idx, cell in enumerate(header_row):
        norm = normalize(cell)
        if norm in ("date", "payment_date"):
            date_col_idx = idx
        elif norm in ("voucher_no", "vch_no", "voucher_no.", "vchno"):
            vch_col_idx = idx
        elif norm in ("amount", "closing_balance", "closing balance"):
            amount_col_idx = idx
        elif norm == "debit":
            debit_col_idx = idx
        elif norm == "credit":
            credit_col_idx = idx

    if debit_col_idx == -1 and credit_col_idx == -1:
        for idx, cell in enumerate(sub_header_row):
            norm = normalize(cell)
            if norm == "debit":
                debit_col_idx = idx
            elif norm == "credit":
                credit_col_idx = idx

    # 3. Process data rows
    parsed_rows = []
    for row in all_rows[header_row_idx + 1:]:
        if not row: continue
        
        ledger_name = str(row[ledger_col_idx]).strip() if ledger_col_idx < len(row) and row[ledger_col_idx] is not None else ""
        
        if not ledger_name:
            continue
            
        if ledger_name.lower() == "grand total":
            break
            
        amount_val = None
        if debit_col_idx != -1 and debit_col_idx < len(row):
            amount_val = row[debit_col_idx]
        
        if not amount_val and credit_col_idx != -1 and credit_col_idx < len(row):
            amount_val = row[credit_col_idx]
            
        if not amount_val and amount_col_idx != -1 and amount_col_idx < len(row):
            amount_val = row[amount_col_idx]
            
        amount = _coerce_amount(amount_val)
        if amount is None or amount <= 0:
            continue
            
        payment_date = _coerce_date(row[date_col_idx]) if date_col_idx != -1 and date_col_idx < len(row) else None
        voucher_no = str(row[vch_col_idx]).strip() if vch_col_idx != -1 and vch_col_idx < len(row) and row[vch_col_idx] is not None else None
        if not voucher_no: voucher_no = None
        
        parsed_rows.append({
            "ledger_name": ledger_name,
            "amount": amount,
            "payment_date": payment_date,
            "voucher_no": voucher_no
        })
        
    return parsed_rows


def _parse_csv(content: bytes) -> List[dict]:
    try:
        text = content.decode("utf-8-sig")
    except UnicodeDecodeError:
        text = content.decode("latin-1")

    reader = csv.reader(io.StringIO(text))
    all_rows = list(reader)
    if not all_rows:
        raise HTTPException(status_code=422, detail="CSV file is empty.")
    return _parse_raw_rows(all_rows)


def _parse_excel(content: bytes) -> List[dict]:
    try:
        import openpyxl
    except ImportError:
        raise HTTPException(status_code=500, detail="openpyxl is not installed on the server.")

    wb = openpyxl.load_workbook(io.BytesIO(content), read_only=True, data_only=True)
    ws = wb.active

    all_rows = list(ws.iter_rows(values_only=True))
    if not all_rows:
        raise HTTPException(status_code=422, detail="Excel file is empty.")

    wb.close()
    return _parse_raw_rows(all_rows)


# ─────────────────────────────────────────────────────────────────────────────
# Suggestion helper: try to find a student from ledger name patterns
# ─────────────────────────────────────────────────────────────────────────────

def _smart_match_student(ledger_name: str, db: Session) -> tuple[Optional[int], Optional[str]]:
    """
    Parses ledger name formatted as "Name (Dept Year)".
    Returns (student_id, None) if exactly one match.
    Returns (None, parsed_query_string) if 0 or >1 match.
    """
    if not ledger_name:
        return None, None

    match = re.match(r'^(.*?)\s*\((.*?)\)$', ledger_name.strip())
    if not match:
        return None, None

    name_part = match.group(1).strip()
    meta_part = match.group(2).strip()

    meta_match = re.match(
        r'^(?:\w+\s*-\s*)?([A-Za-z]+)\s*/\s*((?:19|20)\d{2}(?:-(?:19|20)?\d{2})?)$',
        meta_part
    )
    if not meta_match:
        return None, None

    dept_code = meta_match.group(1).upper()
    batch_year = meta_match.group(2).replace(' ', '')

    normalized_name = re.sub(r'[^\w\s]', ' ', name_part).strip()
    normalized_name = re.sub(r'\s+', ' ', normalized_name)

    suggested_query = normalized_name

    dept = db.query(Department).filter(func.upper(Department.code) == dept_code).first()
    if not dept:
        return None, suggested_query

    words = normalized_name.split()
    query = db.query(Student).filter(
        Student.department_id == dept.id,
        func.replace(Student.batch, ' ', '').ilike(f"%{batch_year}%")
    )
    
    candidates = []
    for s in query.all():
        full_name = f"{s.first_name} {s.last_name}".lower()
        full_name_clean = re.sub(r'[^\w\s]', ' ', full_name)
        full_name_clean = re.sub(r'\s+', ' ', full_name_clean)
        
        if all(w.lower() in full_name_clean for w in words):
            candidates.append(s)

    if len(candidates) == 1:
        return candidates[0].id, None

    return None, suggested_query


# ─────────────────────────────────────────────────────────────────────────────
# UPLOAD & PARSING
# ─────────────────────────────────────────────────────────────────────────────

# Upload history is now persisted to the upload_batches DB table (see UploadBatch model).
# This ensures history survives server restarts.


@router.post("/upload")
async def upload_tally_file(
    file: UploadFile = File(...),
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """
    Parse a Tally CSV/Excel export and auto-match rows to students.
    Returns a summary of the import results.
    """
    upload_batch = datetime.datetime.utcnow().isoformat()

    try:
        rows = _parse_file(file)
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(status_code=400, detail=f"Failed to parse file: {str(exc)}")

    if not rows:
        raise HTTPException(status_code=422, detail="No valid data rows found in the uploaded file.")

    rows_processed = 0
    auto_matched = 0
    newly_auto_matched = 0
    skipped_duplicate = 0
    unmapped_count = 0

    for row in rows:
        rows_processed += 1
        ledger_name = row["ledger_name"]
        amount = row["amount"]
        payment_date = row["payment_date"] or datetime.date.today()
        voucher_no = row["voucher_no"]

        if voucher_no:
            existing = db.query(Payment).filter(
                Payment.voucher_no == voucher_no,
                Payment.ledger_name_raw == ledger_name
            ).first()
            if existing:
                skipped_duplicate += 1
                continue

        mapping = db.query(TallyLedgerMapping).filter(
            TallyLedgerMapping.ledger_name_raw == ledger_name
        ).first()

        if mapping:
            payment = Payment(
                student_id=mapping.student_id,
                amount=amount,
                payment_date=payment_date,
                mode=PaymentMode.TALLY_SYNC,
                voucher_no=voucher_no,
                ledger_name_raw=ledger_name,
                source=PaymentSource.TALLY_UPLOAD,
                uploaded_by=current_user.id,
            )
            db.add(payment)
            auto_matched += 1
        else:
            smart_id, _ = _smart_match_student(ledger_name, db)
            if smart_id:
                payment = Payment(
                    student_id=smart_id,
                    amount=amount,
                    payment_date=payment_date,
                    mode=PaymentMode.TALLY_SYNC,
                    voucher_no=voucher_no,
                    ledger_name_raw=ledger_name,
                    source=PaymentSource.TALLY_UPLOAD,
                    uploaded_by=current_user.id,
                )
                db.add(payment)
                
                new_mapping = TallyLedgerMapping(
                    ledger_name_raw=ledger_name,
                    student_id=smart_id,
                    confirmed_by=None
                )
                db.add(new_mapping)
                newly_auto_matched += 1
            else:
                if voucher_no:
                    dup_unmapped = db.query(UnmappedLedgerEntry).filter(
                        UnmappedLedgerEntry.voucher_no == voucher_no,
                        UnmappedLedgerEntry.ledger_name_raw == ledger_name
                    ).first()
                    if dup_unmapped:
                        skipped_duplicate += 1
                        continue

                entry = UnmappedLedgerEntry(
                    ledger_name_raw=ledger_name,
                    amount=amount,
                    payment_date=payment_date,
                    voucher_no=voucher_no,
                    status=UnmappedStatus.PENDING,
                    suggested_student_id=None,
                    upload_batch=upload_batch,
                )
                db.add(entry)
                unmapped_count += 1

    try:
        db.commit()
    except Exception as exc:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(exc)}")

    summary = {
        "rows_processed": rows_processed,
        "auto_matched": auto_matched,
        "newly_auto_matched_count": newly_auto_matched,
        "unmapped_count": unmapped_count,
        "skipped_duplicate": skipped_duplicate,
        "upload_batch": upload_batch,
        "filename": file.filename,
        "uploaded_at": upload_batch,
        "type": "daily_payment"
    }
    batch_record = UploadBatch(
        upload_batch=upload_batch,
        filename=file.filename,
        upload_type="daily_payment",
        rows_processed=rows_processed,
        auto_matched=auto_matched,
        newly_auto_matched_count=newly_auto_matched,
        unmapped_count=unmapped_count,
        skipped_duplicate=skipped_duplicate,
        uploaded_by=current_user.id,
    )
    db.add(batch_record)
    db.commit()
    return summary


@router.get("/uploads/history")
def get_upload_history(
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Return list of past uploads from the database (persists across restarts)."""
    batches = (
        db.query(UploadBatch)
        .order_by(UploadBatch.created_at.desc())
        .limit(50)
        .all()
    )
    return [
        {
            "rows_processed": b.rows_processed,
            "auto_matched": b.auto_matched,
            "newly_auto_matched_count": b.newly_auto_matched_count,
            "unmapped_count": b.unmapped_count,
            "skipped_duplicate": b.skipped_duplicate,
            "upload_batch": b.upload_batch,
            "filename": b.filename,
            "uploaded_at": b.created_at.isoformat() if b.created_at else b.upload_batch,
            "type": b.upload_type,
        }
        for b in batches
    ]


@router.post("/opening-balance-upload")
async def upload_opening_balance_file(
    file: UploadFile = File(...),
    academic_year: Optional[str] = None,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """
    Parse a Tally Group Summary export (Particulars, Closing Balance)
    and set the amount_due for each matched student.
    Does NOT require a FeeStructure — will create StudentFeeAssignment
    with fee_structure_id=None if no structure exists.
    Only falls through to Unmapped Queue if the STUDENT cannot be matched.
    """
    upload_batch = datetime.datetime.utcnow().isoformat()

    # Derive current academic year if not provided (e.g. "2024-2025")
    now = datetime.datetime.utcnow()
    if academic_year:
        current_ay = academic_year
    else:
        year = now.year
        # Academic year starts in July; if before July, it started last year
        if now.month >= 7:
            current_ay = f"{year}-{year + 1}"
        else:
            current_ay = f"{year - 1}-{year}"

    try:
        rows = _parse_file(file)
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(status_code=400, detail=f"Failed to parse file: {str(exc)}")

    if not rows:
        raise HTTPException(status_code=422, detail="No valid data rows found in the uploaded file.")

    rows_processed = 0
    auto_matched = 0
    newly_auto_matched = 0
    unmapped_count = 0
    skipped_duplicate = 0

    for row in rows:
        rows_processed += 1
        ledger_name = row["ledger_name"]
        amount = row["amount"]
        voucher_no = row.get("voucher_no")

        mapping = db.query(TallyLedgerMapping).filter(
            TallyLedgerMapping.ledger_name_raw == ledger_name
        ).first()

        target_student_id = None
        is_new_match = False

        if mapping:
            target_student_id = mapping.student_id
        else:
            smart_id, _ = _smart_match_student(ledger_name, db)
            if smart_id:
                target_student_id = smart_id
                is_new_match = True

        if target_student_id:
            student = db.query(Student).filter(Student.id == target_student_id).first()
            if student:
                # Optionally look up a FeeStructure for enrichment — NOT required
                fs = db.query(FeeStructure).filter(
                    FeeStructure.department_id == student.department_id,
                    FeeStructure.semester == student.current_semester
                ).order_by(FeeStructure.id.desc()).first()

                fs_id = fs.id if fs else None
                ay = fs.academic_year if fs else current_ay

                # Find or create assignment — never fails due to missing FeeStructure
                assignment = db.query(StudentFeeAssignment).filter(
                    StudentFeeAssignment.student_id == student.id,
                    StudentFeeAssignment.semester == student.current_semester,
                    StudentFeeAssignment.academic_year == ay
                ).first()

                # Calculate what the amount_due should be so that Pending Balance = amount from Tally
                other_assignments_sum = db.query(func.sum(StudentFeeAssignment.amount_due)).filter(
                    StudentFeeAssignment.student_id == student.id,
                    StudentFeeAssignment.id != (assignment.id if assignment else -1)
                ).scalar()
                other_assignments_sum = float(other_assignments_sum or 0)

                total_paid_row = db.query(func.sum(Payment.amount)).filter(Payment.student_id == student.id).scalar()
                total_paid = float(total_paid_row or 0)

                new_amount_due = float(amount) + total_paid - other_assignments_sum

                if assignment:
                    assignment.amount_due = Decimal(str(new_amount_due))
                    if assignment.fee_structure_id is None and fs_id:
                        assignment.fee_structure_id = fs_id  # backfill if now available
                else:
                    assignment = StudentFeeAssignment(
                        student_id=student.id,
                        fee_structure_id=fs_id,
                        amount_due=Decimal(str(new_amount_due)),
                        semester=student.current_semester,
                        academic_year=ay
                    )
                    db.add(assignment)

                if is_new_match:
                    new_mapping = TallyLedgerMapping(
                        ledger_name_raw=ledger_name,
                        student_id=target_student_id,
                        confirmed_by=None
                    )
                    db.add(new_mapping)
                    newly_auto_matched += 1
                else:
                    auto_matched += 1
                continue

        # Only reaches here if the student could not be matched
        entry = UnmappedLedgerEntry(
            ledger_name_raw=ledger_name,
            amount=amount,
            payment_date=None,
            voucher_no=voucher_no,
            status=UnmappedStatus.PENDING,
            entry_type="opening_balance",
            suggested_student_id=None,
            upload_batch=upload_batch,
        )
        db.add(entry)
        unmapped_count += 1

    try:
        db.commit()
    except Exception as exc:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(exc)}")

    summary = {
        "rows_processed": rows_processed,
        "auto_matched": auto_matched,
        "newly_auto_matched_count": newly_auto_matched,
        "unmapped_count": unmapped_count,
        "skipped_duplicate": skipped_duplicate,
        "upload_batch": upload_batch,
        "filename": file.filename,
        "uploaded_at": upload_batch,
        "type": "opening_balance"
    }
    batch_record = UploadBatch(
        upload_batch=upload_batch,
        filename=file.filename,
        upload_type="opening_balance",
        rows_processed=rows_processed,
        auto_matched=auto_matched,
        newly_auto_matched_count=newly_auto_matched,
        unmapped_count=unmapped_count,
        skipped_duplicate=skipped_duplicate,
        uploaded_by=current_user.id,
    )
    db.add(batch_record)
    db.commit()
    return summary


# ─────────────────────────────────────────────────────────────────────────────
# UNMAPPED QUEUE
# ─────────────────────────────────────────────────────────────────────────────

@router.get("/unmapped")
def list_unmapped(
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """List all pending (or recently skipped) UnmappedLedgerEntry rows."""
    entries = (
        db.query(UnmappedLedgerEntry)
        .filter(UnmappedLedgerEntry.status == UnmappedStatus.PENDING)
        .order_by(UnmappedLedgerEntry.created_at.desc())
        .all()
    )

    result = []
    for e in entries:
        suggested_name = None
        if e.suggested_student_id:
            s = db.query(Student).filter(Student.id == e.suggested_student_id).first()
            if s:
                suggested_name = f"{s.first_name} {s.last_name} ({s.register_number})"
        else:
            _, query_str = _smart_match_student(e.ledger_name_raw, db)
            if query_str:
                suggested_name = query_str
                
        result.append({
            "id": e.id,
            "ledger_name_raw": e.ledger_name_raw,
            "amount": float(e.amount),
            "payment_date": str(e.payment_date) if e.payment_date else None,
            "voucher_no": e.voucher_no,
            "status": e.status.value,
            "entry_type": e.entry_type,
            "suggested_student_id": e.suggested_student_id,
            "suggested_student_name": suggested_name,
            "created_at": e.created_at.isoformat() if e.created_at else None,
        })
    return result


@router.post("/unmapped/{entry_id}/resolve")
def resolve_unmapped(
    entry_id: int,
    body: ResolveUnmappedRequest,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """
    Link an unmapped entry to a student, create the Payment row,
    and upsert a TallyLedgerMapping so future imports auto-match.
    """
    entry = db.query(UnmappedLedgerEntry).filter(UnmappedLedgerEntry.id == entry_id).first()
    if not entry:
        raise HTTPException(status_code=404, detail="Unmapped entry not found")
    if entry.status != UnmappedStatus.PENDING:
        raise HTTPException(status_code=400, detail=f"Entry is already {entry.status.value}")

    student = db.query(Student).filter(Student.id == body.student_id).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    if entry.entry_type == "opening_balance":
        # Optionally enrich with FeeStructure — NOT required for opening balance
        fs = db.query(FeeStructure).filter(
            FeeStructure.department_id == student.department_id,
            FeeStructure.semester == student.current_semester
        ).order_by(FeeStructure.id.desc()).first()

        # Derive academic year: use FeeStructure's AY if available, else current
        now = datetime.datetime.utcnow()
        if fs:
            ay = fs.academic_year
        elif now.month >= 7:
            ay = f"{now.year}-{now.year + 1}"
        else:
            ay = f"{now.year - 1}-{now.year}"

        fs_id = fs.id if fs else None

        # Find or create assignment — no 400 error for missing FeeStructure
        assignment = db.query(StudentFeeAssignment).filter(
            StudentFeeAssignment.student_id == student.id,
            StudentFeeAssignment.semester == student.current_semester,
            StudentFeeAssignment.academic_year == ay
        ).first()

        other_assignments_sum = db.query(func.sum(StudentFeeAssignment.amount_due)).filter(
            StudentFeeAssignment.student_id == student.id,
            StudentFeeAssignment.id != (assignment.id if assignment else -1)
        ).scalar()
        other_assignments_sum = float(other_assignments_sum or 0)

        total_paid_row = db.query(func.sum(Payment.amount)).filter(Payment.student_id == student.id).scalar()
        total_paid = float(total_paid_row or 0)

        new_amount_due = float(entry.amount) + total_paid - other_assignments_sum

        if assignment:
            assignment.amount_due = Decimal(str(new_amount_due))
            if assignment.fee_structure_id is None and fs_id:
                assignment.fee_structure_id = fs_id  # backfill if now available
        else:
            assignment = StudentFeeAssignment(
                student_id=student.id,
                fee_structure_id=fs_id,
                amount_due=Decimal(str(new_amount_due)),
                semester=student.current_semester,
                academic_year=ay
            )
            db.add(assignment)

        payment = None  # No payment record for opening balance
    else:
        # Create Payment
        payment = Payment(
            student_id=body.student_id,
            amount=entry.amount,
            payment_date=entry.payment_date or datetime.date.today(),
            mode=PaymentMode.TALLY_SYNC,
            voucher_no=entry.voucher_no,
            ledger_name_raw=entry.ledger_name_raw,
            source=PaymentSource.TALLY_UPLOAD,
            uploaded_by=current_user.id,
        )
        db.add(payment)

    # Upsert TallyLedgerMapping
    mapping = db.query(TallyLedgerMapping).filter(
        TallyLedgerMapping.ledger_name_raw == entry.ledger_name_raw
    ).first()
    if mapping:
        mapping.student_id = body.student_id
        mapping.confirmed_by = current_user.id
        mapping.confirmed_at = func.now()
    else:
        mapping = TallyLedgerMapping(
            ledger_name_raw=entry.ledger_name_raw,
            student_id=body.student_id,
            confirmed_by=current_user.id,
        )
        db.add(mapping)

    # Mark resolved
    entry.status = UnmappedStatus.RESOLVED

    try:
        db.commit()
    except Exception as exc:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(exc))

    return {"message": "Entry resolved successfully", "payment_id": payment.id if payment else None}


@router.post("/unmapped/{entry_id}/skip")
def skip_unmapped(
    entry_id: int,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Mark an unmapped entry as skipped."""
    entry = db.query(UnmappedLedgerEntry).filter(UnmappedLedgerEntry.id == entry_id).first()
    if not entry:
        raise HTTPException(status_code=404, detail="Unmapped entry not found")
    if entry.status != UnmappedStatus.PENDING:
        raise HTTPException(status_code=400, detail=f"Entry is already {entry.status.value}")

    entry.status = UnmappedStatus.SKIPPED
    db.commit()
    return {"message": "Entry skipped"}


# ─────────────────────────────────────────────────────────────────────────────
# STUDENT SEARCH (admin use)
# ─────────────────────────────────────────────────────────────────────────────

@router.get("/students/search")
def search_students(
    q: str = Query(..., min_length=1),
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Search students by name or register number (for admin dropdowns)."""
    term = f"%{q}%"
    students = (
        db.query(Student)
        .filter(
            Student.is_active == True,
            or_(
                Student.first_name.ilike(term),
                Student.last_name.ilike(term),
                Student.register_number.ilike(term),
            )
        )
        .limit(20)
        .all()
    )
    return [
        {
            "id": s.id,
            "name": f"{s.first_name} {s.last_name}",
            "register_number": s.register_number,
            "department_id": s.department_id,
            "current_semester": s.current_semester,
        }
        for s in students
    ]


# ─────────────────────────────────────────────────────────────────────────────
# MANUAL PAYMENT
# ─────────────────────────────────────────────────────────────────────────────

@router.post("/payments/manual")
def create_manual_payment(
    body: ManualPaymentCreate,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Create a manual payment entry (cash/cheque/bank transfer etc.)."""
    student = db.query(Student).filter(Student.id == body.student_id).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    try:
        mode = PaymentMode(body.mode)
    except ValueError:
        valid_modes = [m.value for m in PaymentMode]
        raise HTTPException(
            status_code=422,
            detail=f"Invalid payment mode '{body.mode}'. Valid modes: {valid_modes}"
        )

    try:
        pdate = datetime.date.fromisoformat(body.payment_date)
    except ValueError:
        raise HTTPException(status_code=422, detail="Invalid payment_date. Use ISO format: YYYY-MM-DD")

    payment = Payment(
        student_id=body.student_id,
        amount=Decimal(str(body.amount)),
        payment_date=pdate,
        mode=mode,
        receipt_no=body.receipt_no,
        source=PaymentSource.MANUAL,
        uploaded_by=current_user.id,
        notes=body.notes,
    )
    db.add(payment)
    try:
        db.commit()
        db.refresh(payment)
    except Exception as exc:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(exc))

    return {
        "id": payment.id,
        "student_id": payment.student_id,
        "amount": float(payment.amount),
        "payment_date": str(payment.payment_date),
        "mode": payment.mode.value,
        "receipt_no": payment.receipt_no,
        "source": payment.source.value,
        "created_at": payment.created_at.isoformat() if payment.created_at else None,
    }


# ─────────────────────────────────────────────────────────────────────────────
# FEE STRUCTURE — CRUD
# ─────────────────────────────────────────────────────────────────────────────

@router.get("/structure")
def list_fee_structures(
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    """List all fee structures with department name."""
    structures = db.query(FeeStructure).order_by(
        FeeStructure.academic_year.desc(),
        FeeStructure.department_id,
        FeeStructure.semester
    ).all()

    result = []
    for fs in structures:
        dept = db.query(Department).filter(Department.id == fs.department_id).first()
        result.append({
            "id": fs.id,
            "department_id": fs.department_id,
            "department_name": dept.name if dept else None,
            "department_code": dept.code if dept else None,
            "semester": fs.semester,
            "amount": float(fs.amount),
            "academic_year": fs.academic_year,
            "created_at": fs.created_at.isoformat() if fs.created_at else None,
        })
    return result


@router.post("/structure")
def create_fee_structure(
    body: FeeStructureCreate,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Create a new fee structure entry."""
    dept = db.query(Department).filter(Department.id == body.department_id).first()
    if not dept:
        raise HTTPException(status_code=404, detail="Department not found")

    # Check duplicate
    existing = db.query(FeeStructure).filter(
        FeeStructure.department_id == body.department_id,
        FeeStructure.semester == body.semester,
        FeeStructure.academic_year == body.academic_year,
    ).first()
    if existing:
        raise HTTPException(
            status_code=409,
            detail=f"Fee structure for {dept.name} Sem-{body.semester} ({body.academic_year}) already exists."
        )

    fs = FeeStructure(
        department_id=body.department_id,
        semester=body.semester,
        amount=Decimal(str(body.amount)),
        academic_year=body.academic_year,
    )
    db.add(fs)
    try:
        db.commit()
        db.refresh(fs)
    except Exception as exc:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(exc))

    return {
        "id": fs.id,
        "department_id": fs.department_id,
        "department_name": dept.name,
        "semester": fs.semester,
        "amount": float(fs.amount),
        "academic_year": fs.academic_year,
    }


@router.put("/structure/{structure_id}")
def update_fee_structure(
    structure_id: int,
    body: FeeStructureUpdate,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Update an existing fee structure."""
    fs = db.query(FeeStructure).filter(FeeStructure.id == structure_id).first()
    if not fs:
        raise HTTPException(status_code=404, detail="Fee structure not found")

    if body.department_id is not None:
        fs.department_id = body.department_id
    if body.semester is not None:
        fs.semester = body.semester
    if body.amount is not None:
        fs.amount = Decimal(str(body.amount))
    if body.academic_year is not None:
        fs.academic_year = body.academic_year

    try:
        db.commit()
    except Exception as exc:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(exc))
    return {"message": "Fee structure updated", "id": fs.id}


@router.delete("/structure/{structure_id}")
def delete_fee_structure(
    structure_id: int,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Delete a fee structure."""
    fs = db.query(FeeStructure).filter(FeeStructure.id == structure_id).first()
    if not fs:
        raise HTTPException(status_code=404, detail="Fee structure not found")
    db.delete(fs)
    db.commit()
    return {"message": "Fee structure deleted"}


# ─────────────────────────────────────────────────────────────────────────────
# STUDENT FEE ASSIGNMENTS
# ─────────────────────────────────────────────────────────────────────────────

@router.get("/assignments")
def list_assignments(
    department_id: Optional[int] = None,
    academic_year: Optional[str] = None,
    semester: Optional[int] = None,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """List fee assignments with optional filters."""
    q = db.query(StudentFeeAssignment)
    if department_id:
        q = q.join(Student, StudentFeeAssignment.student_id == Student.id).filter(
            Student.department_id == department_id
        )
    if academic_year:
        q = q.filter(StudentFeeAssignment.academic_year == academic_year)
    if semester:
        q = q.filter(StudentFeeAssignment.semester == semester)

    assignments = q.order_by(StudentFeeAssignment.created_at.desc()).limit(200).all()

    result = []
    for a in assignments:
        s = db.query(Student).filter(Student.id == a.student_id).first()
        result.append({
            "id": a.id,
            "student_id": a.student_id,
            "student_name": f"{s.first_name} {s.last_name}" if s else "Unknown",
            "register_number": s.register_number if s else None,
            "fee_structure_id": a.fee_structure_id,
            "amount_due": float(a.amount_due),
            "semester": a.semester,
            "academic_year": a.academic_year,
            "created_at": a.created_at.isoformat() if a.created_at else None,
        })
    return result


@router.post("/assignments/generate")
def generate_assignments(
    body: AssignmentGenerateRequest,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """
    Generate StudentFeeAssignment rows for all active students in a department
    for the given semester+year, using the matching FeeStructure.
    Safe to re-run — skips students who already have an assignment for that sem+year.
    """
    # Find fee structure
    fs = db.query(FeeStructure).filter(
        FeeStructure.department_id == body.department_id,
        FeeStructure.semester == body.semester,
        FeeStructure.academic_year == body.academic_year,
    ).first()
    if not fs:
        raise HTTPException(
            status_code=404,
            detail="No fee structure found for the given department/semester/year."
        )

    # Get students in this department with matching semester
    students = db.query(Student).filter(
        Student.department_id == body.department_id,
        Student.current_semester == body.semester,
        Student.is_active == True,
        Student.is_alumni == False,
    ).all()

    if not students:
        raise HTTPException(
            status_code=404,
            detail="No active students found for the given department and semester."
        )

    created = 0
    skipped = 0

    for student in students:
        existing = db.query(StudentFeeAssignment).filter(
            StudentFeeAssignment.student_id == student.id,
            StudentFeeAssignment.semester == body.semester,
            StudentFeeAssignment.academic_year == body.academic_year,
        ).first()
        if existing:
            skipped += 1
            continue

        assignment = StudentFeeAssignment(
            student_id=student.id,
            fee_structure_id=fs.id,
            amount_due=fs.amount,
            semester=body.semester,
            academic_year=body.academic_year,
        )
        db.add(assignment)
        created += 1

    try:
        db.commit()
    except Exception as exc:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(exc))

    return {
        "message": f"Generated {created} assignments, skipped {skipped} existing.",
        "created": created,
        "skipped": skipped,
    }


# ─────────────────────────────────────────────────────────────────────────────
# STUDENT-FACING ENDPOINTS
# ─────────────────────────────────────────────────────────────────────────────

def _get_student_fee_data(student_id: int, db: Session) -> dict:
    """Shared helper: compute summary and history for a student."""
    student = db.query(Student).filter(Student.id == student_id).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    # Total due = sum of all assignments for this student
    total_due_row = db.query(func.sum(StudentFeeAssignment.amount_due)).filter(
        StudentFeeAssignment.student_id == student_id
    ).scalar()
    total_due = float(total_due_row or 0)

    # Total paid = sum of all payments
    total_paid_row = db.query(func.sum(Payment.amount)).filter(
        Payment.student_id == student_id
    ).scalar()
    total_paid = float(total_paid_row or 0)

    balance = max(total_due - total_paid, 0)

    # Payment history
    payments = (
        db.query(Payment)
        .filter(Payment.student_id == student_id)
        .order_by(Payment.payment_date.desc(), Payment.created_at.desc())
        .all()
    )

    history = [
        {
            "id": p.id,
            "amount": float(p.amount),
            "payment_date": str(p.payment_date),
            "mode": p.mode.value,
            "source": p.source.value,
            "receipt_no": p.receipt_no,
            "voucher_no": p.voucher_no,
            "notes": p.notes,
            "created_at": p.created_at.isoformat() if p.created_at else None,
        }
        for p in payments
    ]

    return {
        "student_id": student_id,
        "student_name": f"{student.first_name} {student.last_name}",
        "register_number": student.register_number,
        "total_due": total_due,
        "total_paid": total_paid,
        "pending_balance": balance,
        "history": history,
    }


@router.get("/student/{student_id}/summary")
def get_student_fee_summary(
    student_id: int,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    """Return fee summary (due, paid, balance) for a student."""
    # Access control
    role = current_user.role.value if hasattr(current_user.role, "value") else current_user.role
    if role == "student":
        me = db.query(Student).filter(Student.user_id == current_user.id).first()
        if not me or me.id != student_id:
            raise HTTPException(status_code=403, detail="Access denied")
    elif role not in ("admin", "accountant"):
        raise HTTPException(status_code=403, detail="Access denied")

    data = _get_student_fee_data(student_id, db)
    return {
        "student_id": data["student_id"],
        "student_name": data["student_name"],
        "register_number": data["register_number"],
        "total_due": data["total_due"],
        "total_paid": data["total_paid"],
        "pending_balance": data["pending_balance"],
    }


@router.get("/student/{student_id}/history")
def get_student_payment_history(
    student_id: int,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    """Return full payment history for a student."""
    role = current_user.role.value if hasattr(current_user.role, "value") else current_user.role
    if role == "student":
        me = db.query(Student).filter(Student.user_id == current_user.id).first()
        if not me or me.id != student_id:
            raise HTTPException(status_code=403, detail="Access denied")
    elif role not in ("admin", "accountant"):
        raise HTTPException(status_code=403, detail="Access denied")

    data = _get_student_fee_data(student_id, db)
    return data["history"]


# ─────────────────────────────────────────────────────────────────────────────
# LEDGER MAPPING MANAGEMENT
# ─────────────────────────────────────────────────────────────────────────────

@router.get("/mappings")
def list_mappings(
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """List all confirmed TallyLedgerMappings."""
    mappings = (
        db.query(TallyLedgerMapping)
        .order_by(TallyLedgerMapping.confirmed_at.desc())
        .all()
    )
    result = []
    for m in mappings:
        student = db.query(Student).filter(Student.id == m.student_id).first()
        result.append({
            "id": m.id,
            "ledger_name_raw": m.ledger_name_raw,
            "student_id": m.student_id,
            "student_name": f"{student.first_name} {student.last_name}" if student else None,
            "register_number": student.register_number if student else None,
            "confirmed_by": m.confirmed_by,
            "confirmed_at": m.confirmed_at.isoformat() if m.confirmed_at else None,
        })
    return result


@router.put("/mappings/{mapping_id}")
def update_mapping(
    mapping_id: int,
    body: LedgerMappingUpdate,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Update the student linked to a ledger mapping."""
    mapping = db.query(TallyLedgerMapping).filter(TallyLedgerMapping.id == mapping_id).first()
    if not mapping:
        raise HTTPException(status_code=404, detail="Mapping not found")

    student = db.query(Student).filter(Student.id == body.student_id).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    mapping.student_id = body.student_id
    mapping.confirmed_by = current_user.id
    db.commit()
    return {"message": "Mapping updated"}


@router.delete("/mappings/{mapping_id}")
def delete_mapping(
    mapping_id: int,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Delete a ledger mapping."""
    mapping = db.query(TallyLedgerMapping).filter(TallyLedgerMapping.id == mapping_id).first()
    if not mapping:
        raise HTTPException(status_code=404, detail="Mapping not found")
    db.delete(mapping)
    db.commit()
    return {"message": "Mapping deleted"}


# ─────────────────────────────────────────────────────────────────────────────
# REPORTS
# ─────────────────────────────────────────────────────────────────────────────

@router.get("/reports/defaulters")
def get_defaulters(
    department_id: Optional[int] = None,
    semester: Optional[int] = None,
    academic_year: Optional[str] = None,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """
    Return students whose total_paid < total_due (pending_balance > 0).
    Filterable by department, semester, academic_year.
    """
    # Get all students with fee assignments
    q = db.query(Student).filter(Student.is_active == True, Student.is_alumni == False)
    if department_id:
        q = q.filter(Student.department_id == department_id)
    students = q.all()

    defaulters = []
    for student in students:
        # Filter assignments
        assignment_q = db.query(StudentFeeAssignment).filter(
            StudentFeeAssignment.student_id == student.id
        )
        if semester:
            assignment_q = assignment_q.filter(StudentFeeAssignment.semester == semester)
        if academic_year:
            assignment_q = assignment_q.filter(StudentFeeAssignment.academic_year == academic_year)

        total_due_row = assignment_q.with_entities(
            func.sum(StudentFeeAssignment.amount_due)
        ).scalar()
        total_due = float(total_due_row or 0)

        if total_due <= 0:
            continue

        total_paid_row = db.query(func.sum(Payment.amount)).filter(
            Payment.student_id == student.id
        ).scalar()
        total_paid = float(total_paid_row or 0)

        balance = total_due - total_paid
        if balance <= 0:
            continue

        dept = db.query(Department).filter(Department.id == student.department_id).first()
        defaulters.append({
            "student_id": student.id,
            "student_name": f"{student.first_name} {student.last_name}",
            "register_number": student.register_number,
            "department_name": dept.name if dept else None,
            "current_semester": student.current_semester,
            "total_due": total_due,
            "total_paid": total_paid,
            "pending_balance": balance,
        })

    # Sort by balance descending
    defaulters.sort(key=lambda x: x["pending_balance"], reverse=True)
    return defaulters


@router.get("/reports/collection-summary")
def get_collection_summary(
    academic_year: Optional[str] = None,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """
    Return total collected, grouped by department and month.
    Used for the Recharts bar chart in the accountant portal.
    """
    import calendar

    # Monthly totals
    payments = db.query(Payment).all()
    monthly: dict = {}

    for p in payments:
        if not p.payment_date:
            continue
        key = f"{p.payment_date.year}-{p.payment_date.month:02d}"
        monthly[key] = monthly.get(key, 0) + float(p.amount)

    monthly_list = [
        {
            "month": k,
            "month_label": datetime.date(int(k[:4]), int(k[5:]), 1).strftime("%b %Y"),
            "total_collected": round(v, 2),
        }
        for k, v in sorted(monthly.items())
    ]

    # By department (for academic_year filter if provided)
    dept_q = db.query(Payment).join(Student, Payment.student_id == Student.id)
    if academic_year:
        # Filter by year in payment_date
        year_int = int(academic_year.split("-")[0])
        dept_q = dept_q.filter(
            func.extract("year", Payment.payment_date).in_([year_int, year_int + 1])
        )

    dept_totals: dict = {}
    for p in dept_q.all():
        student = db.query(Student).filter(Student.id == p.student_id).first()
        if not student:
            continue
        dept = db.query(Department).filter(Department.id == student.department_id).first()
        dept_name = dept.code if dept else "Unknown"
        dept_totals[dept_name] = dept_totals.get(dept_name, 0) + float(p.amount)

    dept_list = [
        {"department": k, "total_collected": round(v, 2)}
        for k, v in sorted(dept_totals.items(), key=lambda x: x[1], reverse=True)
    ]

    return {
        "monthly": monthly_list,
        "by_department": dept_list,
        "grand_total": round(sum(monthly.values()), 2),
    }
