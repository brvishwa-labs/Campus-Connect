import datetime
from sqlalchemy.orm import Session
from app.models.department import Department
from app.models.faculty import Faculty
from app.models.leave import FacultyLeaveRequest, LeaveStatus
from app.models.user import UserRole

def get_managed_department(faculty_id: int, db: Session) -> Department:
    """
    Returns the department this user is currently managing as HOD.
    Checks if they are the actual HOD (and not on leave), OR if they are the acting HOD 
    (alternate staff for an HOD who is currently on an approved leave).
    """
    today = datetime.date.today()
    
    # 1. Are they the actual HOD?
    dept = db.query(Department).filter(Department.hod_id == faculty_id).first()
    if dept:
        # Check if they are currently on leave.
        on_leave = db.query(FacultyLeaveRequest).filter(
            FacultyLeaveRequest.faculty_id == faculty_id,
            FacultyLeaveRequest.status == LeaveStatus.APPROVED,
            FacultyLeaveRequest.from_date <= today,
            FacultyLeaveRequest.to_date >= today
        ).first()
        
        # If they are on leave AND they delegated to someone else, they are not active.
        if on_leave and on_leave.alternate_hod_faculty_id:
            return None
            
        return dept

    # 2. Are they an alternate HOD for someone on leave?
    active_leave = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.alternate_hod_faculty_id == faculty_id,
        FacultyLeaveRequest.status == LeaveStatus.APPROVED,
        FacultyLeaveRequest.from_date <= today,
        FacultyLeaveRequest.to_date >= today
    ).first()
    
    if active_leave:
        # Return the department of the actual HOD who is on leave
        return db.query(Department).filter(Department.hod_id == active_leave.faculty_id).first()
        
    return None

def is_acting_hod(user, db: Session) -> bool:
    """
    Checks if the given user currently has HOD privileges (either they are the HOD, or acting HOD).
    Returns True if they manage a department.
    """
    if user.role not in [UserRole.FACULTY, UserRole.HOD]:
        return False
        
    faculty = db.query(Faculty).filter(Faculty.user_id == user.id).first()
    if not faculty:
        return False
        
    dept = get_managed_department(faculty.id, db)
    return dept is not None
