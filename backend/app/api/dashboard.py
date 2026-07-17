"""
Campus Connect ERP — Dashboard API
Provides statistics and metrics for different user roles
"""
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func, and_, or_
from datetime import datetime, date
from typing import Dict, Any

from app.core.database import get_db
from app.core.security import get_current_active_user
from app.models.user import User
from app.models.student import Student
from app.models.faculty import Faculty
from app.models.authority import Authority
from app.models.discipline import DisciplineRecord
from app.models.gatepass import GatePass, GatePassStatus
from app.models.leave import (
    FacultyLeaveRequest, 
    StudentLeaveRequest, 
    LeaveStatus,
    StudentLeaveStatus
)
from app.models.department import Department

router = APIRouter()

@router.get("/debug/user-info")
def get_user_debug_info(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
) -> Dict[str, Any]:
    """
    Debug endpoint to check user information and authority title
    """
    user_info = {
        "user_id": current_user.id,
        "email": current_user.email,
        "role": current_user.role,
        "is_active": current_user.is_active
    }
    
    if current_user.role == "authority":
        authority = db.query(Authority).filter(Authority.user_id == current_user.id).first()
        if authority:
            user_info["authority"] = {
                "id": authority.id,
                "first_name": authority.first_name,
                "last_name": authority.last_name,
                "title": authority.title,
                "title_length": len(authority.title),
                "title_repr": repr(authority.title),  # Shows hidden characters
                "email": authority.email,
                "employee_id": authority.employee_id
            }
        else:
            user_info["authority"] = None
            user_info["error"] = "Authority profile not found"
    
    return user_info

@router.get("/authority/stats")
def get_authority_dashboard_stats(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
) -> Dict[str, Any]:
    """
    Get comprehensive dashboard statistics for Office Manager users (authority/OM)
    """
    if current_user.role != "authority":
        raise HTTPException(status_code=403, detail="Access denied")
    
    # NOTE: Not checking specific title to allow any authority user to view OM dashboard
    # This is intentional for backward compatibility
    
    try:
        from datetime import timedelta
        from app.models.academic import Course, Enrollment
        from app.models.attendance import Attendance
        from app.models.grade import Grade
        
        # 1. TOP NUMBERS (Stat Cards)
        total_students = db.query(Student).filter(Student.is_active == True).count()
        total_faculty = db.query(Faculty).filter(Faculty.is_active == True).count()
        total_departments = db.query(Department).count()
        
        # Active courses (courses with enrollments in current semester)
        try:
            active_courses = db.query(Course).filter(Course.is_active == True).count()
        except Exception:
            active_courses = 0
        
        # Attendance by department and Overall Attendance calculation
        attendance_by_dept = []
        departments = db.query(Department).all()
        
        global_total = 0
        global_present = 0
        
        from app.core.utils import get_sem_start_date
        
        for dept in departments:
            try:
                dept_students = db.query(Student).filter(
                    Student.department_id == dept.id,
                    Student.is_active == True
                ).all()
                student_ids = [s.id for s in dept_students]
                
                if student_ids:
                    sem_start_date = get_sem_start_date(dept.id, db)
                    dept_total = db.query(Attendance).filter(
                        Attendance.student_id.in_(student_ids),
                        Attendance.date >= sem_start_date
                    ).count()
                    dept_present = db.query(Attendance).filter(
                        Attendance.student_id.in_(student_ids),
                        Attendance.status == "present",
                        Attendance.date >= sem_start_date
                    ).count()
                    dept_percent = round((dept_present / dept_total * 100), 2) if dept_total > 0 else 0
                    
                    global_total += dept_total
                    global_present += dept_present
                else:
                    dept_percent = 0
            except Exception:
                dept_percent = 0
                
            attendance_by_dept.append({
                "department_name": dept.name,
                "department_code": dept.code,
                "attendance_percent": dept_percent
            })
            
        overall_attendance_percent = round((global_present / global_total * 100), 2) if global_total > 0 else 0
        
        # 3. ACADEMIC PERFORMANCE
        # Overall pass percentage (students with passing grades)
        try:
            total_grades = db.query(Grade).count()
            passing_grades = db.query(Grade).filter(
                Grade.marks_obtained >= 50
            ).count()
            overall_pass_percent = round((passing_grades / total_grades * 100), 2) if total_grades > 0 else 0
        except Exception:
            overall_pass_percent = 0
        
        # Pass percentage by department
        performance_by_dept = []
        for dept in departments:
            try:
                dept_students = db.query(Student).filter(
                    Student.department_id == dept.id,
                    Student.is_active == True
                ).all()
                student_ids = [s.id for s in dept_students]
                
                if student_ids:
                    dept_grades = db.query(Grade).filter(Grade.student_id.in_(student_ids)).count()
                    dept_passing = db.query(Grade).filter(
                        Grade.student_id.in_(student_ids),
                        Grade.marks_obtained >= 50
                    ).count()
                    dept_pass_percent = round((dept_passing / dept_grades * 100), 2) if dept_grades > 0 else 0
                else:
                    dept_pass_percent = 0
            except Exception:
                dept_pass_percent = 0
                
            performance_by_dept.append({
                "department_name": dept.name,
                "department_code": dept.code,
                "pass_percent": dept_pass_percent
            })
        
        # 4. PENDING REQUESTS
        # Gate passes pending OM approval
        pending_gate_passes = db.query(GatePass).filter(
            GatePass.status == GatePassStatus.PENDING_OM,
            GatePass.is_deleted_by_student == False
        ).count()
        
        # Faculty leave requests pending OM approval
        pending_faculty_leaves = db.query(FacultyLeaveRequest).filter(
            FacultyLeaveRequest.status == LeaveStatus.PENDING_OM
        ).count()
        
        # Student complaints/discipline records needing attention
        today_discipline_count = db.query(DisciplineRecord).filter(
            func.date(DisciplineRecord.incident_date) == date.today()
        ).count()
        
        # 5. RECENT ALERTS (Last 10 notifications/updates)
        seven_days_ago = date.today() - timedelta(days=7)
        
        # Recent discipline incidents
        recent_discipline = db.query(DisciplineRecord).filter(
            DisciplineRecord.incident_date >= seven_days_ago
        ).order_by(DisciplineRecord.created_at.desc()).limit(5).all()
        
        # Recent gate passes
        recent_gate_passes = db.query(GatePass).filter(
            GatePass.status == GatePassStatus.PENDING_OM,
            GatePass.is_deleted_by_student == False
        ).order_by(GatePass.created_at.desc()).limit(5).all()
        
        # Recent faculty leaves
        recent_leaves = db.query(FacultyLeaveRequest).filter(
            FacultyLeaveRequest.status == LeaveStatus.PENDING_OM
        ).order_by(FacultyLeaveRequest.created_at.desc()).limit(5).all()
        
        # Compile recent alerts
        recent_alerts = []
        
        for disc in recent_discipline:
            try:
                recent_alerts.append({
                    "type": "discipline",
                    "message": f"Discipline incident: {disc.incident_type.value}",
                    "student_name": f"{disc.student.first_name} {disc.student.last_name}" if disc.student else "Unknown",
                    "timestamp": disc.created_at.isoformat(),
                    "severity": "high"
                })
            except Exception:
                pass
        
        for gp in recent_gate_passes:
            try:
                recent_alerts.append({
                    "type": "gatepass",
                    "message": f"Gate pass approval pending",
                    "student_name": f"{gp.student.first_name} {gp.student.last_name}" if gp.student else "Unknown",
                    "timestamp": gp.created_at.isoformat(),
                    "severity": "medium"
                })
            except Exception:
                pass
        
        for leave in recent_leaves:
            try:
                recent_alerts.append({
                    "type": "leave",
                    "message": f"Faculty leave request pending",
                    "faculty_name": f"{leave.faculty.first_name} {leave.faculty.last_name}" if leave.faculty else "Unknown",
                    "timestamp": leave.created_at.isoformat(),
                    "severity": "medium"
                })
            except Exception:
                pass
        
        # Sort alerts by timestamp, newest first
        recent_alerts.sort(key=lambda x: x["timestamp"], reverse=True)
        recent_alerts = recent_alerts[:10]  # Limit to 10 most recent
        
        return {
            # Top Numbers
            "total_students": total_students,
            "total_faculty": total_faculty,
            "total_departments": total_departments,
            "active_courses": active_courses,
            
            # Attendance Overview
            "overall_attendance_percent": overall_attendance_percent,
            "attendance_by_department": attendance_by_dept,
            
            # Academic Performance
            "overall_pass_percent": overall_pass_percent,
            "performance_by_department": performance_by_dept,
            
            # Pending Requests
            "pending_gate_passes": pending_gate_passes,
            "pending_faculty_leaves": pending_faculty_leaves,
            "pending_complaints": today_discipline_count,
            "total_pending": pending_gate_passes + pending_faculty_leaves + today_discipline_count,
            
            # Recent Alerts
            "recent_alerts": recent_alerts,
            
            # Metadata
            "last_updated": datetime.now().isoformat()
        }
    except Exception as e:
        import traceback
        print(f"Dashboard error: {str(e)}")
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=f"Dashboard error: {str(e)}")

