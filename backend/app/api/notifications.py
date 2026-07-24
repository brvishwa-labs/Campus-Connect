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

from typing import List, Any
from sqlalchemy import desc
from datetime import datetime

@router.get("/center")
def get_notification_center(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    notifications = []
    
    views_dict = {v.sector: v.last_viewed_at for v in db.query(NotificationView).filter_by(user_id=current_user.id).all()}
    def is_read(sector, date_val):
        last_view = views_dict.get(sector)
        if not last_view:
            return False
        if not date_val:
            return True
        return date_val <= last_view

    def add_notif(id_str, title, requester, dt, status_val, link, sector, notif_type):
        if not dt:
            dt = datetime.utcnow()
        notifications.append({
            "id": id_str,
            "title": title,
            "requester": requester,
            "date": dt.isoformat(),
            "status": str(status_val),
            "link": link,
            "is_read": is_read(sector, dt),
            "type": notif_type
        })

    if current_user.role in [UserRole.FACULTY, UserRole.HOD]:
        faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
        if faculty:
            # 1. Faculty own leave updates
            own_leaves = db.query(FacultyLeaveRequest).filter(
                FacultyLeaveRequest.faculty_id == faculty.id,
                FacultyLeaveRequest.status != LeaveStatus.PENDING_SUBSTITUTE
            ).order_by(desc(func.coalesce(FacultyLeaveRequest.updated_at, FacultyLeaveRequest.created_at))).limit(10).all()
            for l in own_leaves:
                add_notif(
                    f"fac_leave_{l.id}",
                    "Your Leave Request",
                    "You",
                    l.updated_at or l.created_at,
                    l.status.value,
                    "/faculty/leave",
                    "/faculty/leave",
                    "leave"
                )
                
            # Substitute requests & HOD duty assignments
            sub_reqs = db.query(FacultyDutyArrangement).filter(
                FacultyDutyArrangement.substitute_faculty_id == faculty.id,
                FacultyDutyArrangement.status == ArrangementStatus.PENDING
            ).order_by(desc(FacultyDutyArrangement.created_at)).limit(10).all()
            for s in sub_reqs:
                req_name = s.leave_request.faculty.first_name + " " + s.leave_request.faculty.last_name if hasattr(s, 'leave_request') and s.leave_request and s.leave_request.faculty else "Faculty Member"
                is_hod_duty = s.subject == "HOD Duties"
                notif_title = "HOD Duty Request Assigned" if is_hod_duty else "Peer Substitution Request"
                target_link = "/faculty/hod-duty" if is_hod_duty else "/faculty/leave/substitutes"
                add_notif(
                    f"fac_sub_{s.id}",
                    notif_title,
                    req_name,
                    s.created_at,
                    s.status.value,
                    target_link,
                    target_link,
                    "duty"
                )

            # Alternate HOD leave requests
            alt_hod_reqs = db.query(FacultyLeaveRequest).filter(
                FacultyLeaveRequest.alternate_hod_faculty_id == faculty.id,
                FacultyLeaveRequest.status == LeaveStatus.PENDING_ALTERNATE_HOD
            ).order_by(desc(FacultyLeaveRequest.created_at)).limit(10).all()
            for a_req in alt_hod_reqs:
                req_name = a_req.faculty.first_name + " " + a_req.faculty.last_name if a_req.faculty else "HOD"
                add_notif(
                    f"alt_hod_req_{a_req.id}",
                    "HOD Duty Request Assigned",
                    req_name,
                    a_req.created_at,
                    "PENDING",
                    "/faculty/hod-duty",
                    "/faculty/hod-duty",
                    "duty"
                )

            # Substitute response notifications (Accepted / Declined) for requesting faculty
            sub_responses = db.query(FacultyDutyArrangement).join(FacultyLeaveRequest).filter(
                FacultyLeaveRequest.faculty_id == faculty.id,
                FacultyDutyArrangement.status.in_([ArrangementStatus.ACCEPTED, ArrangementStatus.REJECTED])
            ).order_by(desc(func.coalesce(FacultyDutyArrangement.updated_at, FacultyDutyArrangement.created_at))).limit(10).all()
            for sr in sub_responses:
                sub_name = f"{sr.substitute_faculty.first_name} {sr.substitute_faculty.last_name}" if sr.substitute_faculty else "Substitute Faculty"
                is_hod_duty = sr.subject == "HOD Duties"
                status_label = "Accepted" if sr.status == ArrangementStatus.ACCEPTED else "Declined"
                title_text = f"HOD Duty Request {status_label}" if is_hod_duty else f"Substitution Request {status_label}"
                add_notif(
                    f"sub_resp_{sr.id}",
                    title_text,
                    sub_name,
                    sr.updated_at or sr.created_at,
                    sr.status.value,
                    "/faculty/leave",
                    "/faculty/leave",
                    "duty"
                )
                
            # Mentor leaves
            mentees_sub = db.query(MentorAssignment.student_id).filter(MentorAssignment.mentor_id == faculty.id)
            mentor_leaves = db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id.in_(mentees_sub),
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_MENTOR
            ).order_by(desc(func.coalesce(StudentLeaveRequest.updated_at, StudentLeaveRequest.created_at))).limit(10).all()
            for ml in mentor_leaves:
                add_notif(
                    f"stu_leave_{ml.id}",
                    "Student Leave Request",
                    ml.student.name if ml.student else "Student",
                    ml.updated_at or ml.created_at,
                    ml.status.value,
                    "/faculty/mentorship",
                    "/faculty/mentorship",
                    "student_leave"
                )

            # CA Leaves
            advised_sections = db.query(Section.id).filter(Section.class_advisor_id == faculty.id, Section.is_active == True)
            ca_students = db.query(Student.id).filter(Student.section_id.in_(advised_sections))
            ca_leaves = db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id.in_(ca_students),
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_CLASS_ADVISOR
            ).order_by(desc(func.coalesce(StudentLeaveRequest.updated_at, StudentLeaveRequest.created_at))).limit(10).all()
            for cl in ca_leaves:
                add_notif(
                    f"ca_leave_{cl.id}",
                    "Student Leave (CA)",
                    cl.student.name if cl.student else "Student",
                    cl.updated_at or cl.created_at,
                    cl.status.value,
                    "/faculty/class-advisor/leave",
                    "/faculty/class-advisor/leave",
                    "student_leave"
                )

            # Mentor Gatepass
            mentor_gps = db.query(GatePass).filter(
                GatePass.student_id.in_(mentees_sub),
                GatePass.status == GatePassStatus.PENDING_MENTOR,
                GatePass.is_deleted_by_student == False
            ).order_by(desc(func.coalesce(GatePass.updated_at, GatePass.created_at))).limit(10).all()
            for gp in mentor_gps:
                add_notif(
                    f"stu_gp_{gp.id}",
                    "Student Gate Pass",
                    gp.student.name if gp.student else "Student",
                    gp.updated_at or gp.created_at,
                    gp.status.value,
                    "/faculty/gatepass",
                    "/faculty/gatepass",
                    "gatepass"
                )
                
            # Faculty Gatepass decisions
            fac_gps = db.query(FacultyGatePass).filter(
                FacultyGatePass.faculty_id == faculty.id,
                FacultyGatePass.is_deleted_by_faculty == False,
                FacultyGatePass.status.in_([FacultyGatePassStatus.APPROVED, FacultyGatePassStatus.REJECTED])
            ).order_by(desc(func.coalesce(FacultyGatePass.updated_at, FacultyGatePass.created_at))).limit(10).all()
            for fg in fac_gps:
                add_notif(
                    f"fac_gp_{fg.id}",
                    "Your Gate Pass",
                    "You",
                    fg.updated_at or fg.created_at,
                    fg.status.value,
                    "/faculty/faculty-gatepass",
                    "/faculty/faculty-gatepass",
                    "faculty_gatepass"
                )

            # Announcements
            fac_anns = db.query(Announcement).filter(Announcement.is_global == True).order_by(desc(Announcement.created_at)).limit(5).all()
            for a in fac_anns:
                add_notif(
                    f"ann_{a.id}",
                    "Announcement: " + a.title,
                    "Admin",
                    a.created_at,
                    "Published",
                    "/faculty/announcements",
                    "/faculty/announcements",
                    "announcement"
                )

    from app.api.hod_helper import is_acting_hod, get_managed_department
    if is_acting_hod(current_user, db):
        faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
        dept = get_managed_department(faculty.id, db)
        if faculty and dept:
            dept_students = db.query(Student.id).filter(Student.department_id == dept.id)
            dept_faculty = db.query(Faculty.id).filter(Faculty.department_id == dept.id)

            # HOD student leaves
            hod_stu_leaves = db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id.in_(dept_students),
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_HOD
            ).order_by(desc(func.coalesce(StudentLeaveRequest.updated_at, StudentLeaveRequest.created_at))).limit(10).all()
            for hl in hod_stu_leaves:
                add_notif(
                    f"hod_stu_leave_{hl.id}",
                    "Student Leave (HOD)",
                    hl.student.name if hl.student else "Student",
                    hl.updated_at or hl.created_at,
                    hl.status.value,
                    "/hod/leave",
                    "/hod/leave",
                    "student_leave"
                )

            # HOD faculty leaves
            hod_fac_leaves = db.query(FacultyLeaveRequest).filter(
                FacultyLeaveRequest.faculty_id.in_(dept_faculty),
                FacultyLeaveRequest.status == LeaveStatus.PENDING_HOD
            ).order_by(desc(func.coalesce(FacultyLeaveRequest.updated_at, FacultyLeaveRequest.created_at))).limit(10).all()
            for hfl in hod_fac_leaves:
                req_name = hfl.faculty.first_name + " " + hfl.faculty.last_name if hfl.faculty else "Faculty"
                add_notif(
                    f"hod_fac_leave_{hfl.id}",
                    "Faculty Leave (HOD)",
                    req_name,
                    hfl.updated_at or hfl.created_at,
                    hfl.status.value,
                    "/hod/leave",
                    "/hod/leave",
                    "faculty_leave"
                )

            # HOD gatepass
            hod_gps = db.query(GatePass).filter(
                GatePass.student_id.in_(dept_students),
                GatePass.status == GatePassStatus.PENDING_HOD,
                GatePass.is_deleted_by_student == False
            ).order_by(desc(func.coalesce(GatePass.updated_at, GatePass.created_at))).limit(10).all()
            for hg in hod_gps:
                add_notif(
                    f"hod_stu_gp_{hg.id}",
                    "Student Gate Pass",
                    hg.student.name if hg.student else "Student",
                    hg.updated_at or hg.created_at,
                    hg.status.value,
                    "/hod/gatepass",
                    "/hod/gatepass",
                    "gatepass"
                )

            # HOD faculty gatepass
            hod_fgps = db.query(FacultyGatePass).filter(
                FacultyGatePass.faculty_id.in_(dept_faculty),
                FacultyGatePass.status == FacultyGatePassStatus.PENDING_HOD,
                FacultyGatePass.is_deleted_by_faculty == False
            ).order_by(desc(func.coalesce(FacultyGatePass.updated_at, FacultyGatePass.created_at))).limit(10).all()
            for hfg in hod_fgps:
                req_name = hfg.faculty.first_name + " " + hfg.faculty.last_name if hfg.faculty else "Faculty"
                add_notif(
                    f"hod_fac_gp_{hfg.id}",
                    "Faculty Gate Pass",
                    req_name,
                    hfg.updated_at or hfg.created_at,
                    hfg.status.value,
                    "/hod/faculty-gatepass",
                    "/hod/faculty-gatepass",
                    "faculty_gatepass"
                )
                
            # HOD Announcements
            hod_anns = db.query(Announcement).filter(Announcement.is_global == True).order_by(desc(Announcement.created_at)).limit(5).all()
            for a in hod_anns:
                add_notif(
                    f"hod_ann_{a.id}",
                    "Announcement: " + a.title,
                    "Admin",
                    a.created_at,
                    "Published",
                    "/hod/announcements",
                    "/hod/announcements",
                    "announcement"
                )

    if current_user.role == UserRole.AUTHORITY:
        from app.models.authority import Authority as AuthorityModel
        auth = db.query(AuthorityModel).filter(AuthorityModel.user_id == current_user.id).first()
        if auth:
            title = auth.title.lower().strip()

            if "dean" in title:
                auth_leaves = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.status == LeaveStatus.PENDING_DEAN).order_by(desc(func.coalesce(FacultyLeaveRequest.updated_at, FacultyLeaveRequest.created_at))).limit(10).all()
                for al in auth_leaves:
                    req_name = al.faculty.first_name + " " + al.faculty.last_name if al.faculty else "Faculty"
                    add_notif(
                        f"auth_leave_{al.id}",
                        "Faculty Leave (Dean)",
                        req_name,
                        al.updated_at or al.created_at,
                        al.status.value,
                        "/authority/leave",
                        "/authority/leave",
                        "faculty_leave"
                    )
                    
                auth_fgps = db.query(FacultyGatePass).filter(
                    FacultyGatePass.status == FacultyGatePassStatus.PENDING_DEAN,
                    FacultyGatePass.is_deleted_by_faculty == False
                ).order_by(desc(func.coalesce(FacultyGatePass.updated_at, FacultyGatePass.created_at))).limit(10).all()
                for afg in auth_fgps:
                    req_name = afg.faculty.first_name + " " + afg.faculty.last_name if afg.faculty else "Faculty"
                    add_notif(
                        f"auth_fgp_{afg.id}",
                        "Faculty Gate Pass",
                        req_name,
                        afg.updated_at or afg.created_at,
                        afg.status.value,
                        "/authority/faculty-gatepass",
                        "/authority/faculty-gatepass",
                        "faculty_gatepass"
                    )
                    
            elif "manager" in title or "principal" in title:
                auth_leaves = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.status == LeaveStatus.PENDING_OM).order_by(desc(func.coalesce(FacultyLeaveRequest.updated_at, FacultyLeaveRequest.created_at))).limit(10).all()
                for al in auth_leaves:
                    req_name = al.faculty.first_name + " " + al.faculty.last_name if al.faculty else "Faculty"
                    add_notif(
                        f"auth_leave_{al.id}",
                        "Faculty Leave",
                        req_name,
                        al.updated_at or al.created_at,
                        al.status.value,
                        "/authority/leave",
                        "/authority/leave",
                        "faculty_leave"
                    )
                    
                auth_gps = db.query(GatePass).filter(
                    GatePass.status == GatePassStatus.PENDING_OM,
                    GatePass.is_deleted_by_student == False
                ).order_by(desc(func.coalesce(GatePass.updated_at, GatePass.created_at))).limit(10).all()
                for ag in auth_gps:
                    add_notif(
                        f"auth_gp_{ag.id}",
                        "Student Gate Pass",
                        ag.student.name if ag.student else "Student",
                        ag.updated_at or ag.created_at,
                        ag.status.value,
                        "/authority/gatepass",
                        "/authority/gatepass",
                        "gatepass"
                    )
                    
                auth_fgps = db.query(FacultyGatePass).filter(
                    FacultyGatePass.status == FacultyGatePassStatus.PENDING_OM,
                    FacultyGatePass.is_deleted_by_faculty == False
                ).order_by(desc(func.coalesce(FacultyGatePass.updated_at, FacultyGatePass.created_at))).limit(10).all()
                for afg in auth_fgps:
                    req_name = afg.faculty.first_name + " " + afg.faculty.last_name if afg.faculty else "Faculty"
                    add_notif(
                        f"auth_fgp_{afg.id}",
                        "Faculty Gate Pass",
                        req_name,
                        afg.updated_at or afg.created_at,
                        afg.status.value,
                        "/authority/faculty-gatepass",
                        "/authority/faculty-gatepass",
                        "faculty_gatepass"
                    )

            # Auth Announcements
            auth_anns = db.query(Announcement).filter(Announcement.is_global == True).order_by(desc(Announcement.created_at)).limit(5).all()
            for a in auth_anns:
                add_notif(
                    f"auth_ann_{a.id}",
                    "Announcement: " + a.title,
                    "Admin",
                    a.created_at,
                    "Published",
                    "/authority/announcements",
                    "/authority/announcements",
                    "announcement"
                )

    if current_user.role == UserRole.STUDENT:
        student = db.query(Student).filter(Student.user_id == current_user.id).first()
        if student:
            # Student leave decisions
            stu_leaves = db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id == student.id,
                StudentLeaveRequest.status.in_([StudentLeaveStatus.APPROVED, StudentLeaveStatus.REJECTED])
            ).order_by(desc(func.coalesce(StudentLeaveRequest.updated_at, StudentLeaveRequest.created_at))).limit(10).all()
            for sl in stu_leaves:
                add_notif(
                    f"stu_own_leave_{sl.id}",
                    "Your Leave Request",
                    "You",
                    sl.updated_at or sl.created_at,
                    sl.status.value,
                    "/student/leave",
                    "/student/leave",
                    "student_leave"
                )

            # Student gatepass decisions
            stu_gps = db.query(GatePass).filter(
                GatePass.student_id == student.id,
                GatePass.is_deleted_by_student == False,
                GatePass.status.in_([GatePassStatus.APPROVED, GatePassStatus.REJECTED])
            ).order_by(desc(func.coalesce(GatePass.updated_at, GatePass.created_at))).limit(10).all()
            for sg in stu_gps:
                add_notif(
                    f"stu_own_gp_{sg.id}",
                    "Your Gate Pass",
                    "You",
                    sg.updated_at or sg.created_at,
                    sg.status.value,
                    "/student/gatepass",
                    "/student/gatepass",
                    "gatepass"
                )

            # Student Announcements
            stu_anns = db.query(Announcement).filter(Announcement.is_global == True).order_by(desc(Announcement.created_at)).limit(5).all()
            for a in stu_anns:
                add_notif(
                    f"stu_ann_{a.id}",
                    "Announcement: " + a.title,
                    "Admin",
                    a.created_at,
                    "Published",
                    "/student/announcements",
                    "/student/announcements",
                    "announcement"
                )

    # Sort notifications by date descending
    def get_date(n):
        return datetime.fromisoformat(n["date"]) if n["date"] else datetime.min
        
    notifications.sort(key=get_date, reverse=True)
    
    seen = set()
    deduped = []
    for n in notifications:
        if n["id"] not in seen:
            seen.add(n["id"])
            deduped.append(n)
            
    return deduped[:50]


