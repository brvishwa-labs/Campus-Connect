from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import Dict

from app.core.database import get_db
from app.core.security import get_current_active_user
from app.models.user import User, UserRole
from app.models.student import Student
from app.models.faculty import Faculty
from app.models.academic import MentorAssignment, Section
from app.models.gatepass import GatePass, GatePassStatus, FacultyGatePass, FacultyGatePassStatus
from app.models.leave import StudentLeaveRequest, StudentLeaveStatus, FacultyLeaveRequest, FacultyDutyArrangement, LeaveStatus, ArrangementStatus
from app.models.late import LateEntryNotification
from app.models.notification_view import NotificationView

router = APIRouter()

def apply_view_filter(query, model, sector_name, views_dict):
    last_view = views_dict.get(sector_name)
    if last_view:
        return query.filter(func.coalesce(model.updated_at, model.created_at) > last_view)
    return query

@router.get("/badge-counts", response_model=Dict[str, int])
def get_badge_counts(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    counts = {
        "/faculty/leave": 0,
        "/faculty/mentorship": 0,
        "/faculty/class-advisor/leave": 0,
        "/faculty/gatepass": 0,
        "/faculty/faculty-gatepass": 0,
        "/faculty/late-entry": 0,
        
        "/hod/leave": 0,
        "/hod/leave/student": 0,
        "/hod/leave/faculty": 0,
        "/hod/gatepass": 0,
        "/hod/faculty-gatepass": 0,
        
        "/authority/leave": 0,
        "/authority/gatepass": 0,
        "/authority/faculty-gatepass": 0,
        
        "/student/leave": 0,
        "/student/gatepass": 0,
        
        "/dean/messaging": 0,
        "/student/messaging": 0,
    }
    
    views_dict = {v.sector: v.last_viewed_at for v in db.query(NotificationView).filter_by(user_id=current_user.id).all()}
    
    if current_user.role in [UserRole.FACULTY, UserRole.HOD]:
        faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
        if faculty:
            # 1. Faculty leave (duty arrangements) - Actionable
            counts["/faculty/leave"] = db.query(FacultyDutyArrangement).filter(
                FacultyDutyArrangement.substitute_faculty_id == faculty.id,
                FacultyDutyArrangement.status == ArrangementStatus.PENDING
            ).count()

            # 2. Mentor leave - Actionable
            mentees_sub = db.query(MentorAssignment.student_id).filter(MentorAssignment.mentor_id == faculty.id).subquery()
            counts["/faculty/mentorship"] = db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id.in_(mentees_sub),
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_MENTOR
            ).count()

            # 3. Class Advisor leave - Actionable
            advised_sections = db.query(Section.id).filter(Section.class_advisor_id == faculty.id, Section.is_active == True).subquery()
            ca_students = db.query(Student.id).filter(Student.section_id.in_(advised_sections)).subquery()
            counts["/faculty/class-advisor/leave"] = db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id.in_(ca_students),
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_CLASS_ADVISOR
            ).count()

            # 4. Mentor gatepass - Actionable
            counts["/faculty/gatepass"] = db.query(GatePass).filter(
                GatePass.student_id.in_(mentees_sub),
                GatePass.status == GatePassStatus.PENDING_MENTOR,
                GatePass.is_deleted_by_student == False
            ).count()

            # 5. Mentor late entry - Informational
            q_late = db.query(LateEntryNotification).filter(LateEntryNotification.mentor_id == faculty.id)
            counts["/faculty/late-entry"] = apply_view_filter(q_late, LateEntryNotification, "late-entry", views_dict).count()

            # 6. Faculty own gatepass requests - Informational
            q_fac_gp = db.query(FacultyGatePass).filter(
                FacultyGatePass.faculty_id == faculty.id,
                FacultyGatePass.is_deleted_by_faculty == False,
                FacultyGatePass.status.in_([FacultyGatePassStatus.APPROVED, FacultyGatePassStatus.REJECTED])
            )
            counts["/faculty/faculty-gatepass"] = apply_view_filter(q_fac_gp, FacultyGatePass, "faculty-gatepass-own", views_dict).count()

    if current_user.role == UserRole.HOD:
        faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
        if faculty:
            dept_students = db.query(Student.id).filter(Student.department_id == faculty.department_id).subquery()
            dept_faculty = db.query(Faculty.id).filter(Faculty.department_id == faculty.department_id).subquery()

            # HOD leave (student) - Actionable
            stu_count = db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id.in_(dept_students),
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_HOD
            ).count()

            # HOD leave (faculty) - Actionable
            fac_count = db.query(FacultyLeaveRequest).filter(
                FacultyLeaveRequest.faculty_id.in_(dept_faculty),
                FacultyLeaveRequest.status == LeaveStatus.PENDING_HOD
            ).count()

            counts["/hod/leave"] = stu_count + fac_count
            counts["/hod/leave/student"] = stu_count
            counts["/hod/leave/faculty"] = fac_count

            # HOD gatepass - Actionable
            counts["/hod/gatepass"] = db.query(GatePass).filter(
                GatePass.student_id.in_(dept_students),
                GatePass.status == GatePassStatus.PENDING_HOD,
                GatePass.is_deleted_by_student == False
            ).count()

            # HOD faculty gatepass - Actionable
            counts["/hod/faculty-gatepass"] = db.query(FacultyGatePass).filter(
                FacultyGatePass.faculty_id.in_(dept_faculty),
                FacultyGatePass.status == FacultyGatePassStatus.PENDING_HOD,
                FacultyGatePass.is_deleted_by_faculty == False
            ).count()

    if current_user.role == UserRole.AUTHORITY:
        from app.models.authority import Authority as AuthorityModel
        auth = db.query(AuthorityModel).filter(AuthorityModel.user_id == current_user.id).first()
        if auth:
            title = auth.title.lower().strip()
            
            # Authority leave - Actionable
            if "dean" in title:
                counts["/authority/leave"] = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.status == LeaveStatus.PENDING_DEAN).count()
            elif "manager" in title or "principal" in title:
                counts["/authority/leave"] = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.status == LeaveStatus.PENDING_OM).count()

            # Authority gatepass (OM) - Actionable
            if "manager" in title or "principal" in title:
                counts["/authority/gatepass"] = db.query(GatePass).filter(
                    GatePass.status == GatePassStatus.PENDING_OM,
                    GatePass.is_deleted_by_student == False
                ).count()

            # Authority faculty gatepass - Actionable
            if "dean" in title:
                counts["/authority/faculty-gatepass"] = db.query(FacultyGatePass).filter(
                    FacultyGatePass.status == FacultyGatePassStatus.PENDING_DEAN,
                    FacultyGatePass.is_deleted_by_faculty == False
                ).count()
            elif "manager" in title or "principal" in title:
                counts["/authority/faculty-gatepass"] = db.query(FacultyGatePass).filter(
                    FacultyGatePass.status == FacultyGatePassStatus.PENDING_OM,
                    FacultyGatePass.is_deleted_by_faculty == False
                ).count()

            # Dean messaging - Actionable (unread messages)
            if "dean" in title:
                from app.models.messaging import Conversation
                counts["/dean/messaging"] = db.query(Conversation).filter(
                    Conversation.dean_id == auth.id,
                    Conversation.dean_unread_count > 0
                ).count()

    if current_user.role == UserRole.STUDENT:
        student = db.query(Student).filter(Student.user_id == current_user.id).first()
        if student:
            # Student leave decisions - Informational
            q_stu_leave = db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id == student.id,
                StudentLeaveRequest.status.in_([StudentLeaveStatus.APPROVED, StudentLeaveStatus.REJECTED])
            )
            counts["/student/leave"] = apply_view_filter(q_stu_leave, StudentLeaveRequest, "student-leave", views_dict).count()

            # Student gatepass decisions - Informational
            q_stu_gp = db.query(GatePass).filter(
                GatePass.student_id == student.id,
                GatePass.is_deleted_by_student == False,
                GatePass.status.in_([GatePassStatus.APPROVED, GatePassStatus.REJECTED])
            )
            counts["/student/gatepass"] = apply_view_filter(q_stu_gp, GatePass, "student-gatepass", views_dict).count()

            # Messaging
            from app.models.messaging import Conversation
            counts["/student/messaging"] = db.query(Conversation).filter(
                Conversation.student_id == student.id,
                Conversation.student_unread_count > 0
            ).count()

    return counts

@router.put("/mark-viewed")
def mark_sector_viewed(
    sector: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Mark informational items as viewed by updating NotificationView.
    """
    from datetime import datetime
    nv = db.query(NotificationView).filter_by(user_id=current_user.id, sector=sector).first()
    if nv:
        nv.last_viewed_at = datetime.utcnow()
    else:
        nv = NotificationView(user_id=current_user.id, sector=sector, last_viewed_at=datetime.utcnow())
        db.add(nv)
    db.commit()
    return {"message": "marked viewed"}