@router.get("/admin/stats")
def get_admin_dashboard_stats(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
) -> Dict[str, Any]:
    """
    Get dashboard statistics for admin users
    """
    if current_user.role != "admin":
        raise HTTPException(status_code=403, detail="Access denied")
    
    # Similar to authority but with admin-specific metrics
    total_students = db.query(Student).filter(Student.is_active == True).count()
    total_faculty = db.query(Faculty).filter(Faculty.is_active == True).count()
    total_authorities = db.query(Authority).count()
    active_users = db.query(User).filter(User.is_active == True).count()
    total_departments = db.query(Department).count()
    
    # All pending approvals across system
    pending_gate_passes = db.query(GatePass).filter(
        GatePass.status.in_([
            GatePassStatus.PENDING_MENTOR,
            GatePassStatus.PENDING_HOD,
            GatePassStatus.PENDING_OM
        ]),
        GatePass.is_deleted_by_student == False
    ).count()
    
    pending_leaves = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.status.in_([
            LeaveStatus.PENDING_SUBSTITUTE,
            LeaveStatus.PENDING_HOD,
            LeaveStatus.PENDING_DEAN,
            LeaveStatus.PENDING_OM
        ])
    ).count()
    
    pending_student_leaves = db.query(StudentLeaveRequest).filter(
        StudentLeaveRequest.status.in_([
            StudentLeaveStatus.PENDING_MENTOR,
            StudentLeaveStatus.PENDING_CLASS_ADVISOR,
            StudentLeaveStatus.PENDING_HOD
        ])
    ).count()
    
    total_pending = pending_gate_passes + pending_leaves + pending_student_leaves
    
    return {
        "total_students": total_students,
        "total_faculty": total_faculty,
        "total_authorities": total_authorities,
        "active_users": active_users,
        "total_departments": total_departments,
        "pending_approvals": total_pending,
        "pending_gate_passes": pending_gate_passes,
        "pending_faculty_leaves": pending_leaves,
        "pending_student_leaves": pending_student_leaves,
        "system_status_percent": 99.5,
        "last_updated": datetime.now().isoformat()
    }

@router.get("/faculty/stats")
def get_faculty_dashboard_stats(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
) -> Dict[str, Any]:
    """
    Get dashboard statistics for faculty users
    """
    if current_user.role != "faculty":
        raise HTTPException(status_code=403, detail="Access denied")
    
    # Get faculty profile
    faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
    if not faculty:
        raise HTTPException(status_code=404, detail="Faculty profile not found")
    
    # Mentees count
    from app.models.mentorship import MentorAssignment
    mentees_count = db.query(MentorAssignment).filter(
        MentorAssignment.mentor_id == faculty.id
    ).count()
    
    # Pending gate passes (if mentor)
    pending_gate_passes = db.query(GatePass).filter(
        GatePass.status == GatePassStatus.PENDING_MENTOR,
        GatePass.mentor_id == faculty.id,
        GatePass.is_deleted_by_student == False
    ).count()
    
    # Pending student leaves (as mentor)
    pending_student_leaves = db.query(StudentLeaveRequest).filter(
        or_(
            and_(
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_MENTOR,
                StudentLeaveRequest.mentor_id == faculty.id
            ),
            and_(
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_CLASS_ADVISOR,
                StudentLeaveRequest.class_advisor_id == faculty.id
            ),
            and_(
                StudentLeaveRequest.status == StudentLeaveStatus.PENDING_HOD,
                StudentLeaveRequest.hod_id == faculty.id
            )
        )
    ).count()
    
    # My leave requests
    my_leave_requests = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.faculty_id == faculty.id
    ).count()
    
    total_pending = pending_gate_passes + pending_student_leaves
    
    return {
        "mentees_count": mentees_count,
        "pending_gate_passes": pending_gate_passes,
        "pending_student_leaves": pending_student_leaves,
        "my_leave_requests": my_leave_requests,
        "total_pending_tasks": total_pending,
        "department": faculty.department.name if faculty.department else "N/A",
        "last_updated": datetime.now().isoformat()
    }

