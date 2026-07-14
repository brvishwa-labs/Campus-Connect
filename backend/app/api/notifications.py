from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func, and_
from typing import Dict
from datetime import datetime

from app.core.database import get_db
from app.core.security import get_current_active_user
from app.models.user import User, UserRole
from app.models.user_activity import UserPageView
from app.models.student import Student
from app.models.faculty import Faculty
from app.models.authority import Authority
from app.models.academic import MentorAssignment, Section
from app.models.gatepass import GatePass, GatePassStatus
from app.models.leave import StudentLeaveRequest, StudentLeaveStatus
from app.models.late import LateEntryNotification

router = APIRouter()


def get_last_viewed_time(db: Session, user_id: int, page_path: str) -> datetime:
    """Get the last time user viewed a specific page"""
    view_record = db.query(UserPageView).filter(
        UserPageView.user_id == user_id,
        UserPageView.page_path == page_path
    ).first()
    
    if view_record:
        return view_record.last_viewed_at
    return datetime.min  # If never viewed, return epoch time


def update_last_viewed_time(db: Session, user_id: int, page_path: str):
    """Update the last viewed time for a page"""
    view_record = db.query(UserPageView).filter(
        UserPageView.user_id == user_id,
        UserPageView.page_path == page_path
    ).first()
    
    if view_record:
        view_record.last_viewed_at = datetime.utcnow()
    else:
        new_view = UserPageView(user_id=user_id, page_path=page_path)
        db.add(new_view)
    
    db.commit()


