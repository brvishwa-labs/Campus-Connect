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
from app.models.late import LateEntryNotification, LateRecord
from app.models.notification_view import NotificationView
from app.models.discipline import DisciplineRecord
from app.models.lms import Announcement

router = APIRouter()

def apply_view_filter(query, model, sector_name, views_dict):
    last_view = views_dict.get(sector_name)
    if last_view:
        if hasattr(model, 'updated_at'):
            return query.filter(func.coalesce(model.updated_at, model.created_at) > last_view)
        else:
            return query.filter(model.created_at > last_view)
    return query

@router.get("/badge-counts", response_model=Dict[str, int])
def get_badge_counts(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    counts = {
        # Faculty
        "/faculty/leave": 0,
        "/faculty/mentorship": 0,
        "/faculty/class-advisor/leave": 0,
        "/faculty/gatepass": 0,
        "/faculty/faculty-gatepass": 0,
        "/faculty/late-entry": 0,
        "/faculty/announcements": 0,

        # HOD
        "/hod/leave": 0,
        "/hod/leave/student": 0,
        "/hod/leave/faculty": 0,
        "/hod/gatepass": 0,
        "/hod/faculty-gatepass": 0,
        "/hod/discipline": 0,
        "/hod/latetracker": 0,
        "/hod/announcements": 0,

        # Authority / Dean / OM / Principal
        "/authority/leave": 0,
        "/authority/gatepass": 0,
        "/authority/faculty-gatepass": 0,
        "/authority/announcements": 0,

        # Student
        "/student/leave": 0,
        "/student/gatepass": 0,
        "/student/late-entry": 0,
        "/student/announcements": 0,

        # Messaging
        "/dean/messaging": 0,
        "/student/messaging": 0,

        # Admin
        "/admin/discipline": 0,
        "/admin/latetracker": 0,
        "/admin/announcements": 0,
    }
    
    views_dict = {v.sector: v.last_viewed_at for v in db.query(NotificationView).filter_by(user_id=current_user.id).all()}
    
    if current_user.role in [UserRole.FACULTY, UserRole.HOD]:
        faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
        if faculty:
            # 1. Faculty Leave page — own leave updates + new substitute requests (clears on visit)
            q_own_leave = db.query(FacultyLeaveRequest).filter(
                FacultyLeaveRequest.faculty_id == faculty.id,
                FacultyLeaveRequest.status != LeaveStatus.PENDING_SUBSTITUTE
            )
            q_sub = db.query(FacultyDutyArrangement).filter(
                FacultyDutyArrangement.substitute_faculty_id == faculty.id,
                FacultyDutyArrangement.status == ArrangementStatus.PENDING
            )
            counts["/faculty/leave"] = (
                apply_view_filter(q_own_leave, FacultyLeaveRequest, "faculty-leave", views_dict).count() +
                apply_view_filter(q_sub, FacultyDutyArrangement, "faculty-leave", views_dict).count()
            )

            # 2. Mentorship — pending mentor-approval leave requests (clears on visit)
            mentees_sub = db.query(MentorAssignment.student_id).filter(MentorAssignment.mentor_id == faculty.id).subquery()
            q_mentor_leave = db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id.in_(mentees_sub),
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_MENTOR
            )
            counts["/faculty/mentorship"] = apply_view_filter(q_mentor_leave, StudentLeaveRequest, "faculty-mentorship", views_dict).count()

            # 3. Class Advisor leave (clears on visit)
            advised_sections = db.query(Section.id).filter(Section.class_advisor_id == faculty.id, Section.is_active == True).subquery()
            ca_students = db.query(Student.id).filter(Student.section_id.in_(advised_sections)).subquery()
            q_ca_leave = db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id.in_(ca_students),
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_CLASS_ADVISOR
            )
            counts["/faculty/class-advisor/leave"] = apply_view_filter(q_ca_leave, StudentLeaveRequest, "faculty-ca-leave", views_dict).count()

            # 4. Mentor gate pass approvals (clears on visit)
            q_mentor_gp = db.query(GatePass).filter(
                GatePass.student_id.in_(mentees_sub),
                GatePass.status == GatePassStatus.PENDING_MENTOR,
                GatePass.is_deleted_by_student == False
            )
            counts["/faculty/gatepass"] = apply_view_filter(q_mentor_gp, GatePass, "faculty-gatepass", views_dict).count()

            # 5. Late entry notifications (clears on visit)
            q_late = db.query(LateEntryNotification).filter(LateEntryNotification.mentor_id == faculty.id)
            counts["/faculty/late-entry"] = apply_view_filter(q_late, LateEntryNotification, "late-entry", views_dict).count()

            # 6. Faculty own gate pass decisions (clears on visit)
            q_fac_gp = db.query(FacultyGatePass).filter(
                FacultyGatePass.faculty_id == faculty.id,
                FacultyGatePass.is_deleted_by_faculty == False,
                FacultyGatePass.status.in_([FacultyGatePassStatus.APPROVED, FacultyGatePassStatus.REJECTED])
            )
            counts["/faculty/faculty-gatepass"] = apply_view_filter(q_fac_gp, FacultyGatePass, "faculty-gatepass-own", views_dict).count()

            # 7. Announcements (clears on visit)
            q_fac_ann = db.query(Announcement).filter(Announcement.is_global == True)
            counts["/faculty/announcements"] = apply_view_filter(q_fac_ann, Announcement, "faculty-announcements", views_dict).count()

    if current_user.role == UserRole.HOD:
        faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
        if faculty:
            dept_students = db.query(Student.id).filter(Student.department_id == faculty.department_id).subquery()
            dept_faculty = db.query(Faculty.id).filter(Faculty.department_id == faculty.department_id).subquery()

            # HOD leave — student (clears on visit)
            q_hod_stu = db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id.in_(dept_students),
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_HOD
            )
            stu_count = apply_view_filter(q_hod_stu, StudentLeaveRequest, "hod-leave", views_dict).count()

            # HOD leave — faculty (clears on visit)
            q_hod_fac = db.query(FacultyLeaveRequest).filter(
                FacultyLeaveRequest.faculty_id.in_(dept_faculty),
                FacultyLeaveRequest.status == LeaveStatus.PENDING_HOD
            )
            fac_count = apply_view_filter(q_hod_fac, FacultyLeaveRequest, "hod-leave", views_dict).count()

            counts["/hod/leave"] = stu_count + fac_count
            counts["/hod/leave/student"] = stu_count
            counts["/hod/leave/faculty"] = fac_count

            # HOD gate pass (clears on visit)
            q_hod_gp = db.query(GatePass).filter(
                GatePass.student_id.in_(dept_students),
                GatePass.status == GatePassStatus.PENDING_HOD,
                GatePass.is_deleted_by_student == False
            )
            counts["/hod/gatepass"] = apply_view_filter(q_hod_gp, GatePass, "hod-gatepass", views_dict).count()

            # HOD faculty gate pass (clears on visit)
            q_hod_fac_gp = db.query(FacultyGatePass).filter(
                FacultyGatePass.faculty_id.in_(dept_faculty),
                FacultyGatePass.status == FacultyGatePassStatus.PENDING_HOD,
                FacultyGatePass.is_deleted_by_faculty == False
            )
            counts["/hod/faculty-gatepass"] = apply_view_filter(q_hod_fac_gp, FacultyGatePass, "hod-faculty-gatepass", views_dict).count()

            # HOD discipline (clears on visit)
            q_hod_disc = db.query(DisciplineRecord).filter(DisciplineRecord.student_id.in_(dept_students))
            counts["/hod/discipline"] = apply_view_filter(q_hod_disc, DisciplineRecord, "hod-discipline", views_dict).count()

            # HOD late tracker (clears on visit)
            q_hod_late = db.query(LateRecord).filter(LateRecord.student_id.in_(dept_students))
            counts["/hod/latetracker"] = apply_view_filter(q_hod_late, LateRecord, "hod-latetracker", views_dict).count()

            # HOD announcements (clears on visit)
            q_hod_ann = db.query(Announcement).filter(Announcement.is_global == True)
            counts["/hod/announcements"] = apply_view_filter(q_hod_ann, Announcement, "hod-announcements", views_dict).count()

    if current_user.role == UserRole.AUTHORITY:
        from app.models.authority import Authority as AuthorityModel
        auth = db.query(AuthorityModel).filter(AuthorityModel.user_id == current_user.id).first()
        if auth:
            title = auth.title.lower().strip()

            # Authority leave (clears on visit)
            if "dean" in title:
                q_auth_leave = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.status == LeaveStatus.PENDING_DEAN)
                counts["/authority/leave"] = apply_view_filter(q_auth_leave, FacultyLeaveRequest, "authority-leave", views_dict).count()
            elif "manager" in title or "principal" in title:
                q_auth_leave = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.status == LeaveStatus.PENDING_OM)
                counts["/authority/leave"] = apply_view_filter(q_auth_leave, FacultyLeaveRequest, "authority-leave", views_dict).count()

            # Authority gate pass — OM/Principal (clears on visit)
            if "manager" in title or "principal" in title:
                q_auth_gp = db.query(GatePass).filter(
                    GatePass.status == GatePassStatus.PENDING_OM,
                    GatePass.is_deleted_by_student == False
                )
                counts["/authority/gatepass"] = apply_view_filter(q_auth_gp, GatePass, "authority-gatepass", views_dict).count()

            # Authority faculty gate pass (clears on visit)
            if "dean" in title:
                q_auth_fgp = db.query(FacultyGatePass).filter(
                    FacultyGatePass.status == FacultyGatePassStatus.PENDING_DEAN,
                    FacultyGatePass.is_deleted_by_faculty == False
                )
                counts["/authority/faculty-gatepass"] = apply_view_filter(q_auth_fgp, FacultyGatePass, "authority-faculty-gatepass", views_dict).count()
            elif "manager" in title or "principal" in title:
                q_auth_fgp = db.query(FacultyGatePass).filter(
                    FacultyGatePass.status == FacultyGatePassStatus.PENDING_OM,
                    FacultyGatePass.is_deleted_by_faculty == False
                )
                counts["/authority/faculty-gatepass"] = apply_view_filter(q_auth_fgp, FacultyGatePass, "authority-faculty-gatepass", views_dict).count()

            # Dean messaging — keeps real unread count (messaging manages its own state)
            if "dean" in title:
                from app.models.messaging import Conversation
                counts["/dean/messaging"] = db.query(Conversation).filter(
                    Conversation.dean_id == auth.id,
                    Conversation.dean_unread_count > 0
                ).count()

            # Authority announcements (clears on visit)
            q_auth_ann = db.query(Announcement).filter(Announcement.is_global == True)
            counts["/authority/announcements"] = apply_view_filter(q_auth_ann, Announcement, "authority-announcements", views_dict).count()

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

            # Student late entry - Informational (mentor commented on student's notification since last viewed)
            q_stu_late = db.query(LateEntryNotification).filter(
                LateEntryNotification.student_id == student.id,
                LateEntryNotification.mentor_comment != None
            )
            counts["/student/late-entry"] = apply_view_filter(q_stu_late, LateEntryNotification, "student-late-entry", views_dict).count()

            # Student announcements - Informational (new global announcements)
            q_stu_ann = db.query(Announcement).filter(Announcement.is_global == True)
            counts["/student/announcements"] = apply_view_filter(q_stu_ann, Announcement, "student-announcements", views_dict).count()

            # Messaging
            from app.models.messaging import Conversation
            counts["/student/messaging"] = db.query(Conversation).filter(
                Conversation.student_id == student.id,
                Conversation.student_unread_count > 0
            ).count()

    if current_user.role == UserRole.ADMIN:
        # Admin discipline - Informational (new discipline records since last viewed)
        q_admin_disc = db.query(DisciplineRecord)
        counts["/admin/discipline"] = apply_view_filter(q_admin_disc, DisciplineRecord, "admin-discipline", views_dict).count()

        # Admin late tracker - Informational (new late records since last viewed)
        q_admin_late = db.query(LateRecord)
        counts["/admin/latetracker"] = apply_view_filter(q_admin_late, LateRecord, "admin-latetracker", views_dict).count()

        # Admin announcements - Informational (new announcements since last viewed)
        q_admin_ann = db.query(Announcement)
        counts["/admin/announcements"] = apply_view_filter(q_admin_ann, Announcement, "admin-announcements", views_dict).count()

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