@router.get("/dean/stats")
def get_dean_dashboard_stats(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
) -> Dict[str, Any]:
    """
    Get comprehensive dashboard statistics for Dean users (view-only)
    Similar to authority dashboard but specifically for Dean role
    """
    if current_user.role != "authority":
        raise HTTPException(status_code=403, detail="Access denied")
    
    # Verify user is an allowed Authority
    authority = db.query(Authority).filter(Authority.user_id == current_user.id).first()
    if not authority or authority.title not in ["Office Manager", "Vice Principal", "Principal", "Dean"]:
        raise HTTPException(status_code=403, detail="Access denied: Higher authority role required")
    
    from datetime import timedelta
    from app.models.academic import Course, Enrollment
    from app.models.attendance import Attendance, FacultyAttendance
    from app.models.grade import Grade, GRADE_PASS_MARKS
    from app.models.retest import RetestMark
    from app.models.lms import Announcement
    from app.models.gatepass import GatePass, GatePassStatus
    from app.models.leave import FacultyLeaveRequest    
    today_date = date.today()
    
    # 1. TOP NUMBERS (Stat Cards)
    total_students = db.query(Student).filter(Student.is_active == True).count()
    total_faculty = db.query(Faculty).filter(Faculty.is_active == True).count()
    total_departments = db.query(Department).count()
    
    # Active courses (courses with enrollments in current semester)
    active_courses = db.query(Course).filter(Course.is_active == True).count()
    
    # 2. ATTENDANCE OVERVIEW
    # Attendance by department and Overall Attendance calculation
    attendance_by_dept = []
    departments = db.query(Department).all()
    
    global_total = 0
    global_present = 0
    
    from app.core.utils import get_sem_start_date
    
    for dept in departments:
        # Students
        dept_students = db.query(Student).filter(
            Student.department_id == dept.id,
            Student.is_active == True
        ).all()
        student_ids = [s.id for s in dept_students]
        total_dept_students = len(student_ids)
        
        if student_ids:
            sem_start_date = get_sem_start_date(dept.id, db)
            dept_total = db.query(Attendance).filter(
                Attendance.student_id.in_(student_ids),
                Attendance.date >= sem_start_date
            ).count()
            dept_present = db.query(Attendance).filter(
                Attendance.student_id.in_(student_ids),
                Attendance.status == "present",
                Attendance.date >= sem_start_date
            ).count()
            dept_percent = round((dept_present / dept_total * 100), 2) if dept_total > 0 else 0
            
            # Today's Student Attendance
            student_present_today = db.query(Attendance.student_id).filter(
                Attendance.student_id.in_(student_ids),
                Attendance.date == today_date,
                Attendance.status == "present"
            ).distinct().count()
            student_absent_today = total_dept_students - student_present_today
            
            # Gender-wise Today
            boys = [s for s in dept_students if s.gender and s.gender.lower() in ["male", "m", "boy"]]
            girls = [s for s in dept_students if s.gender and s.gender.lower() in ["female", "f", "girl"]]
            
            boys_ids = [s.id for s in boys]
            girls_ids = [s.id for s in girls]
            
            boys_present = db.query(Attendance.student_id).filter(
                Attendance.student_id.in_(boys_ids),
                Attendance.date == today_date,
                Attendance.status == "present"
            ).distinct().count() if boys_ids else 0
            
            girls_present = db.query(Attendance.student_id).filter(
                Attendance.student_id.in_(girls_ids),
                Attendance.date == today_date,
                Attendance.status == "present"
            ).distinct().count() if girls_ids else 0
            
            boys_percent = round((boys_present / len(boys_ids)) * 100, 2) if boys_ids else 0
            girls_percent = round((girls_present / len(girls_ids)) * 100, 2) if girls_ids else 0
            
            global_total += dept_total
            global_present += dept_present
        else:
            dept_percent = 0
            student_present_today = 0
            student_absent_today = 0
            boys_percent = 0
            girls_percent = 0
            
        # Faculty
        dept_faculty = db.query(Faculty).filter(
            Faculty.department_id == dept.id,
            Faculty.is_active == True
        ).all()
        faculty_ids = [f.id for f in dept_faculty]
        total_dept_faculty = len(faculty_ids)
        
        if faculty_ids:
            # Faculty are considered absent only if they have an approved leave request for today
            faculty_absent_today = db.query(FacultyLeaveRequest).filter(
                FacultyLeaveRequest.faculty_id.in_(faculty_ids),
                FacultyLeaveRequest.status == "approved",
                FacultyLeaveRequest.from_date <= today_date,
                FacultyLeaveRequest.to_date >= today_date
            ).count()
            
            faculty_present_today = total_dept_faculty - faculty_absent_today
        else:
            faculty_present_today = 0
            faculty_absent_today = 0
            
        attendance_by_dept.append({
            "department_name": dept.name,
            "department_code": dept.code,
            "attendance_percent": dept_percent,
            "student_present_today": student_present_today,
            "student_absent_today": student_absent_today,
            "faculty_present_today": faculty_present_today,
            "faculty_absent_today": faculty_absent_today,
            "boys_percent": boys_percent,
            "girls_percent": girls_percent
        })
        
    overall_attendance_percent = round((global_present / global_total * 100), 2) if global_total > 0 else 0
    
    # 3. ACADEMIC PERFORMANCE
    performance_by_dept = []
    
    global_total_grades = 0
    global_passing_grades = 0
    
    for dept in departments:
        dept_data = {
            "department_name": dept.name,
            "department_code": dept.code,
            "pass_percent": 0.0,
            "years": []
        }
        
        dept_students = db.query(Student).filter(
            Student.department_id == dept.id,
            Student.is_active == True
        ).all()
        
        years = {}
        for s in dept_students:
            y = s.current_year
            if not y:
                continue
            if y not in years:
                years[y] = {"year": y, "pass": 0, "total": 0, "sections": {}}
                
            sec = s.section.name if s.section else "Unknown"
            if sec not in years[y]["sections"]:
                years[y]["sections"][sec] = {"section_name": sec, "pass": 0, "total": 0}
                
        student_ids = [s.id for s in dept_students]
        if student_ids:
            # Pre-fetch grades and retests for efficiency
            grades = db.query(Grade).filter(
                Grade.student_id.in_(student_ids),
                Grade.marks_obtained.isnot(None)
            ).all()
            
            grade_ids = [g.id for g in grades]
            retests = db.query(RetestMark).filter(RetestMark.grade_id.in_(grade_ids)).all() if grade_ids else []
            retest_map = {r.grade_id: r.marks_obtained for r in retests}
            
            student_map = {s.id: {"year": s.current_year, "section": s.section.name if s.section else "Unknown"} for s in dept_students}
            
            dept_total = 0
            dept_pass = 0
            
            for g in grades:
                y = student_map[g.student_id]["year"]
                sec = student_map[g.student_id]["section"]
                
                if not y:
                    continue
                    
                threshold = GRADE_PASS_MARKS.get(g.grade_type, 50)
                
                # Check retest first
                mark = g.marks_obtained
                if g.id in retest_map and retest_map[g.id] is not None:
                    mark = retest_map[g.id]
                    
                is_pass = 1 if mark is not None and mark >= threshold else 0
                
                dept_total += 1
                dept_pass += is_pass
                years[y]["total"] += 1
                years[y]["pass"] += is_pass
                years[y]["sections"][sec]["total"] += 1
                years[y]["sections"][sec]["pass"] += is_pass
                
            global_total_grades += dept_total
            global_passing_grades += dept_pass
            
            dept_data["pass_percent"] = round((dept_pass / dept_total * 100), 2) if dept_total > 0 else 0
            
            for y_key, y_data in years.items():
                year_obj = {
                    "year": y_key,
                    "pass_percent": round((y_data["pass"] / y_data["total"] * 100), 2) if y_data["total"] > 0 else 0,
                    "sections": []
                }
                for sec_key, sec_data in y_data["sections"].items():
                    year_obj["sections"].append({
                        "section_name": sec_key,
                        "pass_percent": round((sec_data["pass"] / sec_data["total"] * 100), 2) if sec_data["total"] > 0 else 0
                    })
                year_obj["sections"].sort(key=lambda x: x["section_name"])
                dept_data["years"].append(year_obj)
                
            dept_data["years"].sort(key=lambda x: x["year"])
            
        performance_by_dept.append(dept_data)
        
    overall_pass_percent = round((global_passing_grades / global_total_grades * 100), 2) if global_total_grades > 0 else 0
    
    # 4. PENDING REQUESTS
    # Faculty leave requests pending Dean approval
    pending_faculty_leaves = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.status == LeaveStatus.PENDING_DEAN
    ).count()
    
    # Gatepasses pending Dean approval (Assuming Dean sees HOD or OM level depending on the flow, but let's query all pending for simplicity)
    # If the Dean acts as an authority for gatepasses, maybe they approve them? The OM approves them usually. Let's return the count anyway if the Dean needs to see them.
    pending_gate_passes = db.query(GatePass).filter(
        GatePass.status.in_([GatePassStatus.PENDING_HOD, GatePassStatus.PENDING_OM]),
        GatePass.is_deleted_by_student == False
    ).count()
    
    # Student complaints/discipline records needing attention
    today_discipline_count = db.query(DisciplineRecord).filter(
        func.date(DisciplineRecord.incident_date) == date.today()
    ).count()
    
    total_pending = pending_faculty_leaves + pending_gate_passes + today_discipline_count
    
    # 5. RECENT ALERTS (Last 10 notifications/updates)
    seven_days_ago = date.today() - timedelta(days=7)
    
    # Recent discipline incidents
    recent_discipline = db.query(DisciplineRecord).filter(
        DisciplineRecord.incident_date >= seven_days_ago
    ).order_by(DisciplineRecord.created_at.desc()).limit(5).all()
    
    # Recent faculty leaves pending Dean approval
    recent_leaves = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.status == LeaveStatus.PENDING_DEAN
    ).order_by(FacultyLeaveRequest.created_at.desc()).limit(5).all()
    
    # Compile recent alerts
    recent_alerts = []
    
    for disc in recent_discipline:
        recent_alerts.append({
            "type": "discipline",
            "message": f"Discipline incident: {disc.incident_type.value}",
            "student_name": f"{disc.student.first_name} {disc.student.last_name}" if disc.student else "Unknown",
            "timestamp": disc.created_at.isoformat(),
            "severity": "high"
        })
    
    for leave in recent_leaves:
        recent_alerts.append({
            "type": "leave",
            "message": f"Faculty leave request pending Dean approval",
            "faculty_name": f"{leave.faculty.first_name} {leave.faculty.last_name}" if leave.faculty else "Unknown",
            "timestamp": leave.created_at.isoformat(),
            "severity": "medium"
        })
    
    # Sort alerts by timestamp, newest first
    recent_alerts.sort(key=lambda x: x["timestamp"], reverse=True)
    recent_alerts = recent_alerts[:10]  # Limit to 10 most recent
    
    # 6. LATE ARRIVALS TREND (Last 30 Days)
    from app.models.late import LateRecord
    from collections import defaultdict
    thirty_days_ago = today_date - timedelta(days=30)
    
    late_entries = db.query(LateRecord).filter(
        LateRecord.date >= thirty_days_ago,
        LateRecord.date <= today_date
    ).all()
        
    # 7. STUDENT DEMOGRAPHICS
    all_active_students = db.query(Student).filter(Student.is_active == True).all()
    student_map = {s.id: s for s in all_active_students}
    
    demographics_raw = {"ALL": {"hostel": 0, "day_scholar": 0, "bus": 0, "own": 0}}
    for dept in departments:
        demographics_raw[dept.code] = {"hostel": 0, "day_scholar": 0, "bus": 0, "own": 0}
        
    for s in all_active_students:
        if s.accommodation == "Hostel":
            demographics_raw["ALL"]["hostel"] += 1
            if s.department: demographics_raw[s.department.code]["hostel"] += 1
        elif s.accommodation == "Day Scholar":
            demographics_raw["ALL"]["day_scholar"] += 1
            if s.department: demographics_raw[s.department.code]["day_scholar"] += 1
            
        if s.transportation == "BUS":
            demographics_raw["ALL"]["bus"] += 1
            if s.department: demographics_raw[s.department.code]["bus"] += 1
        elif s.transportation == "OWN":
            demographics_raw["ALL"]["own"] += 1
            if s.department: demographics_raw[s.department.code]["own"] += 1
            
    demographics = {}
    for key, data in demographics_raw.items():
        demographics[key] = {
            "accommodation": [
                {"name": "Hostel", "value": data["hostel"]},
                {"name": "Day Scholar", "value": data["day_scholar"]}
            ],
            "transportation": [
                {"name": "College Bus", "value": data["bus"]},
                {"name": "Own Transport", "value": data["own"]}
            ]
        }
        
    # 8. MONTHLY ATTENDANCE TREND
    
    all_active_faculty = db.query(Faculty).filter(Faculty.is_active == True).all()
    faculty_map = {f.id: f for f in all_active_faculty}
    
    student_attendance_records = db.query(Attendance).filter(
        Attendance.date >= thirty_days_ago,
        Attendance.date <= today_date
    ).all()
    
    faculty_leave_records = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.status == "approved",
        FacultyLeaveRequest.to_date >= thirty_days_ago,
        FacultyLeaveRequest.from_date <= today_date
    ).all()
    
    monthly_attendance_trend = {"ALL": []}
    late_trend = {"ALL": []}
    for dept in departments:
        monthly_attendance_trend[dept.code] = []
        late_trend[dept.code] = []
        
    for i in range(31):
        d_date = thirty_days_ago + timedelta(days=i)
        d_str = d_date.isoformat()
        
        stats_for_day = {"ALL": {"boys_total": 0, "boys_present": 0, "girls_total": 0, "girls_present": 0, "boys_late": 0, "girls_late": 0, "faculty_total": len(all_active_faculty), "faculty_absent": 0}}
        for dept in departments:
            stats_for_day[dept.code] = {"boys_total": 0, "boys_present": 0, "girls_total": 0, "girls_present": 0, "boys_late": 0, "girls_late": 0, "faculty_total": sum(1 for f in all_active_faculty if f.department_id == dept.id), "faculty_absent": 0}
            
        for s in all_active_students:
            is_boy = s.gender and s.gender.strip().lower() in ['m', 'male', 'boy']
            is_girl = s.gender and s.gender.strip().lower() in ['f', 'female', 'girl']
            
            if is_boy:
                stats_for_day["ALL"]["boys_total"] += 1
                if s.department:
                    stats_for_day[s.department.code]["boys_total"] += 1
            elif is_girl:
                stats_for_day["ALL"]["girls_total"] += 1
                if s.department:
                    stats_for_day[s.department.code]["girls_total"] += 1
                
        seen_student_attendance = set()
        for att in student_attendance_records:
            if att.date == d_date and att.status == "present":
                if (att.student_id, d_date) not in seen_student_attendance:
                    seen_student_attendance.add((att.student_id, d_date))
                    s = student_map.get(att.student_id)
                    if s:
                        is_boy = s.gender and s.gender.strip().lower() in ['m', 'male', 'boy']
                        is_girl = s.gender and s.gender.strip().lower() in ['f', 'female', 'girl']
                        
                        if is_boy:
                            stats_for_day["ALL"]["boys_present"] += 1
                            if s.department:
                                stats_for_day[s.department.code]["boys_present"] += 1
                        elif is_girl:
                            stats_for_day["ALL"]["girls_present"] += 1
                            if s.department:
                                stats_for_day[s.department.code]["girls_present"] += 1
                            
        seen_faculty_absent = set()
        
        for entry in late_entries:
            if entry.date == d_date:
                s = student_map.get(entry.student_id)
                if s:
                    is_boy = s.gender and s.gender.strip().lower() in ['m', 'male', 'boy']
                    is_girl = s.gender and s.gender.strip().lower() in ['f', 'female', 'girl']
                    
                    if is_boy:
                        stats_for_day["ALL"]["boys_late"] += 1
                        if s.department:
                            stats_for_day[s.department.code]["boys_late"] += 1
                    elif is_girl:
                        stats_for_day["ALL"]["girls_late"] += 1
                        if s.department:
                            stats_for_day[s.department.code]["girls_late"] += 1
                            
        for leave in faculty_leave_records:
            if leave.from_date <= d_date <= leave.to_date:
                if (leave.faculty_id, d_date) not in seen_faculty_absent:
                    seen_faculty_absent.add((leave.faculty_id, d_date))
                    f = faculty_map.get(leave.faculty_id)
                    if f:
                        stats_for_day["ALL"]["faculty_absent"] += 1
                        if f.department:
                            stats_for_day[f.department.code]["faculty_absent"] += 1
                            
        for key in stats_for_day:
            st = stats_for_day[key]
            boys_pct = round(st["boys_present"] / st["boys_total"] * 100, 2) if st["boys_total"] > 0 else 0
            girls_pct = round(st["girls_present"] / st["girls_total"] * 100, 2) if st["girls_total"] > 0 else 0
            fac_pct = round((st["faculty_total"] - st["faculty_absent"]) / st["faculty_total"] * 100, 2) if st["faculty_total"] > 0 else 0
            
            monthly_attendance_trend[key].append({
                "date": d_str,
                "boys_percent": boys_pct,
                "girls_percent": girls_pct,
                "boys_present": st["boys_present"],
                "girls_present": st["girls_present"],
                "boys_total": st["boys_total"],
                "girls_total": st["girls_total"],
                "faculty_present_percent": fac_pct
            })
            
            late_trend[key].append({
                "date": d_str,
                "boys_late": st["boys_late"],
                "girls_late": st["girls_late"]
            })
    
    return {
        # Top Numbers
        "total_students": total_students,
        "total_faculty": total_faculty,
        "total_departments": total_departments,
        "active_courses": active_courses,
        
        # Attendance Overview
        "overall_attendance_percent": overall_attendance_percent,
        "attendance_by_department": attendance_by_dept,
        
        # Academic Performance
        "overall_pass_percent": overall_pass_percent,
        "academic_performance": performance_by_dept,
        
        # Pending Requests
        "pending_faculty_leaves": pending_faculty_leaves,
        "pending_gate_passes": pending_gate_passes,
        "pending_complaints": today_discipline_count,
        "total_pending": total_pending,
        
        # Recent Alerts
        "recent_alerts": recent_alerts,
        
        # New Detailed Analytics
        "monthly_attendance_trend": monthly_attendance_trend,
        "late_trend": late_trend,
        "demographics": demographics,
        
        # Announcements
        "announcements": [
            {
                "id": a.id,
                "title": a.title,
                "content": a.content,
                "category": a.category,
                "created_at": a.created_at.isoformat() if a.created_at else None,
                "posted_by": f"{a.posted_by.first_name} {a.posted_by.last_name}" if a.posted_by else "Admin"
            } for a in db.query(Announcement).order_by(Announcement.created_at.desc()).limit(5).all()
        ],
        
        # Metadata
        "last_updated": datetime.now().isoformat()
    }

