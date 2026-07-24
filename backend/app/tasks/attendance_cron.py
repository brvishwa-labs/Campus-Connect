import logging
from datetime import date, datetime, timedelta
from sqlalchemy.orm import Session

from app.core.database import SessionLocal
from app.core.holidays import is_holiday
from app.models.faculty import Faculty
from app.models.attendance import FacultyAttendance, FacultyAttendanceStatus
from app.models.leave import FacultyLeaveRequest, LeaveStatus

logger = logging.getLogger(__name__)

# Attendance is only generated at / after 9:00 AM.
# On server startup, catchup is attempted only if current time is between
# 09:00 and 16:30 (inclusive) and today is not a holiday.
ATTENDANCE_START_HOUR = 9       # 09:00 AM
CATCHUP_CUTOFF_HOUR = 16        # 04:00 PM
CATCHUP_CUTOFF_MINUTE = 30      # :30  → cutoff = 16:30


def generate_daily_attendance(db: Session, target_date: date):
    """
    Generates faculty attendance for *target_date*.

    Rules:
    - Skip entirely if target_date is a Sunday or a configured holiday.
    - Skip faculty members who already have a record for target_date
      (idempotent — safe to call multiple times).
    - Mark faculty with an APPROVED leave request covering target_date
      as 'on_leave' and link the leave request.
    - Mark all other active faculty as 'present'.

    Pending / Rejected / Withdrawn leave requests have NO effect on
    attendance — those faculty are marked present.
    """
    # --- Holiday guard ---
    if is_holiday(target_date, db):
        logger.info(
            f"Skipping attendance generation for {target_date} "
            f"(Sunday or configured holiday)."
        )
        return

    logger.info(f"Running automated attendance generation for {target_date}…")

    # 1. Fetch all active faculty members
    all_faculty = db.query(Faculty).filter(Faculty.is_active == True).all()

    # 2. Fetch existing attendance records for target_date (idempotency check)
    existing_attendance = db.query(FacultyAttendance).filter(
        FacultyAttendance.date == target_date
    ).all()
    processed_faculty_ids = {record.faculty_id for record in existing_attendance}

    # 3. Fetch ONLY approved leave requests that cover target_date.
    #    Pending / Rejected / Withdrawn statuses are intentionally excluded.
    approved_leaves = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.status == LeaveStatus.APPROVED,
        FacultyLeaveRequest.from_date <= target_date,
        FacultyLeaveRequest.to_date >= target_date
    ).all()

    # Map: faculty_id → approved leave request (for O(1) lookup)
    leave_map = {leave.faculty_id: leave for leave in approved_leaves}

    records_added = 0
    for faculty in all_faculty:
        if faculty.id in processed_faculty_ids:
            continue  # Already has a record for this date — skip

        leave = leave_map.get(faculty.id)
        if leave:
            # Faculty has an approved leave → mark on_leave and link leave request
            status = FacultyAttendanceStatus.on_leave
            leave_id = leave.id
        else:
            # No approved leave → mark present
            status = FacultyAttendanceStatus.present
            leave_id = None

        new_record = FacultyAttendance(
            faculty_id=faculty.id,
            date=target_date,
            status=status,
            leave_request_id=leave_id
        )
        db.add(new_record)
        records_added += 1

    if records_added > 0:
        db.commit()
        logger.info(
            f"Generated attendance for {records_added} faculty member(s) on {target_date}."
        )
    else:
        logger.info(
            f"Attendance already fully generated for {target_date} "
            f"(0 new records needed)."
        )


def run_9am_cron():
    """
    Scheduled cron job triggered every working day at 9:00 AM via APScheduler.
    Generates attendance for today, skipping Sundays and configured holidays.
    """
    db = SessionLocal()
    try:
        today = date.today()
        generate_daily_attendance(db, today)
    except Exception as e:
        logger.error(f"Error running 9 AM attendance cron: {e}", exc_info=True)
    finally:
        db.close()


def startup_catchup(db: Session):
    """
    Runs immediately on server startup.

    Purpose: recover from a missed 9 AM cron due to server downtime.

    Rules:
    - Only processes TODAY's date (not historical dates).
    - Only runs if the current time is between 09:00 and 16:30.
    - Skips if today is a Sunday or a configured holiday.
    - Skips if attendance has already been generated for today
      (handled inside generate_daily_attendance via idempotency check).

    Design rationale: we do not backfill past days to avoid creating
    phantom "present" records for days when the server was genuinely
    offline for an extended period.
    """
    now = datetime.now()
    today = now.date()

    logger.info("Startup check: evaluating whether to generate today's attendance…")

    # Only act if current time is in the 09:00 – 16:30 window
    after_9am = now.hour >= ATTENDANCE_START_HOUR
    before_cutoff = (now.hour < CATCHUP_CUTOFF_HOUR) or (
        now.hour == CATCHUP_CUTOFF_HOUR and now.minute < CATCHUP_CUTOFF_MINUTE
    )

    if not after_9am:
        logger.info(
            "Startup catchup skipped: server started before 9:00 AM. "
            "The scheduled 9 AM cron will run at the correct time."
        )
        return

    if not before_cutoff:
        logger.info(
            f"Startup catchup skipped: current time ({now.strftime('%H:%M')}) "
            f"is past the 16:30 cutoff. Today's attendance will not be generated."
        )
        return

    # generate_daily_attendance already checks for holidays and duplicate records
    generate_daily_attendance(db, today)