@router.get("/badge-counts", response_model=Dict[str, int])
def get_badge_counts(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    counts = {
        # Faculty portal badges
        "/faculty/gatepass": 0,
        "/faculty/late-entry": 0,
        "/faculty/mentorship": 0,
        "/faculty/class-advisor/leave": 0,
        "/faculty/leave": 0,
        
        # HOD portal badges
        "/hod/leave": 0,
        "/hod/gatepass": 0,
        "/hod/faculty-gatepass": 0,
        "/hod/discipline": 0,
        "/hod/latetracker": 0,
        
        # Authority portal badges
        "/authority/leave": 0,
        "/authority/gatepass": 0,
        "/authority/faculty-gatepass": 0,
        "/authority/discipline": 0,
        "/authority/latetracker": 0,
        
        # Messaging badges
        "/dean/messaging": 0,
        "/student/messaging": 0,
        
        # Student portal badges
        "/student/marks": 0,
        "/student/announcements": 0,
        "/student/late-entry": 0,
    }
    
    # Faculty or HOD (who also has faculty role/duties)
    if current_user.role in [UserRole.FACULTY, UserRole.HOD]:
        faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
        if faculty:
            # 1. Mentor count of pending gate passes NOT VIEWED
            mentor_gp_count = db.query(GatePass).join(
                MentorAssignment, GatePass.student_id == MentorAssignment.student_id
            ).filter(
                MentorAssignment.mentor_id == faculty.id,
                GatePass.status == GatePassStatus.PENDING_MENTOR,
                GatePass.viewed_by_mentor == False,
                GatePass.is_deleted_by_student == False
            ).count()
            counts["/faculty/gatepass"] = mentor_gp_count

            # 2. Mentor count of pending late arrival notices NOT VIEWED
            mentor_late_count = db.query(LateEntryNotification).filter(
                LateEntryNotification.mentor_id == faculty.id,
                LateEntryNotification.viewed_by_mentor == False
            ).count()
            counts["/faculty/late-entry"] = mentor_late_count

            # 3. Mentor count of pending leave requests NOT VIEWED
            mentor_leave_count = db.query(StudentLeaveRequest).join(
                MentorAssignment, StudentLeaveRequest.student_id == MentorAssignment.student_id
            ).filter(
                MentorAssignment.mentor_id == faculty.id,
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_MENTOR,
                StudentLeaveRequest.viewed_by_mentor == False
            ).count()
            counts["/faculty/mentorship"] = mentor_leave_count

            # 4. Class Advisor count of pending leave requests NOT VIEWED
            ca_leave_count = db.query(StudentLeaveRequest).join(
                Student, StudentLeaveRequest.student_id == Student.id
            ).join(
                Section, Student.section_id == Section.id
            ).filter(
                Section.class_advisor_id == faculty.id,
                Section.is_active == True,
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_CLASS_ADVISOR,
                StudentLeaveRequest.viewed_by_ca == False
            ).count()
            counts["/faculty/class-advisor/leave"] = ca_leave_count
            
            # 5. Faculty Leave Requests - Substitute Approval Requests (NEW since last view)
            from app.models.leave import FacultyDutyArrangement, ArrangementStatus
            last_viewed = get_last_viewed_time(db, current_user.id, "/faculty/leave")
            substitute_requests_count = db.query(FacultyDutyArrangement).filter(
                FacultyDutyArrangement.substitute_faculty_id == faculty.id,
                FacultyDutyArrangement.status == ArrangementStatus.PENDING,
                FacultyDutyArrangement.created_at > last_viewed
            ).count()
            counts["/faculty/leave"] = substitute_requests_count

    if current_user.role == UserRole.HOD:
        faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
        if faculty:
            # HOD count of pending gate passes in department NOT VIEWED
            hod_gp_count = db.query(GatePass).join(Student).filter(
                Student.department_id == faculty.department_id,
                GatePass.status == GatePassStatus.PENDING_HOD,
                GatePass.viewed_by_hod == False,
                GatePass.is_deleted_by_student == False
            ).count()
            counts["/hod/gatepass"] = hod_gp_count

            # HOD count of pending leave requests in department NOT VIEWED
            hod_leave_count = db.query(StudentLeaveRequest).join(
                Student, StudentLeaveRequest.student_id == Student.id
            ).filter(
                Student.department_id == faculty.department_id,
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_HOD,
                StudentLeaveRequest.viewed_by_hod == False
            ).count()
            counts["/hod/leave"] = hod_leave_count
            
            # HOD count of pending faculty gate passes in department NOT VIEWED
            from app.models.gatepass import FacultyGatePass, FacultyGatePassStatus
            hod_faculty_gp_count = db.query(FacultyGatePass).join(Faculty).filter(
                Faculty.department_id == faculty.department_id,
                FacultyGatePass.status == FacultyGatePassStatus.PENDING_HOD,
                FacultyGatePass.viewed_by_hod == False
            ).count()
            counts["/hod/faculty-gatepass"] = hod_faculty_gp_count
            
            # HOD count of discipline incidents in department (NEW since last view)
            from app.models.discipline import DisciplineIncident
            last_viewed_discipline = get_last_viewed_time(db, current_user.id, "/hod/discipline")
            hod_discipline_count = db.query(DisciplineIncident).join(Student).filter(
                Student.department_id == faculty.department_id,
                DisciplineIncident.status == "PENDING",
                DisciplineIncident.created_at > last_viewed_discipline
            ).count()
            counts["/hod/discipline"] = hod_discipline_count
            
            # HOD count of late entries in department (NEW since last view)
            last_viewed_late = get_last_viewed_time(db, current_user.id, "/hod/latetracker")
            hod_late_count = db.query(LateEntryNotification).join(
                Student, LateEntryNotification.student_id == Student.id
            ).filter(
                Student.department_id == faculty.department_id,
                LateEntryNotification.created_at > last_viewed_late
            ).count()
            counts["/hod/latetracker"] = hod_late_count

    if current_user.role == UserRole.AUTHORITY:
        # OM / Authority count of pending gate passes NOT VIEWED
        om_gp_count = db.query(GatePass).filter(
            GatePass.status == GatePassStatus.PENDING_OM,
            GatePass.viewed_by_om == False,
            GatePass.is_deleted_by_student == False
        ).count()
        counts["/authority/gatepass"] = om_gp_count

        # Dean count of pending unread messages
        from app.models.authority import Authority as AuthorityModel
        dean_profile = db.query(AuthorityModel).filter(
            AuthorityModel.user_id == current_user.id,
            func.lower(AuthorityModel.title) == "dean"
        ).first()
        if dean_profile:
            from app.models.messaging import Conversation
            counts["/dean/messaging"] = db.query(Conversation).filter(
                Conversation.dean_id == dean_profile.id,
                Conversation.dean_unread_count > 0
            ).count()
        
        # Authority count of pending faculty leave requests (NEW since last view)
        from app.models.leave import FacultyLeaveRequest, LeaveStatus
        last_viewed_leave = get_last_viewed_time(db, current_user.id, "/authority/leave")
        authority_leave_count = db.query(FacultyLeaveRequest).filter(
            FacultyLeaveRequest.status == LeaveStatus.PENDING_DEAN,
            FacultyLeaveRequest.created_at > last_viewed_leave
        ).count()
        counts["/authority/leave"] = authority_leave_count
        
        # Authority count of pending faculty gate passes NOT VIEWED
        from app.models.gatepass import FacultyGatePass, FacultyGatePassStatus
        authority_faculty_gp_count = db.query(FacultyGatePass).filter(
            FacultyGatePass.status == FacultyGatePassStatus.PENDING_DEAN,
            FacultyGatePass.viewed_by_dean == False
        ).count()
        counts["/authority/faculty-gatepass"] = authority_faculty_gp_count
        
        # Authority count of discipline incidents (NEW since last view)
        from app.models.discipline import DisciplineIncident
        last_viewed_discipline = get_last_viewed_time(db, current_user.id, "/authority/discipline")
        authority_discipline_count = db.query(DisciplineIncident).filter(
            DisciplineIncident.status == "ESCALATED",
            DisciplineIncident.created_at > last_viewed_discipline
        ).count()
        counts["/authority/discipline"] = authority_discipline_count
        
        # Authority count of late entries (NEW since last view)
        last_viewed_late = get_last_viewed_time(db, current_user.id, "/authority/latetracker")
        authority_late_count = db.query(LateEntryNotification).filter(
            LateEntryNotification.created_at > last_viewed_late
        ).count()
        counts["/authority/latetracker"] = authority_late_count

    if current_user.role == UserRole.STUDENT:
        student = db.query(Student).filter(Student.user_id == current_user.id).first()
        if student:
            from app.models.messaging import Conversation
            counts["/student/messaging"] = db.query(Conversation).filter(
                Conversation.student_id == student.id,
                Conversation.student_unread_count > 0
            ).count()
            
            # Student count of new grade entries (NEW since last view)
            from app.models.grade import Grade
            last_viewed_marks = get_last_viewed_time(db, current_user.id, "/student/marks")
            student_marks_count = db.query(Grade).filter(
                Grade.student_id == student.id,
                Grade.is_published == True,
                Grade.created_at > last_viewed_marks
            ).count()
            counts["/student/marks"] = student_marks_count
            
            # Student count of late entry notifications (NEW since last view)
            last_viewed_late = get_last_viewed_time(db, current_user.id, "/student/late-entry")
            student_late_count = db.query(LateEntryNotification).filter(
                LateEntryNotification.student_id == student.id,
                LateEntryNotification.created_at > last_viewed_late
            ).count()
            counts["/student/late-entry"] = student_late_count
            
            # Student count of new announcements (NEW since last view)
            from app.models.lms import Announcement
            last_viewed_announcements = get_last_viewed_time(db, current_user.id, "/student/announcements")
            new_announcements_count = db.query(Announcement).filter(
                Announcement.created_at > last_viewed_announcements
            ).count()
            counts["/student/announcements"] = new_announcements_count

    return counts

@router.put("/mark-page-viewed")
def mark_page_as_viewed(
    page_path: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Mark a page as viewed by the current user.
    This will reset the notification badge for that page.
    """
    update_last_viewed_time(db, current_user.id, page_path)
    return {"message": "Page marked as viewed", "page_path": page_path}


@router.put("/mark-viewed")
def mark_sector_viewed(
    sector: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Mark all pending items in a specific sector as viewed by the current user.
    """
    if current_user.role in [UserRole.FACULTY, UserRole.HOD]:
        faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
        if not faculty:
            raise HTTPException(status_code=404, detail="Faculty profile not found")
        
        # Mentees subquery
        mentees_sub = db.query(MentorAssignment.student_id).filter(
            MentorAssignment.mentor_id == faculty.id
        ).subquery()

        if sector == "gatepass":
            # For mentor
            db.query(GatePass).filter(
                GatePass.student_id.in_(mentees_sub),
                GatePass.status == GatePassStatus.PENDING_MENTOR,
                GatePass.viewed_by_mentor == False
            ).update({GatePass.viewed_by_mentor: True}, synchronize_session=False)
            
            # For HOD (if user is HOD, they will also have /hod/gatepass marked viewed)
            if current_user.role == UserRole.HOD:
                db.query(GatePass).join(Student).filter(
                    Student.department_id == faculty.department_id,
                    GatePass.status == GatePassStatus.PENDING_HOD,
                    GatePass.viewed_by_hod == False
                ).update({GatePass.viewed_by_hod: True}, synchronize_session=False)

        elif sector == "late-entry":
            db.query(LateEntryNotification).filter(
                LateEntryNotification.mentor_id == faculty.id,
                LateEntryNotification.viewed_by_mentor == False
            ).update({LateEntryNotification.viewed_by_mentor: True}, synchronize_session=False)

        elif sector == "leave-mentor":
            db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id.in_(mentees_sub),
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_MENTOR,
                StudentLeaveRequest.viewed_by_mentor == False
            ).update({StudentLeaveRequest.viewed_by_mentor: True}, synchronize_session=False)

        elif sector == "leave-ca":
            advised_sections = db.query(Section.id).filter(
                Section.class_advisor_id == faculty.id,
                Section.is_active == True
            ).subquery()
            
            ca_students = db.query(Student.id).filter(
                Student.section_id.in_(advised_sections)
            ).subquery()

            db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id.in_(ca_students),
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_CLASS_ADVISOR,
                StudentLeaveRequest.viewed_by_ca == False
            ).update({StudentLeaveRequest.viewed_by_ca: True}, synchronize_session=False)

        elif sector == "leave-hod" and current_user.role == UserRole.HOD:
            dept_students = db.query(Student.id).filter(
                Student.department_id == faculty.department_id
            ).subquery()

            db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id.in_(dept_students),
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_HOD,
                StudentLeaveRequest.viewed_by_hod == False
            ).update({StudentLeaveRequest.viewed_by_hod: True}, synchronize_session=False)
            
    if current_user.role == UserRole.AUTHORITY:
        if sector == "gatepass":
            db.query(GatePass).filter(
                GatePass.status == GatePassStatus.PENDING_OM,
                GatePass.viewed_by_om == False
            ).update({GatePass.viewed_by_om: True}, synchronize_session=False)
            
    db.commit()
    return {"message": "Success"}


@router.get("/student/new-grades-by-subject")
def get_new_grades_by_subject(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Get list of subjects that have new grades published since last view.
    This is for showing detailed notifications to students.
    """
    if current_user.role != UserRole.STUDENT:
        raise HTTPException(status_code=403, detail="Only students can access this")
    
    student = db.query(Student).filter(Student.user_id == current_user.id).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student profile not found")
    
    from app.models.grade import Grade
    from app.models.academic import Course
    
    # Get last viewed time for marks page
    last_viewed = get_last_viewed_time(db, current_user.id, "/student/marks")
    
    # Get new grades grouped by course
    new_grades = db.query(
        Grade.course_id,
        Course.course_code,
        Course.course_name,
        func.count(Grade.id).label('count')
    ).join(
        Course, Grade.course_id == Course.id
    ).filter(
        Grade.student_id == student.id,
        Grade.is_published == True,
        Grade.created_at > last_viewed
    ).group_by(
        Grade.course_id,
        Course.course_code,
        Course.course_name
    ).all()
    
    return [
        {
            "course_id": grade.course_id,
            "course_code": grade.course_code,
            "course_name": grade.course_name,
            "new_grades_count": grade.count
        }
        for grade in new_grades
    ]