@router.get("/principal/stats")
def get_principal_dashboard_stats(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
) -> Dict[str, Any]:
    """
    Get comprehensive dashboard statistics for Principal users (view-only)
    Similar to OM dashboard but specifically for Principal role
    """
    if current_user.role != "authority":
        raise HTTPException(status_code=403, detail="Access denied")
    
    # NOTE: Not checking specific title to allow any authority user
    # This allows for flexible title variations in the database
    
    from datetime import timedelta
    from app.models.academic import Course, Enrollment
    from app.models.attendance import Attendance
    from app.models.grade import Grade
    
    # 1. TOP NUMBERS (Stat Cards)
    total_students = db.query(Student).filter(Student.is_active == True).count()
    total_faculty = db.query(Faculty).filter(Faculty.is_active == True).count()
    total_departments = db.query(Department).count()
    
    # Active courses (courses with enrollments in current semester)
    active_courses = db.query(Course).filter(Course.is_active == True).count()
    
    # 2. ATTENDANCE OVERVIEW
    # Attendance by department and Overall Attendance calculation
    attendance_by_dept = []
    departments = db.query(Department).all()
    
    global_total = 0
    global_present = 0
    
    from app.core.utils import get_sem_start_date
    
    for dept in departments:
        dept_students = db.query(Student).filter(
            Student.department_id == dept.id,
            Student.is_active == True
        ).all()
        student_ids = [s.id for s in dept_students]
        
        if student_ids:
            sem_start_date = get_sem_start_date(dept.id, db)
            dept_total = db.query(Attendance).filter(
                Attendance.student_id.in_(student_ids),
                Attendance.date >= sem_start_date
            ).count()
            dept_present = db.query(Attendance).filter(
                Attendance.student_id.in_(student_ids),
                Attendance.status == "present",
                Attendance.date >= sem_start_date
            ).count()
            dept_percent = round((dept_present / dept_total * 100), 2) if dept_total > 0 else 0
            
            global_total += dept_total
            global_present += dept_present
        else:
            dept_percent = 0
            
        attendance_by_dept.append({
            "department_name": dept.name,
            "department_code": dept.code,
            "attendance_percent": dept_percent
        })
        
    overall_attendance_percent = round((global_present / global_total * 100), 2) if global_total > 0 else 0
    
    # 3. ACADEMIC PERFORMANCE
    # Overall pass percentage (students with passing grades)
    total_grades = db.query(Grade).count()
    passing_grades = db.query(Grade).filter(
        Grade.marks_obtained >= 50
    ).count()
    overall_pass_percent = round((passing_grades / total_grades * 100), 2) if total_grades > 0 else 0
    
    # Pass percentage by department
    performance_by_dept = []
    for dept in departments:
        dept_students = db.query(Student).filter(
            Student.department_id == dept.id,
            Student.is_active == True
        ).all()
        student_ids = [s.id for s in dept_students]
        
        if student_ids:
            dept_grades = db.query(Grade).filter(Grade.student_id.in_(student_ids)).count()
            dept_passing = db.query(Grade).filter(
                Grade.student_id.in_(student_ids),
                Grade.marks_obtained >= 50
            ).count()
            dept_pass_percent = round((dept_passing / dept_grades * 100), 2) if dept_grades > 0 else 0
        else:
            dept_pass_percent = 0
            
        performance_by_dept.append({
            "department_name": dept.name,
            "department_code": dept.code,
            "pass_percent": dept_pass_percent
        })
    
    # 4. PENDING REQUESTS
    # All pending leave requests (student + faculty)
    pending_student_leaves = db.query(StudentLeaveRequest).filter(
        StudentLeaveRequest.status.in_([
            StudentLeaveStatus.PENDING_MENTOR,
            StudentLeaveStatus.PENDING_CLASS_ADVISOR,
            StudentLeaveStatus.PENDING_HOD
        ])
    ).count()
    
    pending_faculty_leaves = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.status.in_([
            LeaveStatus.PENDING_SUBSTITUTE,
            LeaveStatus.PENDING_HOD,
            LeaveStatus.PENDING_DEAN,
            LeaveStatus.PENDING_OM
        ])
    ).count()
    
    total_pending_leaves = pending_student_leaves + pending_faculty_leaves
    
    # Student complaints/discipline records needing attention
    seven_days_ago = date.today() - timedelta(days=7)
    recent_discipline_count = db.query(DisciplineRecord).filter(
        DisciplineRecord.incident_date >= seven_days_ago
    ).count()
    
    # 5. RECENT ALERTS (Last 10 notifications/updates)
    
    # Recent discipline incidents
    recent_discipline = db.query(DisciplineRecord).filter(
        DisciplineRecord.incident_date >= seven_days_ago
    ).order_by(DisciplineRecord.created_at.desc()).limit(5).all()
    
    # Recent faculty leaves
    recent_leaves = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.status.in_([
            LeaveStatus.PENDING_SUBSTITUTE,
            LeaveStatus.PENDING_HOD,
            LeaveStatus.PENDING_DEAN,
            LeaveStatus.PENDING_OM
        ])
    ).order_by(FacultyLeaveRequest.created_at.desc()).limit(5).all()
    
    # Recent student leaves
    recent_student_leaves = db.query(StudentLeaveRequest).filter(
        StudentLeaveRequest.status.in_([
            StudentLeaveStatus.PENDING_MENTOR,
            StudentLeaveStatus.PENDING_CLASS_ADVISOR,
            StudentLeaveStatus.PENDING_HOD
        ])
    ).order_by(StudentLeaveRequest.created_at.desc()).limit(5).all()
    
    # Compile recent alerts
    recent_alerts = []
    
    for disc in recent_discipline:
        recent_alerts.append({
            "type": "discipline",
            "message": f"Discipline incident: {disc.incident_type.value}",
            "student_name": f"{disc.student.first_name} {disc.student.last_name}" if disc.student else "Unknown",
            "timestamp": disc.created_at.isoformat(),
            "severity": "high"
        })
    
    for leave in recent_leaves:
        recent_alerts.append({
            "type": "leave",
            "message": f"Faculty leave request pending",
            "faculty_name": f"{leave.faculty.first_name} {leave.faculty.last_name}" if leave.faculty else "Unknown",
            "timestamp": leave.created_at.isoformat(),
            "severity": "medium"
        })
    
    for leave in recent_student_leaves:
        recent_alerts.append({
            "type": "leave",
            "message": f"Student leave request pending",
            "student_name": f"{leave.student.first_name} {leave.student.last_name}" if leave.student else "Unknown",
            "timestamp": leave.created_at.isoformat(),
            "severity": "medium"
        })
    
    # Sort alerts by timestamp, newest first
    recent_alerts.sort(key=lambda x: x["timestamp"], reverse=True)
    recent_alerts = recent_alerts[:10]  # Limit to 10 most recent
    
    return {
        # Top Numbers
        "total_students": total_students,
        "total_faculty": total_faculty,
        "total_departments": total_departments,
        "active_courses": active_courses,
        
        # Attendance Overview
        "overall_attendance_percent": overall_attendance_percent,
        "attendance_by_department": attendance_by_dept,
        
        # Academic Performance
        "overall_pass_percent": overall_pass_percent,
        "performance_by_department": performance_by_dept,
        
        # Pending Requests
        "pending_leave_requests": total_pending_leaves,
        "pending_complaints": recent_discipline_count,
        "total_pending": total_pending_leaves + recent_discipline_count,
        
        # Recent Alerts
        "recent_alerts": recent_alerts,
        
        # New Detailed Analytics
        "monthly_attendance_trend": monthly_attendance_trend,
        
        # Metadata
        "last_updated": datetime.now().isoformat()
    }

