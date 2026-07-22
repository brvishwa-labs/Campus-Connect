import logging
from datetime import date, datetime, timedelta
from sqlalchemy.orm import Session
from sqlalchemy import or_, and_

from app.core.database import SessionLocal
from app.models.faculty import Faculty
from app.models.attendance import FacultyAttendance, FacultyAttendanceStatus
from app.models.leave import FacultyLeaveRequest, LeaveStatus

logger = logging.getLogger(__name__)

def generate_daily_attendance(db: Session, target_date: date):
    """
    Iterates through all active faculty members and marks them as 'present' by default,
    UNLESS they have an approved leave request for the target_date, in which case they
    are marked as 'on_leave'.
    """
    logger.info(f"Running automated attendance check for {target_date}...")
    
    # 1. Fetch all active faculty members
    all_faculty = db.query(Faculty).filter(Faculty.is_active == True).all()
    
    # 2. Fetch existing attendance records for the target_date to avoid duplicates
    existing_attendance = db.query(FacultyAttendance).filter(
        FacultyAttendance.date == target_date
    ).all()
    
    # Create a set of faculty_ids that already have attendance for this date
    processed_faculty_ids = {record.faculty_id for record in existing_attendance}
    
    # 3. Fetch all approved leave requests that cover this target_date
    approved_leaves = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.status == LeaveStatus.APPROVED,
        FacultyLeaveRequest.from_date <= target_date,
        FacultyLeaveRequest.to_date >= target_date
    ).all()
    
    # Map faculty_id to their leave request
    leave_map = {leave.faculty_id: leave for leave in approved_leaves}
    
    records_added = 0
    # 4. Generate records for any faculty not yet processed
    for faculty in all_faculty:
        if faculty.id not in processed_faculty_ids:
            # Check if they have an approved leave today
            leave = leave_map.get(faculty.id)
            
            if leave:
                status = FacultyAttendanceStatus.on_leave
                leave_id = leave.id
            else:
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
        logger.info(f"Successfully generated attendance for {records_added} faculty members on {target_date}.")
    else:
        logger.info(f"Attendance already fully generated for {target_date}.")


def run_9am_cron():
    """
    Cron job triggered every day at 9:00 AM.
    """
    db = SessionLocal()
    try:
        today = date.today()
        generate_daily_attendance(db, today)
    except Exception as e:
        logger.error(f"Error running 9 AM attendance cron: {e}")
    finally:
        db.close()


def startup_catchup(db: Session):
    """
    Run immediately on server startup.
    Backfills missing attendance for up to the last 7 days to ensure no gaps if the server was offline.
    For the current day, it only runs if it's past 9 AM.
    """
    now = datetime.now()
    today = now.date()
    
    logger.info("Startup check: Verifying attendance records for the past 7 days...")
    
    # Check the last 7 days up to today
    for i in range(7, -1, -1):
        target_date = today - timedelta(days=i)
        
        # If the target date is today, wait until 9 AM
        if target_date == today and now.hour < 9:
            continue
            
        generate_daily_attendance(db, target_date)