@router.get("/badge-counts", response_model=Dict[str, int])
def get_badge_counts(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    counts = {
        # Faculty
        "/faculty/leave": 0,
        "/faculty/leave/substitutes": 0,
        "/faculty/hod-duty": 0,
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
            # 1. Faculty Leave page — own leave updates
            q_own_leave = db.query(FacultyLeaveRequest).filter(
                FacultyLeaveRequest.faculty_id == faculty.id,
                FacultyLeaveRequest.status != LeaveStatus.PENDING_SUBSTITUTE
            )
            counts["/faculty/leave"] = apply_view_filter(q_own_leave, FacultyLeaveRequest, "faculty-leave", views_dict).count()

            # 1b. Peer Approvals (Class Substitution Requests)
            q_peer_sub = db.query(FacultyDutyArrangement).filter(
                FacultyDutyArrangement.substitute_faculty_id == faculty.id,
                FacultyDutyArrangement.status == ArrangementStatus.PENDING,
                FacultyDutyArrangement.subject != "HOD Duties"
            )
            counts["/faculty/leave/substitutes"] = q_peer_sub.count()

            # 1c. HOD Duty Requests
            q_hod_duty_sub = db.query(FacultyDutyArrangement).filter(
                FacultyDutyArrangement.substitute_faculty_id == faculty.id,
                FacultyDutyArrangement.status == ArrangementStatus.PENDING,
                FacultyDutyArrangement.subject == "HOD Duties"
            )
            q_alt_hod_leave = db.query(FacultyLeaveRequest).filter(
                FacultyLeaveRequest.alternate_hod_faculty_id == faculty.id,
                FacultyLeaveRequest.status == LeaveStatus.PENDING_ALTERNATE_HOD
            )
            counts["/faculty/hod-duty"] = q_hod_duty_sub.count() + q_alt_hod_leave.count()

            # 2. Mentorship — pending mentor-approval leave requests (clears on visit)
            mentees_sub = db.query(MentorAssignment.student_id).filter(MentorAssignment.mentor_id == faculty.id)
            q_mentor_leave = db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id.in_(mentees_sub),
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_MENTOR
            )
            counts["/faculty/mentorship"] = q_mentor_leave.count()

            # 3. Class Advisor leave (clears on visit)
            advised_sections = db.query(Section.id).filter(Section.class_advisor_id == faculty.id, Section.is_active == True)
            ca_students = db.query(Student.id).filter(Student.section_id.in_(advised_sections))
            q_ca_leave = db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id.in_(ca_students),
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_CLASS_ADVISOR
            )
            counts["/faculty/class-advisor/leave"] = q_ca_leave.count()

            # 4. Mentor gate pass approvals (clears on visit)
            q_mentor_gp = db.query(GatePass).filter(
                GatePass.student_id.in_(mentees_sub),
                GatePass.status == GatePassStatus.PENDING_MENTOR,
                GatePass.is_deleted_by_student == False
            )
            counts["/faculty/gatepass"] = q_mentor_gp.count()

            # 5. Late entry notifications (clears on visit)
            q_late = db.query(LateEntryNotification).filter(LateEntryNotification.mentor_id == faculty.id)
            counts["/faculty/late-entry"] = q_late.count()

            # 6. Faculty own gate pass decisions (clears on visit)
            q_fac_gp = db.query(FacultyGatePass).filter(
                FacultyGatePass.faculty_id == faculty.id,
                FacultyGatePass.is_deleted_by_faculty == False,
                FacultyGatePass.status.in_([FacultyGatePassStatus.APPROVED, FacultyGatePassStatus.REJECTED])
            )
            counts["/faculty/faculty-gatepass"] = q_fac_gp.count()

            # 7. Announcements (clears on visit)
            q_fac_ann = db.query(Announcement).filter(Announcement.is_global == True)
            counts["/faculty/announcements"] = q_fac_ann.count()

    from app.api.hod_helper import is_acting_hod, get_managed_department
    if is_acting_hod(current_user, db):
        faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
        dept = get_managed_department(faculty.id, db)
        if faculty and dept:
            dept_students = db.query(Student.id).filter(Student.department_id == dept.id)
            dept_faculty = db.query(Faculty.id).filter(Faculty.department_id == dept.id)

            # HOD leave — student (clears on visit)
            q_hod_stu = db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id.in_(dept_students),
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_HOD
            )
            stu_count = q_hod_stu.count()

            # HOD leave — faculty (clears on visit)
            q_hod_fac = db.query(FacultyLeaveRequest).filter(
                FacultyLeaveRequest.faculty_id.in_(dept_faculty),
                FacultyLeaveRequest.status == LeaveStatus.PENDING_HOD
            )
            fac_count = q_hod_fac.count()

            counts["/hod/leave"] = stu_count + fac_count
            counts["/hod/leave/student"] = stu_count
            counts["/hod/leave/faculty"] = fac_count

            # HOD gate pass (clears on visit)
            q_hod_gp = db.query(GatePass).filter(
                GatePass.student_id.in_(dept_students),
                GatePass.status == GatePassStatus.PENDING_HOD,
                GatePass.is_deleted_by_student == False
            )
            counts["/hod/gatepass"] = q_hod_gp.count()

            # HOD faculty gate pass (clears on visit)
            q_hod_fac_gp = db.query(FacultyGatePass).filter(
                FacultyGatePass.faculty_id.in_(dept_faculty),
                FacultyGatePass.status == FacultyGatePassStatus.PENDING_HOD,
                FacultyGatePass.is_deleted_by_faculty == False
            )
            counts["/hod/faculty-gatepass"] = q_hod_fac_gp.count()

            # HOD discipline (clears on visit)
            q_hod_disc = db.query(DisciplineRecord).filter(DisciplineRecord.student_id.in_(dept_students))
            counts["/hod/discipline"] = q_hod_disc.count()

            # HOD late tracker (clears on visit)
            q_hod_late = db.query(LateRecord).filter(LateRecord.student_id.in_(dept_students))
            counts["/hod/latetracker"] = q_hod_late.count()

            # HOD announcements (clears on visit)
            q_hod_ann = db.query(Announcement).filter(Announcement.is_global == True)
            counts["/hod/announcements"] = q_hod_ann.count()

    if current_user.role == UserRole.AUTHORITY:
        from app.models.authority import Authority as AuthorityModel
        auth = db.query(AuthorityModel).filter(AuthorityModel.user_id == current_user.id).first()
        if auth:
            title = auth.title.lower().strip()

            # Authority leave (clears on visit)
            if "dean" in title:
                q_auth_leave = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.status == LeaveStatus.PENDING_DEAN)
                counts["/authority/leave"] = q_auth_leave.count()
            elif "manager" in title or "principal" in title:
                q_auth_leave = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.status == LeaveStatus.PENDING_OM)
                counts["/authority/leave"] = q_auth_leave.count()

            # Authority gate pass — OM/Principal (clears on visit)
            if "manager" in title or "principal" in title:
                q_auth_gp = db.query(GatePass).filter(
                    GatePass.status == GatePassStatus.PENDING_OM,
                    GatePass.is_deleted_by_student == False
                )
                counts["/authority/gatepass"] = q_auth_gp.count()

            # Authority faculty gate pass (clears on visit)
            if "dean" in title:
                q_auth_fgp = db.query(FacultyGatePass).filter(
                    FacultyGatePass.status == FacultyGatePassStatus.PENDING_DEAN,
                    FacultyGatePass.is_deleted_by_faculty == False
                )
                counts["/authority/faculty-gatepass"] = q_auth_fgp.count()
            elif "manager" in title or "principal" in title:
                q_auth_fgp = db.query(FacultyGatePass).filter(
                    FacultyGatePass.status == FacultyGatePassStatus.PENDING_OM,
                    FacultyGatePass.is_deleted_by_faculty == False
                )
                counts["/authority/faculty-gatepass"] = q_auth_fgp.count()

            # Dean messaging — keeps real unread count (messaging manages its own state)
            if "dean" in title:
                from app.models.messaging import Conversation
                counts["/dean/messaging"] = db.query(Conversation).filter(
                    Conversation.dean_id == auth.id,
                    Conversation.dean_unread_count > 0
                ).count()

            # Authority announcements (clears on visit)
            q_auth_ann = db.query(Announcement).filter(Announcement.is_global == True)
            counts["/authority/announcements"] = q_auth_ann.count()

    if current_user.role == UserRole.STUDENT:
        student = db.query(Student).filter(Student.user_id == current_user.id).first()
        if student:
            # Student leave decisions - Informational
            q_stu_leave = db.query(StudentLeaveRequest).filter(
                StudentLeaveRequest.student_id == student.id,
                StudentLeaveRequest.status.in_([StudentLeaveStatus.APPROVED, StudentLeaveStatus.REJECTED])
            )
            counts["/student/leave"] = q_stu_leave.count()

            # Student gatepass decisions - Informational
            q_stu_gp = db.query(GatePass).filter(
                GatePass.student_id == student.id,
                GatePass.is_deleted_by_student == False,
                GatePass.status.in_([GatePassStatus.APPROVED, GatePassStatus.REJECTED])
            )
            counts["/student/gatepass"] = q_stu_gp.count()

            # Student late entry - Informational (mentor commented on student's notification since last viewed)
            q_stu_late = db.query(LateEntryNotification).filter(
                LateEntryNotification.student_id == student.id,
                LateEntryNotification.mentor_comment != None
            )
            counts["/student/late-entry"] = q_stu_late.count()

            # Student announcements - Informational (new global announcements)
            q_stu_ann = db.query(Announcement).filter(Announcement.is_global == True)
            counts["/student/announcements"] = q_stu_ann.count()

            # Messaging
            from app.models.messaging import Conversation
            counts["/student/messaging"] = db.query(Conversation).filter(
                Conversation.student_id == student.id,
                Conversation.student_unread_count > 0
            ).count()

    if current_user.role == UserRole.ADMIN:
        # Admin discipline - Informational (new discipline records since last viewed)
        q_admin_disc = db.query(DisciplineRecord)
        counts["/admin/discipline"] = q_admin_disc.count()

        # Admin late tracker - Informational (new late records since last viewed)
        q_admin_late = db.query(LateRecord)
        counts["/admin/latetracker"] = q_admin_late.count()

        # Admin announcements - Informational (new announcements since last viewed)
        q_admin_ann = db.query(Announcement)
        counts["/admin/announcements"] = q_admin_ann.count()

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