@router.get("/student/stats")
def get_student_dashboard_stats(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
) -> Dict[str, Any]:
    """
    Get dashboard statistics for student users
    """
    if current_user.role != "student":
        raise HTTPException(status_code=403, detail="Access denied")
    
    # Get student profile
    student = db.query(Student).filter(Student.user_id == current_user.id).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student profile not found")
    
    # Course enrollments
    from app.models.academic import Enrollment
    enrolled_courses = db.query(Enrollment).filter(
        Enrollment.student_id == student.id
    ).count()
    
    # My leave requests
    total_leaves = db.query(StudentLeaveRequest).filter(
        StudentLeaveRequest.student_id == student.id
    ).count()
    
    pending_leaves = db.query(StudentLeaveRequest).filter(
        StudentLeaveRequest.student_id == student.id,
        StudentLeaveRequest.status.in_([
            StudentLeaveStatus.PENDING_MENTOR,
            StudentLeaveStatus.PENDING_CLASS_ADVISOR,
            StudentLeaveStatus.PENDING_HOD
        ])
    ).count()
    
    # My gate passes
    total_gate_passes = db.query(GatePass).filter(
        GatePass.student_id == student.id,
        GatePass.is_deleted_by_student == False
    ).count()
    
    pending_gate_passes = db.query(GatePass).filter(
        GatePass.student_id == student.id,
        GatePass.status.in_([
            GatePassStatus.PENDING_MENTOR,
            GatePassStatus.PENDING_HOD,
            GatePassStatus.PENDING_OM
        ]),
        GatePass.is_deleted_by_student == False
    ).count()
    
    # Discipline records
    discipline_count = db.query(DisciplineRecord).filter(
        DisciplineRecord.student_id == student.id
    ).count()
    
    return {
        "enrolled_courses": enrolled_courses,
        "current_semester": student.current_semester,
        "current_year": student.current_year,
        "batch": student.batch,
        "total_leave_requests": total_leaves,
        "pending_leaves": pending_leaves,
        "total_gate_passes": total_gate_passes,
        "pending_gate_passes": pending_gate_passes,
        "discipline_records": discipline_count,
        "department": student.department.name if student.department else "N/A",
        "last_updated": datetime.now().isoformat()
    }


