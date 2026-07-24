import asyncio
import logging
from datetime import datetime, date as date_type
from sqlalchemy.orm import Session
from app.core.database import SessionLocal
from app.core.holidays import is_holiday
from app.models.faculty import Faculty
from app.models.leave import FacultyLeaveRequest, LeaveStatus
from app.models.attendance import FacultyAttendance, FacultyAttendanceStatus

logger = logging.getLogger(__name__)


def process_daily_faculty_attendance(db: Session, target_date: date_type = None):
    """
    Generate daily attendance records for all active faculty members.

    Rules:
    - Skips Sundays and admin-configured holidays (uses is_holiday utility).
    - Marks faculty with an APPROVED leave request covering target_date as
      'on_leave' and links the leave_request_id for leave-type lookup.
    - Marks all other active faculty as 'present'.
    - Pending / Rejected / Cancelled / Withdrawn leave statuses have NO effect;
      those faculty are always marked present.
    - Idempotent: faculty who already have a record for target_date are skipped
      to prevent duplicate entries.
    """
    if target_date is None:
        target_date = date_type.today()

    # --- Holiday guard ---
    if is_holiday(target_date, db):
        logger.info(
            f"Skipping attendance processing for {target_date} "
            f"(Sunday or configured holiday)."
        )
        return

    logger.info(f"Processing faculty attendance for date: {target_date}")

    # Get all active faculty
    all_faculty = db.query(Faculty).filter(Faculty.is_active == True).all()

    # Get all approved leaves covering target_date.
    # ONLY LeaveStatus.APPROVED is considered — any other status means present.
    approved_leaves = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.status == LeaveStatus.APPROVED,
        FacultyLeaveRequest.from_date <= target_date,
        FacultyLeaveRequest.to_date >= target_date
    ).all()

    # Build a fast lookup: faculty_id → leave request object
    leave_map = {leave.faculty_id: leave for leave in approved_leaves}

    records_processed = 0
    for faculty in all_faculty:
        # Idempotency check — skip if already has a record for today
        existing = db.query(FacultyAttendance).filter(
            FacultyAttendance.faculty_id == faculty.id,
            FacultyAttendance.date == target_date
        ).first()

        if existing:
            continue

        leave = leave_map.get(faculty.id)

        new_attendance = FacultyAttendance(
            faculty_id=faculty.id,
            date=target_date,
            status=FacultyAttendanceStatus.on_leave if leave else FacultyAttendanceStatus.present,
            leave_request_id=leave.id if leave else None
        )
        db.add(new_attendance)
        records_processed += 1

    db.commit()
    logger.info(
        f"Attendance processing complete: {records_processed} new record(s) "
        f"created for {target_date}."
    )


async def faculty_attendance_job():
    """
    Background asyncio task that runs indefinitely.
    Fires process_daily_faculty_attendance at 09:00 AM every day.
    Holidays are handled inside process_daily_faculty_attendance.
    """
    logger.info("Faculty Attendance Job started. Waiting for 09:00 AM daily…")
    while True:
        now = datetime.now()

        # Trigger at exactly 9:00 AM (hour=9, minute=0)
        if now.hour == 9 and now.minute == 0:
            logger.info("Triggering daily faculty attendance task (09:00 AM)")
            db = SessionLocal()
            try:
                process_daily_faculty_attendance(db, now.date())
            except Exception as e:
                logger.error(f"Error processing faculty attendance: {e}", exc_info=True)
            finally:
                db.close()

            # Sleep 61 seconds so the next check does not re-trigger in the same minute
            await asyncio.sleep(61)
        else:
            # Poll every 30 seconds
            await asyncio.sleep(30)