@router.get("/om/analytics")
def get_om_analytics(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
) -> Dict[str, Any]:
    """
    Get comprehensive dashboard statistics for Dean users (view-only)
    Similar to authority dashboard but specifically for Dean role
    """
    if current_user.role != "authority":
        raise HTTPException(status_code=403, detail="Access denied")
    
    # Verify user is a Dean
    authority = db.query(Authority).filter(Authority.user_id == current_user.id).first()
    if not authority or False:
        raise HTTPException(status_code=403, detail="Access denied")
    
    from datetime import timedelta
    from app.models.academic import Course, Enrollment
    from app.models.attendance import Attendance, FacultyAttendance
    from app.models.grade import Grade, GRADE_PASS_MARKS
    from app.models.retest import RetestMark
    from app.models.lms import Announcement
    from app.models.gatepass import GatePass, GatePassStatus
    from app.models.leave import FacultyLeaveRequest    
    today_date = date.today()
    
    # 1. TOP NUMBERS (Stat Cards)
    total_students = db.query(Student).filter(Student.is_active == True).count()
    total_faculty = db.query(Faculty).filter(Faculty.is_active == True).count()
    total_departments = db.query(Department).count()
    
    # Active courses (courses with enrollments in current semester)
    active_courses = db.query(Course).filter(Course.is_active == True).count()
    
    # 2. ATTENDANCE OVERVIEW
    # Attendance by department and Overall Attendance calculation
    attendance_by_dept = []
    departments = db.query(Department).all()
    
    global_total = 0
    global_present = 0
    
    from app.core.utils import get_sem_start_date
    
    for dept in departments:
        # Students
        dept_students = db.query(Student).filter(
            Student.department_id == dept.id,
            Student.is_active == True
        ).all()
        student_ids = [s.id for s in dept_students]
        total_dept_students = len(student_ids)
        
        if student_ids:
            sem_start_date = get_sem_start_date(dept.id, db)
            dept_total = db.query(Attendance).filter(
                Attendance.student_id.in_(student_ids),
                Attendance.date >= sem_start_date
            ).count()
            dept_present = db.query(Attendance).filter(
                Attendance.student_id.in_(student_ids),
                Attendance.status == "present",
                Attendance.date >= sem_start_date
            ).count()
            dept_percent = round((dept_present / dept_total * 100), 2) if dept_total > 0 else 0
            
            # Today's Student Attendance
            student_present_today = db.query(Attendance.student_id).filter(
                Attendance.student_id.in_(student_ids),
                Attendance.date == today_date,
                Attendance.status == "present"
            ).distinct().count()
            student_absent_today = total_dept_students - student_present_today
            
            # Gender-wise Today
            boys = [s for s in dept_students if s.gender and s.gender.lower() in ["male", "m", "boy"]]
            girls = [s for s in dept_students if s.gender and s.gender.lower() in ["female", "f", "girl"]]
            
            boys_ids = [s.id for s in boys]
            girls_ids = [s.id for s in girls]
            
            boys_present = db.query(Attendance.student_id).filter(
                Attendance.student_id.in_(boys_ids),
                Attendance.date == today_date,
                Attendance.status == "present"
            ).distinct().count() if boys_ids else 0
            
            girls_present = db.query(Attendance.student_id).filter(
                Attendance.student_id.in_(girls_ids),
                Attendance.date == today_date,
                Attendance.status == "present"
            ).distinct().count() if girls_ids else 0
            
            boys_percent = round((boys_present / len(boys_ids)) * 100, 2) if boys_ids else 0
            girls_percent = round((girls_present / len(girls_ids)) * 100, 2) if girls_ids else 0
            
            global_total += dept_total
            global_present += dept_present
        else:
            dept_percent = 0
            student_present_today = 0
            student_absent_today = 0
            boys_percent = 0
            girls_percent = 0
            
        # Faculty
        dept_faculty = db.query(Faculty).filter(
            Faculty.department_id == dept.id,
            Faculty.is_active == True
        ).all()
        faculty_ids = [f.id for f in dept_faculty]
        total_dept_faculty = len(faculty_ids)
        
        if faculty_ids:
            # Faculty are considered absent only if they have an approved leave request for today
            faculty_absent_today = db.query(FacultyLeaveRequest).filter(
                FacultyLeaveRequest.faculty_id.in_(faculty_ids),
                FacultyLeaveRequest.status == "approved",
                FacultyLeaveRequest.from_date <= today_date,
                FacultyLeaveRequest.to_date >= today_date
            ).count()
            
            faculty_present_today = total_dept_faculty - faculty_absent_today
        else:
            faculty_present_today = 0
            faculty_absent_today = 0
            
        attendance_by_dept.append({
            "department_name": dept.name,
            "department_code": dept.code,
            "attendance_percent": dept_percent,
            "student_present_today": student_present_today,
            "student_absent_today": student_absent_today,
            "faculty_present_today": faculty_present_today,
            "faculty_absent_today": faculty_absent_today,
            "boys_percent": boys_percent,
            "girls_percent": girls_percent
        })
        
    overall_attendance_percent = round((global_present / global_total * 100), 2) if global_total > 0 else 0
    
    # 3. ACADEMIC PERFORMANCE
    performance_by_dept = []
    
    global_total_grades = 0
    global_passing_grades = 0
    
    for dept in departments:
        dept_data = {
            "department_name": dept.name,
            "department_code": dept.code,
            "pass_percent": 0.0,
            "years": []
        }
        
        dept_students = db.query(Student).filter(
            Student.department_id == dept.id,
            Student.is_active == True
        ).all()
        
        years = {}
        for s in dept_students:
            y = s.current_year
            if not y:
                continue
            if y not in years:
                years[y] = {"year": y, "pass": 0, "total": 0, "sections": {}}
                
            sec = s.section.name if s.section else "Unknown"
            if sec not in years[y]["sections"]:
                years[y]["sections"][sec] = {"section_name": sec, "pass": 0, "total": 0}
                
        student_ids = [s.id for s in dept_students]
        if student_ids:
            # Pre-fetch grades and retests for efficiency
            grades = db.query(Grade).filter(
                Grade.student_id.in_(student_ids),
                Grade.marks_obtained.isnot(None)
            ).all()
            
            grade_ids = [g.id for g in grades]
            retests = db.query(RetestMark).filter(RetestMark.grade_id.in_(grade_ids)).all() if grade_ids else []
            retest_map = {r.grade_id: r.marks_obtained for r in retests}
            
            student_map = {s.id: {"year": s.current_year, "section": s.section.name if s.section else "Unknown"} for s in dept_students}
            
            dept_total = 0
            dept_pass = 0
            
            for g in grades:
                y = student_map[g.student_id]["year"]
                sec = student_map[g.student_id]["section"]
                
                if not y:
                    continue
                    
                threshold = GRADE_PASS_MARKS.get(g.grade_type, 50)
                
                # Check retest first
                mark = g.marks_obtained
                if g.id in retest_map and retest_map[g.id] is not None:
                    mark = retest_map[g.id]
                    
                is_pass = 1 if mark is not None and mark >= threshold else 0
                
                dept_total += 1
                dept_pass += is_pass
                years[y]["total"] += 1
                years[y]["pass"] += is_pass
                years[y]["sections"][sec]["total"] += 1
                years[y]["sections"][sec]["pass"] += is_pass
                
            global_total_grades += dept_total
            global_passing_grades += dept_pass
            
            dept_data["pass_percent"] = round((dept_pass / dept_total * 100), 2) if dept_total > 0 else 0
            
            for y_key, y_data in years.items():
                year_obj = {
                    "year": y_key,
                    "pass_percent": round((y_data["pass"] / y_data["total"] * 100), 2) if y_data["total"] > 0 else 0,
                    "sections": []
                }
                for sec_key, sec_data in y_data["sections"].items():
                    year_obj["sections"].append({
                        "section_name": sec_key,
                        "pass_percent": round((sec_data["pass"] / sec_data["total"] * 100), 2) if sec_data["total"] > 0 else 0
                    })
                year_obj["sections"].sort(key=lambda x: x["section_name"])
                dept_data["years"].append(year_obj)
                
            dept_data["years"].sort(key=lambda x: x["year"])
            
        performance_by_dept.append(dept_data)
        
    overall_pass_percent = round((global_passing_grades / global_total_grades * 100), 2) if global_total_grades > 0 else 0
    
    # 4. PENDING REQUESTS
    # Faculty leave requests pending Dean approval
    pending_faculty_leaves = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.status == LeaveStatus.PENDING_DEAN
    ).count()
    
    # Gatepasses pending Dean approval (Assuming Dean sees HOD or OM level depending on the flow, but let's query all pending for simplicity)
    # If the Dean acts as an authority for gatepasses, maybe they approve them? The OM approves them usually. Let's return the count anyway if the Dean needs to see them.
    pending_gate_passes = db.query(GatePass).filter(
        GatePass.status.in_([GatePassStatus.PENDING_HOD, GatePassStatus.PENDING_OM]),
        GatePass.is_deleted_by_student == False
    ).count()
    
    # Student complaints/discipline records needing attention
    today_discipline_count = db.query(DisciplineRecord).filter(
        func.date(DisciplineRecord.incident_date) == date.today()
    ).count()
    
    total_pending = pending_faculty_leaves + pending_gate_passes + today_discipline_count
    
    # 5. RECENT ALERTS (Last 10 notifications/updates)
    seven_days_ago = date.today() - timedelta(days=7)
    
    # Recent discipline incidents
    recent_discipline = db.query(DisciplineRecord).filter(
        DisciplineRecord.incident_date >= seven_days_ago
    ).order_by(DisciplineRecord.created_at.desc()).limit(5).all()
    
    # Recent faculty leaves pending Dean approval
    recent_leaves = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.status == LeaveStatus.PENDING_DEAN
    ).order_by(FacultyLeaveRequest.created_at.desc()).limit(5).all()
    
    # Compile recent alerts
    recent_alerts = []
    
    for disc in recent_discipline:
        recent_alerts.append({
            "type": "discipline",
            "message": f"Discipline incident: {disc.incident_type.value}",
            "student_name": f"{disc.student.first_name} {disc.student.last_name}" if disc.student else "Unknown",
            "timestamp": disc.created_at.isoformat(),
            "severity": "high"
        })
    
    for leave in recent_leaves:
        recent_alerts.append({
            "type": "leave",
            "message": f"Faculty leave request pending Dean approval",
            "faculty_name": f"{leave.faculty.first_name} {leave.faculty.last_name}" if leave.faculty else "Unknown",
            "timestamp": leave.created_at.isoformat(),
            "severity": "medium"
        })
    
    # Sort alerts by timestamp, newest first
    recent_alerts.sort(key=lambda x: x["timestamp"], reverse=True)
    recent_alerts = recent_alerts[:10]  # Limit to 10 most recent
    
    # 6. LATE ARRIVALS TREND (Last 30 Days)
    from app.models.late import LateRecord
    from collections import defaultdict
    thirty_days_ago = today_date - timedelta(days=30)
    
    late_entries = db.query(LateRecord).filter(
        LateRecord.date >= thirty_days_ago,
        LateRecord.date <= today_date
    ).all()
        
    # 7. STUDENT DEMOGRAPHICS
    all_active_students = db.query(Student).filter(Student.is_active == True).all()
    student_map = {s.id: s for s in all_active_students}
    
    demographics_raw = {"ALL": {"hostel": 0, "day_scholar": 0, "bus": 0, "own": 0}}
    for dept in departments:
        demographics_raw[dept.code] = {"hostel": 0, "day_scholar": 0, "bus": 0, "own": 0}
        
    for s in all_active_students:
        if s.accommodation == "Hostel":
            demographics_raw["ALL"]["hostel"] += 1
            if s.department: demographics_raw[s.department.code]["hostel"] += 1
        elif s.accommodation == "Day Scholar":
            demographics_raw["ALL"]["day_scholar"] += 1
            if s.department: demographics_raw[s.department.code]["day_scholar"] += 1
            
        if s.transportation == "BUS":
            demographics_raw["ALL"]["bus"] += 1
            if s.department: demographics_raw[s.department.code]["bus"] += 1
        elif s.transportation == "OWN":
            demographics_raw["ALL"]["own"] += 1
            if s.department: demographics_raw[s.department.code]["own"] += 1
            
    demographics = {}
    for key, data in demographics_raw.items():
        demographics[key] = {
            "accommodation": [
                {"name": "Hostel", "value": data["hostel"]},
                {"name": "Day Scholar", "value": data["day_scholar"]}
            ],
            "transportation": [
                {"name": "College Bus", "value": data["bus"]},
                {"name": "Own Transport", "value": data["own"]}
            ]
        }
        
    # 8. MONTHLY ATTENDANCE TREND
    
    all_active_faculty = db.query(Faculty).filter(Faculty.is_active == True).all()
    faculty_map = {f.id: f for f in all_active_faculty}
    
    student_attendance_records = db.query(Attendance).filter(
        Attendance.date >= thirty_days_ago,
        Attendance.date <= today_date
    ).all()
    
    faculty_leave_records = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.status == "approved",
        FacultyLeaveRequest.to_date >= thirty_days_ago,
        FacultyLeaveRequest.from_date <= today_date
    ).all()
    
    monthly_attendance_trend = {"ALL": []}
    late_trend = {"ALL": []}
    for dept in departments:
        monthly_attendance_trend[dept.code] = []
        late_trend[dept.code] = []
        
    for i in range(31):
        d_date = thirty_days_ago + timedelta(days=i)
        d_str = d_date.isoformat()
        
        stats_for_day = {"ALL": {"boys_total": 0, "boys_present": 0, "girls_total": 0, "girls_present": 0, "boys_late": 0, "girls_late": 0, "faculty_total": len(all_active_faculty), "faculty_absent": 0}}
        for dept in departments:
            stats_for_day[dept.code] = {"boys_total": 0, "boys_present": 0, "girls_total": 0, "girls_present": 0, "boys_late": 0, "girls_late": 0, "faculty_total": sum(1 for f in all_active_faculty if f.department_id == dept.id), "faculty_absent": 0}
            
        for s in all_active_students:
            is_boy = s.gender and s.gender.strip().lower() in ['m', 'male', 'boy']
            is_girl = s.gender and s.gender.strip().lower() in ['f', 'female', 'girl']
            
            if is_boy:
                stats_for_day["ALL"]["boys_total"] += 1
                if s.department:
                    stats_for_day[s.department.code]["boys_total"] += 1
            elif is_girl:
                stats_for_day["ALL"]["girls_total"] += 1
                if s.department:
                    stats_for_day[s.department.code]["girls_total"] += 1
                
        seen_student_attendance = set()
        for att in student_attendance_records:
            if att.date == d_date and att.status == "present":
                if (att.student_id, d_date) not in seen_student_attendance:
                    seen_student_attendance.add((att.student_id, d_date))
                    s = student_map.get(att.student_id)
                    if s:
                        is_boy = s.gender and s.gender.strip().lower() in ['m', 'male', 'boy']
                        is_girl = s.gender and s.gender.strip().lower() in ['f', 'female', 'girl']
                        
                        if is_boy:
                            stats_for_day["ALL"]["boys_present"] += 1
                            if s.department:
                                stats_for_day[s.department.code]["boys_present"] += 1
                        elif is_girl:
                            stats_for_day["ALL"]["girls_present"] += 1
                            if s.department:
                                stats_for_day[s.department.code]["girls_present"] += 1
                            
        seen_faculty_absent = set()
        
        for entry in late_entries:
            if entry.date == d_date:
                s = student_map.get(entry.student_id)
                if s:
                    is_boy = s.gender and s.gender.strip().lower() in ['m', 'male', 'boy']
                    is_girl = s.gender and s.gender.strip().lower() in ['f', 'female', 'girl']
                    
                    if is_boy:
                        stats_for_day["ALL"]["boys_late"] += 1
                        if s.department:
                            stats_for_day[s.department.code]["boys_late"] += 1
                    elif is_girl:
                        stats_for_day["ALL"]["girls_late"] += 1
                        if s.department:
                            stats_for_day[s.department.code]["girls_late"] += 1
                            
        for leave in faculty_leave_records:
            if leave.from_date <= d_date <= leave.to_date:
                if (leave.faculty_id, d_date) not in seen_faculty_absent:
                    seen_faculty_absent.add((leave.faculty_id, d_date))
                    f = faculty_map.get(leave.faculty_id)
                    if f:
                        stats_for_day["ALL"]["faculty_absent"] += 1
                        if f.department:
                            stats_for_day[f.department.code]["faculty_absent"] += 1
                            
        for key in stats_for_day:
            st = stats_for_day[key]
            boys_pct = round(st["boys_present"] / st["boys_total"] * 100, 2) if st["boys_total"] > 0 else 0
            girls_pct = round(st["girls_present"] / st["girls_total"] * 100, 2) if st["girls_total"] > 0 else 0
            fac_pct = round((st["faculty_total"] - st["faculty_absent"]) / st["faculty_total"] * 100, 2) if st["faculty_total"] > 0 else 0
            
            monthly_attendance_trend[key].append({
                "date": d_str,
                "boys_percent": boys_pct,
                "girls_percent": girls_pct,
                "boys_present": st["boys_present"],
                "girls_present": st["girls_present"],
                "boys_total": st["boys_total"],
                "girls_total": st["girls_total"],
                "faculty_present_percent": fac_pct
            })
            
            late_trend[key].append({
                "date": d_str,
                "boys_late": st["boys_late"],
                "girls_late": st["girls_late"]
            })
    
    return {
        # Top Numbers
        "total_students": total_students,
        "total_faculty": total_faculty,
        "total_departments": total_departments,
        "active_courses": active_courses,
        
        # Attendance Overview
        "overall_attendance_percent": overall_attendance_percent,
        "attendance_by_department": attendance_by_dept,
        
        # Academic Performance
        "overall_pass_percent": overall_pass_percent,
        "academic_performance": performance_by_dept,
        
        # Pending Requests
        "pending_faculty_leaves": pending_faculty_leaves,
        "pending_gate_passes": pending_gate_passes,
        "pending_complaints": today_discipline_count,
        "total_pending": total_pending,
        
        # Recent Alerts
        "recent_alerts": recent_alerts,
        
        # New Detailed Analytics
        "monthly_attendance_trend": monthly_attendance_trend,
        "late_trend": late_trend,
        "demographics": demographics,
        
        # Announcements
        "announcements": [
            {
                "id": a.id,
                "title": a.title,
                "content": a.content,
                "category": a.category,
                "created_at": a.created_at.isoformat() if a.created_at else None,
                "posted_by": f"{a.posted_by.first_name} {a.posted_by.last_name}" if a.posted_by else "Admin"
            } for a in db.query(Announcement).order_by(Announcement.created_at.desc()).limit(5).all()
        ],
        
        # Metadata
        "last_updated": datetime.now().isoformat()
    }

