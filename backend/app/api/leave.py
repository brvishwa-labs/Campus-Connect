from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime

from app.core.database import get_db
from app.core.security import get_current_active_user as get_current_user
from app.models.user import User, UserRole
from app.models.faculty import Faculty
from app.models.leave import FacultyLeaveRequest, FacultyDutyArrangement, FacultyLeaveBalance, LeaveStatus, ArrangementStatus
from app.models.academic import CourseAssignment, Course, Section
from app.models.lms import TimetableSlot, DayOfWeek
from app.models.department import Department
from app.schemas.leave import FacultyLeaveRequestCreate, FacultyLeaveRequestResponse, FacultyDutyArrangementResponse, FacultyLeaveBalanceResponse, FacultyLeaveBalanceUpdate

router = APIRouter()

@router.get("/leave-preparation-data")
def get_leave_preparation_data(
    from_date: str,
    to_date: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get all data needed for faculty to prepare leave request:
    1. Their timetable slots for the leave period
    2. All other faculty who can substitute
    3. Class advisor responsibilities if any
    """
    if current_user.role != UserRole.FACULTY:
        raise HTTPException(status_code=403, detail="Only faculty can access this")
        
    faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
    if not faculty:
        raise HTTPException(status_code=404, detail="Faculty profile not found")
    
    from datetime import datetime, timedelta
    
    # Parse dates
    start_date = datetime.strptime(from_date, "%Y-%m-%d").date()
    end_date = datetime.strptime(to_date, "%Y-%m-%d").date()
    
    # Get day names for the leave period
    day_names = []
    current = start_date
    while current <= end_date:
        day_name = current.strftime("%a").lower()[:3]  # mon, tue, wed, etc.
        if day_name not in day_names and day_name in ['mon', 'tue', 'wed', 'thu', 'fri', 'sat']:
            day_names.append(day_name)
        current += timedelta(days=1)
    
    # Get faculty's timetable slots for those days
    my_assignments = db.query(CourseAssignment).filter(
        CourseAssignment.faculty_id == faculty.id,
        CourseAssignment.is_active == True
    ).all()
    
    assignment_ids = [a.id for a in my_assignments]
    
    timetable_slots = db.query(TimetableSlot).filter(
        TimetableSlot.course_assignment_id.in_(assignment_ids),
        TimetableSlot.day.in_(day_names)
    ).all()
    
    # Build timetable data with course and section info
    my_schedule = []
    for slot in timetable_slots:
        assignment = db.query(CourseAssignment).filter(CourseAssignment.id == slot.course_assignment_id).first()
        if assignment:
            course = db.query(Course).filter(Course.id == assignment.course_id).first()
            section = db.query(Section).filter(Section.id == assignment.section_id).first()
            department = db.query(Department).filter(Department.id == section.department_id).first() if section else None
            
            if course and section:
                my_schedule.append({
                    "slot_id": slot.id,
                    "assignment_id": assignment.id,
                    "day": slot.day,
                    "start_time": slot.start_time.strftime("%H:%M") if slot.start_time else "",
                    "end_time": slot.end_time.strftime("%H:%M") if slot.end_time else "",
                    "room": slot.room,
                    "course_code": course.code,
                    "course_name": course.name,
                    "course_short_name": course.short_name or course.code,
                    "section_name": section.name,
                    "year": section.year,
                    "department_short": department.code if department else "DEPT",
                    "class_section": f"{department.code if department else 'Dept'} Year-{section.year} {section.name}",
                    "period_display": f"{slot.start_time.strftime('%H:%M') if slot.start_time else ''} - {slot.end_time.strftime('%H:%M') if slot.end_time else ''}",
                    "_section_id": section.id,
                    "_start_time": slot.start_time,
                    "_end_time": slot.end_time
                })
    
    # Get all other active faculty (excluding current faculty)
    all_other_faculty = db.query(Faculty).filter(
        Faculty.id != faculty.id,
        Faculty.is_active == True
    ).all()
    
    faculty_list = []
    for f in all_other_faculty:
        dept = db.query(Department).filter(Department.id == f.department_id).first()
        faculty_list.append({
            "id": f.id,
            "name": f"{f.first_name} {f.last_name}",
            "designation": f.designation,
            "department": dept.name if dept else "N/A",
            "department_id": f.department_id  # Add department_id for filtering
        })
        
    # Pre-fetch data for substitute filtering
    other_faculty_ids = [f["id"] for f in faculty_list]
    
    # Get only active course assignments to ensure we only suggest faculty currently teaching this class
    all_assignments = db.query(CourseAssignment).filter(
        CourseAssignment.faculty_id.in_(other_faculty_ids),
        CourseAssignment.is_active == True
    ).all()
    
    # Build faculty_sections mapping (include all assignments, active or not) and course mapping
    faculty_sections = {}
    faculty_section_courses = {}
    for a in all_assignments:
        if a.faculty_id not in faculty_sections:
            faculty_sections[a.faculty_id] = set()
        faculty_sections[a.faculty_id].add(a.section_id)
        
        # Look up course code
        course = db.query(Course).filter(Course.id == a.course_id).first()
        if course:
            key = (a.faculty_id, a.section_id)
            if key not in faculty_section_courses:
                faculty_section_courses[key] = []
            faculty_section_courses[key].append(course.code)
    
    # Filter to only active assignments for timetable checking
    active_assignments = [a for a in all_assignments if a.is_active]
        
    assignment_to_faculty = {a.id: a.faculty_id for a in active_assignments}
    all_slots = db.query(TimetableSlot).filter(
        TimetableSlot.course_assignment_id.in_(list(assignment_to_faculty.keys())),
        TimetableSlot.day.in_(day_names)
    ).all()
    
    # Build faculty_busy_slots
    faculty_busy_slots = {}
    for s in all_slots:
        fid = assignment_to_faculty[s.course_assignment_id]
        if fid not in faculty_busy_slots:
            faculty_busy_slots[fid] = []
        faculty_busy_slots[fid].append(s)

    # Compute available_substitutes for my_schedule
    for item in my_schedule:
        item["available_substitutes"] = []
        target_section_id = item.get("_section_id")
        for f in faculty_list:
            fid = f["id"]
            
            # FILTER: Only include faculty who teach this specific section
            teaches_this_section = target_section_id in faculty_sections.get(fid, set())
            if not teaches_this_section:
                continue  # Skip faculty who don't teach this section
            
            # Check if faculty is busy at this time
            is_busy = False
            if fid in faculty_busy_slots:
                for bs in faculty_busy_slots[fid]:
                    if bs.day == item["day"]:
                        if bs.start_time and bs.end_time and item.get("_start_time") and item.get("_end_time"):
                            if bs.start_time < item["_end_time"] and bs.end_time > item["_start_time"]:
                                is_busy = True
                                break
            
            if not is_busy:
                sub_info = dict(f)
                sub_info["teaches_this_class"] = True  # All filtered faculty teach this section
                
                # Retrieve course code
                courses = faculty_section_courses.get((fid, target_section_id), [])
                sub_info["course_code"] = courses[0] if courses else ""
                
                item["available_substitutes"].append(sub_info)
                
        # Sort by name if needed
        item["available_substitutes"].sort(key=lambda x: x["name"])
        
    # Remove internal fields
    for item in my_schedule:
        item["section_id"] = item.pop("_section_id", None)
        item.pop("_start_time", None)
        item.pop("_end_time", None)

    # ALWAYS automatically ask to appoint a faculty for department works
    all_subs = []
    for f in faculty_list:
        if f.get("department_id") == faculty.department_id:
            sub_info = dict(f)
            sub_info.pop("department_id", None)
            all_subs.append(sub_info)
        
    period_str = f"{start_date.strftime('%d-%b-%Y')} to {end_date.strftime('%d-%b-%Y')}" if start_date != end_date else start_date.strftime('%d-%b-%Y')
    dept_code = "DEPT"
    if faculty.department_id:
        dept = db.query(Department).filter(Department.id == faculty.department_id).first()
        if dept:
            dept_code = dept.code
            
    my_schedule.append({
        "slot_id": None,
        "assignment_id": None,
        "day": day_names[0] if day_names else "",
        "start_time": "",
        "end_time": "",
        "room": "",
        "course_code": "Department Works",
        "course_name": "Department Works",
        "course_short_name": "DW",
        "section_name": "",
        "year": "",
        "department_short": dept_code,
        "class_section": "Department Works",
        "period_display": period_str,
        "available_substitutes": all_subs
    })

    # Check if current faculty is a class advisor
    advised_sections = db.query(Section).filter(
        Section.class_advisor_id == faculty.id,
        Section.is_active == True
    ).all()
    
    class_advisor_duties = []
    for sec in advised_sections:
        dept = db.query(Department).filter(Department.id == sec.department_id).first()
        
        # Compute available_substitutes for class advisor
        # FILTER: Only faculty from the same department
        available_subs = []
        for f in faculty_list:
            # Only include faculty from the same department as the section
            if f.get("department_id") != sec.department_id:
                continue
            
            fid = f["id"]
            teaches_class = sec.id in faculty_sections.get(fid, set())
            sub_info = dict(f)
            sub_info["teaches_this_class"] = teaches_class
            
            # Retrieve course code
            courses = faculty_section_courses.get((fid, sec.id), [])
            sub_info["course_code"] = courses[0] if courses else ""
            
            # Remove department_id from response (internal use only)
            sub_info.pop("department_id", None)
            available_subs.append(sub_info)
        
        # Sort: those who teach the class first, then by name
        available_subs.sort(key=lambda x: (not x["teaches_this_class"], x["name"]))
        
        class_advisor_duties.append({
            "section_id": sec.id,
            "section_name": sec.name,
            "year": sec.year,
            "department": dept.name if dept else "N/A",
            "class_display": f"{dept.code if dept else 'Dept'} Year-{sec.year} {sec.name}",
            "duty_type": "Class Advisor",
            "available_substitutes": available_subs
        })
    
    # Filter available_faculty to only include those who teach the same sections
    # Get all section IDs that the requesting faculty teaches
    my_section_ids = set()
    
    # Re-fetch sections for the current faculty
    my_assignments = db.query(CourseAssignment).filter(
        CourseAssignment.faculty_id == faculty.id,
        CourseAssignment.is_active == True
    ).all()
    
    for assignment in my_assignments:
        my_section_ids.add(assignment.section_id)
    
    # Also add sections where faculty is class advisor
    for sec in advised_sections:
        my_section_ids.add(sec.id)
    
    # Filter faculty_list to only include those who teach at least one of my sections
    filtered_faculty_list = []
    for f in faculty_list:
        fid = f["id"]
        # Check if this faculty teaches any of my sections
        if fid in faculty_sections:
            common_sections = my_section_ids.intersection(faculty_sections[fid])
            if common_sections:
                f_copy = dict(f)
                f_copy["teaches_same_section"] = True
                
                # Retrieve course code
                first_common_section = list(common_sections)[0]
                courses = faculty_section_courses.get((fid, first_common_section), [])
                f_copy["course_code"] = courses[0] if courses else ""
                
                # Remove department_id before sending to frontend
                f_copy.pop("department_id", None)
                filtered_faculty_list.append(f_copy)
    
    # If filtered list is empty, fall back to all faculty (to avoid blocking the request)
    if not filtered_faculty_list:
        filtered_faculty_list = faculty_list
    
    return {
        "my_schedule": my_schedule,
        "available_faculty": filtered_faculty_list,
        "class_advisor_duties": class_advisor_duties,
        "total_periods_to_cover": len(my_schedule),
        "requires_class_advisor_substitute": len(class_advisor_duties) > 0
    }


@router.get("/faculty/{faculty_id}/active-courses")
def get_faculty_active_courses(
    faculty_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Return every active course/section this faculty member currently teaches.
    Used by the frontend to populate the Subject/Assignment dropdown once a
    substitute faculty is selected for a duty arrangement row.
    """
    target_faculty = db.query(Faculty).filter(Faculty.id == faculty_id).first()
    if not target_faculty:
        raise HTTPException(status_code=404, detail="Faculty not found")

    assignments = db.query(CourseAssignment).filter(
        CourseAssignment.faculty_id == faculty_id,
        CourseAssignment.is_active == True
    ).all()

    result = []
    for a in assignments:
        course = db.query(Course).filter(Course.id == a.course_id).first()
        section = db.query(Section).filter(Section.id == a.section_id).first()
        if not course or not section:
            continue
        department = db.query(Department).filter(Department.id == section.department_id).first()
        result.append({
            "assignment_id": a.id,
            "course_id": course.id,
            "course_code": course.code,
            "course_name": course.name,
            "section_id": section.id,
            "class_section": f"{department.code if department else 'Dept'} Year-{section.year} {section.name}"
        })

    return result


from pydantic import BaseModel
from typing import Optional, List

class CompensationRequest(BaseModel):
    to_date: str
    substitute_ids: List[Optional[int]]

@router.post("/calculate-compensations")
def calculate_compensations(
    req: CompensationRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    from datetime import datetime, timedelta
    from app.models.lms import TimetableSlot
    from app.models.academic import CourseAssignment
    
    try:
        end_date = datetime.strptime(req.to_date, "%Y-%m-%d").date()
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid to_date format. Use YYYY-MM-DD")
        
    WEEKDAY_MAP = {
        0: "mon",
        1: "tue",
        2: "wed",
        3: "thu",
        4: "fri",
        5: "sat",
        6: "sun"
    }
    
    unique_sub_ids = list(set([sid for sid in req.substitute_ids if sid]))
    sub_slots_map = {}
    
    for sub_id in unique_sub_ids:
        sub_assignments = db.query(CourseAssignment).filter(
            CourseAssignment.faculty_id == sub_id,
            CourseAssignment.is_active == True
        ).all()
        sub_assign_ids = [a.id for a in sub_assignments]
        
        slots = db.query(TimetableSlot).filter(
            TimetableSlot.course_assignment_id.in_(sub_assign_ids)
        ).all()
        
        found_slots = []
        current_date = end_date + timedelta(days=1)
        
        for _ in range(30):
            day_str = WEEKDAY_MAP.get(current_date.weekday())
            day_slots = [s for s in slots if (s.day.value.lower() if hasattr(s.day, 'value') else str(s.day).lower()) == day_str]
            day_slots.sort(key=lambda s: s.start_time if s.start_time else datetime.min.time())
            
            for ds in day_slots:
                start_str = ds.start_time.strftime('%I:%M %p') if ds.start_time else ""
                end_str = ds.end_time.strftime('%I:%M %p') if ds.end_time else ""
                found_slots.append({
                    "compensation_date": current_date.strftime("%Y-%m-%d"),
                    "compensation_period": f"{start_str} - {end_str}" if start_str and end_str else ""
                })
            current_date += timedelta(days=1)
            
        sub_slots_map[sub_id] = found_slots

    results = []
    sub_occurrence_counters = {}
    
    for sub_id in req.substitute_ids:
        if not sub_id:
            results.append({
                "substitute_faculty_id": None,
                "compensation_date": None,
                "compensation_period": None
            })
            continue
            
        idx = sub_occurrence_counters.get(sub_id, 0)
        sub_occurrence_counters[sub_id] = idx + 1
        
        sub_slots = sub_slots_map.get(sub_id, [])
        if idx < len(sub_slots):
            slot_info = sub_slots[idx]
            results.append({
                "substitute_faculty_id": sub_id,
                "compensation_date": slot_info["compensation_date"],
                "compensation_period": slot_info["compensation_period"]
            })
        else:
            results.append({
                "substitute_faculty_id": sub_id,
                "compensation_date": None,
                "compensation_period": None
            })
            
    return results

@router.get("/balances", response_model=FacultyLeaveBalanceResponse)
def get_leave_balances(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role != UserRole.FACULTY:
        raise HTTPException(status_code=403, detail="Only faculty can view leave balances")
    
    faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
    if not faculty:
        raise HTTPException(status_code=404, detail="Faculty profile not found")
        
    academic_year = "2023-2024" # Default for now
    balance = db.query(FacultyLeaveBalance).filter(
        FacultyLeaveBalance.faculty_id == faculty.id,
        FacultyLeaveBalance.academic_year == academic_year
    ).first()
    
    if not balance:
        # Create default balance
        balance = FacultyLeaveBalance(faculty_id=faculty.id, academic_year=academic_year)
        db.add(balance)
        db.commit()
        db.refresh(balance)
        
    import datetime
    today = datetime.date.today()
    
    # 1. Casual Leave used in current month
    start_of_month = datetime.date(today.year, today.month, 1)
    if today.month == 12:
        end_of_month = datetime.date(today.year + 1, 1, 1)
    else:
        end_of_month = datetime.date(today.year, today.month + 1, 1)
        
    monthly_casual_reqs = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.faculty_id == faculty.id,
        FacultyLeaveRequest.leave_type == "Casual Leave",
        FacultyLeaveRequest.status == LeaveStatus.APPROVED,
        FacultyLeaveRequest.from_date >= start_of_month,
        FacultyLeaveRequest.from_date < end_of_month
    ).all()
    casual_used_this_month = sum(r.duration_days for r in monthly_casual_reqs)
    
    # 2. Restricted Leave used in current semester (Jan-Jun or Jul-Dec)
    if today.month <= 6:
        start_of_sem = datetime.date(today.year, 1, 1)
        end_of_sem = datetime.date(today.year, 7, 1)
    else:
        start_of_sem = datetime.date(today.year, 7, 1)
        end_of_sem = datetime.date(today.year + 1, 1, 1)
        
    sem_restricted_reqs = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.faculty_id == faculty.id,
        FacultyLeaveRequest.leave_type == "Restricted Leave",
        FacultyLeaveRequest.status == LeaveStatus.APPROVED,
        FacultyLeaveRequest.from_date >= start_of_sem,
        FacultyLeaveRequest.from_date < end_of_sem
    ).all()
    restricted_used_this_sem = sum(r.duration_days for r in sem_restricted_reqs)
    # 3. Earned Leave total (accrued 1 per completed month since June)
    completed_months = today.month - 6 if today.month >= 6 else today.month + 6

    return {
        "id": balance.id,
        "faculty_id": balance.faculty_id,
        "academic_year": balance.academic_year,
        "casual_leaves_total": balance.casual_leaves_total,
        "casual_leaves_used": balance.casual_leaves_used,
        "restricted_leaves_total": balance.restricted_leaves_total,
        "restricted_leaves_used": balance.restricted_leaves_used,
        "sick_leaves_total": balance.sick_leaves_total,
        "sick_leaves_used": balance.sick_leaves_used,
        "earned_leaves_total": balance.earned_leaves_total,
        "earned_leaves_used": balance.earned_leaves_used,
        "vacation_leaves_total": balance.vacation_leaves_total,
        "vacation_leaves_used": balance.vacation_leaves_used,
        "compensation_leaves_total": balance.compensation_leaves_total,
        "compensation_leaves_used": balance.compensation_leaves_used,
        "academic_leaves_total": balance.academic_leaves_total,
        "academic_leaves_used": balance.academic_leaves_used
    }

@router.post("/request", response_model=FacultyLeaveRequestResponse)
def create_leave_request(
    request: FacultyLeaveRequestCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    import datetime
    if current_user.role != UserRole.FACULTY:
        raise HTTPException(status_code=403, detail="Only faculty can request leave")
        
    faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
    
    duration = (request.to_date - request.from_date).days + 1
    if duration <= 0:
        raise HTTPException(status_code=400, detail="Invalid date range")

    leave_type_lower = request.leave_type.lower()

    # Validate that arrangements are provided
    if leave_type_lower != "hour permission" and (not request.arrangements or len(request.arrangements) == 0):
        raise HTTPException(status_code=400, detail="At least one substitute arrangement must be provided")

    # Hour Permission Validation
    if leave_type_lower == "hour permission":
        if request.from_date != request.to_date:
            raise HTTPException(400, "Hour Permission must be requested for a single day")
        if not request.hour_permission_session or not request.hour_permission_period:
            raise HTTPException(400, "Start Time and End Time are required for Hour Permission")

        active_statuses = [LeaveStatus.APPROVED, LeaveStatus.PENDING_SUBSTITUTE, LeaveStatus.PENDING_HOD,
                            LeaveStatus.PENDING_DEAN, LeaveStatus.PENDING_OM, LeaveStatus.PENDING_PRINCIPAL]
        month_start = datetime.date(datetime.date.today().year, datetime.date.today().month, 1)
        month_end = (datetime.date(datetime.date.today().year + 1, 1, 1) if datetime.date.today().month == 12
                     else datetime.date(datetime.date.today().year, datetime.date.today().month + 1, 1))

        monthly_perms = db.query(FacultyLeaveRequest).filter(
            FacultyLeaveRequest.faculty_id == faculty.id,
            FacultyLeaveRequest.leave_type == "Hour Permission",
            FacultyLeaveRequest.status.in_(active_statuses),
            FacultyLeaveRequest.from_date >= month_start,
            FacultyLeaveRequest.from_date < month_end
        ).all()

        if len(monthly_perms) >= 3:
            raise HTTPException(400, "Only 3 Hour Permissions are allowed per month. Limit reached.")
        if any(r.from_date == request.from_date for r in monthly_perms):
            raise HTTPException(400, "Only one Hour Permission is allowed per day.")
            
    # On Duty Validation (Proof can be submitted after the OD period)
    # The requirement to submit proof at the time of application has been removed.

    # CHECK LEAVE BALANCE BEFORE CREATING REQUEST
    today = datetime.date.today()
    academic_year = "2023-2024"
    
    balance = db.query(FacultyLeaveBalance).filter(
        FacultyLeaveBalance.faculty_id == faculty.id,
        FacultyLeaveBalance.academic_year == academic_year
    ).first()
    
    if not balance:
        balance = FacultyLeaveBalance(faculty_id=faculty.id, academic_year=academic_year)
        db.add(balance)
        db.commit()
        db.refresh(balance)
    
    leave_type_lower = request.leave_type.lower()
    
    # Check Casual Leave (1 per month)
    if "casual" in leave_type_lower:
        start_of_month = datetime.date(today.year, today.month, 1)
        if today.month == 12:
            end_of_month = datetime.date(today.year + 1, 1, 1)
        else:
            end_of_month = datetime.date(today.year, today.month + 1, 1)
        
        monthly_casual_reqs = db.query(FacultyLeaveRequest).filter(
            FacultyLeaveRequest.faculty_id == faculty.id,
            FacultyLeaveRequest.leave_type == "Casual Leave",
            FacultyLeaveRequest.status.in_([LeaveStatus.APPROVED, LeaveStatus.PENDING_SUBSTITUTE, LeaveStatus.PENDING_HOD, LeaveStatus.PENDING_DEAN, LeaveStatus.PENDING_OM]),
            FacultyLeaveRequest.from_date >= start_of_month,
            FacultyLeaveRequest.from_date < end_of_month
        ).all()
        casual_used_this_month = sum(r.duration_days for r in monthly_casual_reqs)
        
        if casual_used_this_month + duration > 1:
            raise HTTPException(status_code=400, detail=f"Insufficient Casual Leave balance. You have already used {casual_used_this_month} day(s) this month. Only 1 day per month is allowed.")
    
    # Check Restricted Leave (1 per semester)
    elif "restricted" in leave_type_lower or "rh" in leave_type_lower:
        if today.month <= 6:
            start_of_sem = datetime.date(today.year, 1, 1)
            end_of_sem = datetime.date(today.year, 7, 1)
        else:
            start_of_sem = datetime.date(today.year, 7, 1)
            end_of_sem = datetime.date(today.year + 1, 1, 1)
        
        sem_restricted_reqs = db.query(FacultyLeaveRequest).filter(
            FacultyLeaveRequest.faculty_id == faculty.id,
            FacultyLeaveRequest.leave_type == "Restricted Leave",
            FacultyLeaveRequest.status.in_([LeaveStatus.APPROVED, LeaveStatus.PENDING_SUBSTITUTE, LeaveStatus.PENDING_HOD, LeaveStatus.PENDING_DEAN, LeaveStatus.PENDING_OM]),
            FacultyLeaveRequest.from_date >= start_of_sem,
            FacultyLeaveRequest.from_date < end_of_sem
        ).all()
        restricted_used_this_sem = sum(r.duration_days for r in sem_restricted_reqs)
        
        if restricted_used_this_sem + duration > 1:
            raise HTTPException(status_code=400, detail=f"Insufficient Restricted Leave balance. You have already used {restricted_used_this_sem} day(s) this semester. Only 1 day per semester is allowed.")
    
    # Check Earned Leave (accrued monthly)
    elif "earned" in leave_type_lower:
        months_elapsed = today.month - 6 + 1 if today.month >= 6 else today.month + 7
        earned_available = months_elapsed - balance.earned_leaves_used
        
        if duration > earned_available:
            raise HTTPException(status_code=400, detail=f"Insufficient Earned Leave balance. You have {earned_available} day(s) available (accrued: {months_elapsed}, used: {balance.earned_leaves_used}).")
    
    # Check other leave types
    elif "vacation" in leave_type_lower:
        vacation_available = balance.vacation_leaves_total - balance.vacation_leaves_used
        if duration > vacation_available:
            raise HTTPException(status_code=400, detail=f"Insufficient Vacation Leave balance. Available: {vacation_available} days.")
    
    elif "compensation" in leave_type_lower:
        comp_available = balance.compensation_leaves_total - balance.compensation_leaves_used
        if duration > comp_available:
            raise HTTPException(status_code=400, detail=f"Insufficient Compensation Leave balance. Available: {comp_available} days.")
    
    elif "sick" in leave_type_lower or "medical" in leave_type_lower:
        sick_available = balance.sick_leaves_total - balance.sick_leaves_used
        if duration > sick_available:
            raise HTTPException(status_code=400, detail=f"Insufficient Sick Leave balance. Available: {sick_available} days.")

    initial_status = LeaveStatus.PENDING_SUBSTITUTE
    if request.leave_type == "Compensation Leave":
        initial_status = LeaveStatus.PENDING_COMPENSATION_VERIFICATION

    # Create the request with appropriate initial status
    leave_req = FacultyLeaveRequest(
        faculty_id=faculty.id,
        leave_type=request.leave_type,
        from_date=request.from_date,
        to_date=request.to_date,
        duration_days=duration,
        reason=request.reason,
        attachment_url=request.attachment_url,
        compensation_verifier_id=request.compensation_verifier_id,
        compensation_purpose=request.compensation_purpose,
        hour_permission_session=request.hour_permission_session,
        hour_permission_period=request.hour_permission_period,
        proof_link=request.proof_link,
        status=initial_status
    )
    db.add(leave_req)
    db.flush() # Get ID
    
    # Create duty arrangements
    for arr in request.arrangements:
        duty = FacultyDutyArrangement(
            leave_request_id=leave_req.id,
            substitute_faculty_id=arr.substitute_faculty_id,
            subject=arr.subject,
            class_section=arr.class_section,
            section_id=arr.section_id,
            period=arr.period,
            day=arr.day,
            compensation_date=arr.compensation_date,
            compensation_period=arr.compensation_period,
            status=ArrangementStatus.PENDING
        )
        db.add(duty)
        
    db.commit()
    db.refresh(leave_req)
    
    return get_leave_request_detail(leave_req.id, db)

@router.put("/requests/{request_id}/withdraw")
def withdraw_leave_request(
    request_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role != UserRole.FACULTY:
        raise HTTPException(status_code=403, detail="Only faculty can withdraw their own requests")
        
    faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
    req = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.id == request_id, FacultyLeaveRequest.faculty_id == faculty.id).first()
    
    if not req:
        raise HTTPException(status_code=404, detail="Request not found or not owned by you")
        
    if req.status in [LeaveStatus.APPROVED, LeaveStatus.REJECTED]:
        raise HTTPException(status_code=400, detail="Cannot withdraw already processed requests")
    
    # Can withdraw any pending request (PENDING_SUBSTITUTE, PENDING_HOD, PENDING_DEAN, PENDING_OM)
    db.query(FacultyDutyArrangement).filter(FacultyDutyArrangement.leave_request_id == request_id).delete()
    db.delete(req)
    db.commit()
    return {"message": "Request withdrawn and deleted successfully"}

@router.put("/requests/{request_id}", response_model=FacultyLeaveRequestResponse)
def update_leave_request(
    request_id: int,
    request: FacultyLeaveRequestCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role != UserRole.FACULTY:
        raise HTTPException(status_code=403, detail="Access denied")
        
    faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
    leave_req = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.id == request_id, FacultyLeaveRequest.faculty_id == faculty.id).first()
    
    if not leave_req:
        raise HTTPException(status_code=404, detail="Request not found")
        
    if leave_req.status in [LeaveStatus.APPROVED, LeaveStatus.REJECTED]:
        raise HTTPException(status_code=400, detail="Processed requests cannot be modified")
        
    # Only allow edits if still in PENDING_SUBSTITUTE state
    if leave_req.status != LeaveStatus.PENDING_SUBSTITUTE:
        raise HTTPException(status_code=400, detail="Cannot modify request after substitute approval has started")
        
    duration = (request.to_date - request.from_date).days + 1
    if duration <= 0:
        raise HTTPException(status_code=400, detail="Invalid date range")
    
    # Validate that arrangements are provided
    if not request.arrangements or len(request.arrangements) == 0:
        raise HTTPException(status_code=400, detail="At least one substitute arrangement must be provided")
        
    leave_req.leave_type = request.leave_type
    leave_req.from_date = request.from_date
    leave_req.to_date = request.to_date
    leave_req.duration_days = duration
    leave_req.reason = request.reason
    leave_req.attachment_url = request.attachment_url
    leave_req.status = LeaveStatus.PENDING_SUBSTITUTE
    
    db.query(FacultyDutyArrangement).filter(FacultyDutyArrangement.leave_request_id == request_id).delete()
    
    for arr in request.arrangements:
        duty = FacultyDutyArrangement(
            leave_request_id=leave_req.id,
            substitute_faculty_id=arr.substitute_faculty_id,
            subject=arr.subject,
            class_section=arr.class_section,
            section_id=arr.section_id,
            period=arr.period,
            day=arr.day,
            compensation_date=arr.compensation_date,
            compensation_period=arr.compensation_period,
            status=ArrangementStatus.PENDING
        )
        db.add(duty)
        
    db.commit()
    db.refresh(leave_req)
    return get_leave_request_detail(leave_req.id, db)

@router.get("/my-requests", response_model=List[FacultyLeaveRequestResponse])
def get_my_leave_requests(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role != UserRole.FACULTY:
        raise HTTPException(status_code=403, detail="Access denied")
        
    faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
    
    requests = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.faculty_id == faculty.id).order_by(FacultyLeaveRequest.created_at.desc()).all()
    
    # Attach names
    for req in requests:
        req.faculty_name = f"{faculty.first_name} {faculty.last_name}"
        if getattr(req, "compensation_verifier_id", None):
            verifier = db.query(Faculty).filter(Faculty.id == req.compensation_verifier_id).first()
            req.compensation_verifier_name = f"{verifier.first_name} {verifier.last_name}" if verifier else "Unknown"
        for arr in req.arrangements:
            sub = db.query(Faculty).filter(Faculty.id == arr.substitute_faculty_id).first()
            arr.substitute_faculty_name = f"{sub.first_name} {sub.last_name}" if sub else "Unknown"
            
    return requests

@router.get("/requests", response_model=List[FacultyLeaveRequestResponse])
def get_all_leave_requests(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # Depending on role, filter requests
    if current_user.role not in [UserRole.HOD, UserRole.AUTHORITY]:
        raise HTTPException(status_code=403, detail="Access denied")
        
    query = db.query(FacultyLeaveRequest)
    
    if current_user.role == UserRole.HOD:
        # HOD sees requests pending HOD approval
        query = query.filter(FacultyLeaveRequest.status.in_([LeaveStatus.PENDING_HOD, LeaveStatus.PENDING_DEAN, LeaveStatus.PENDING_OM, LeaveStatus.APPROVED, LeaveStatus.REJECTED]))
    elif current_user.role == UserRole.AUTHORITY:
        # Authority sees requests pending DEAN or OM depending on their title
        from app.models.authority import Authority
        auth = db.query(Authority).filter(Authority.user_id == current_user.id).first()
        if "dean" in auth.title.lower():
            query = query.filter(FacultyLeaveRequest.status.in_([LeaveStatus.PENDING_DEAN, LeaveStatus.APPROVED, LeaveStatus.REJECTED]))
        elif "om" in auth.title.lower() or "office manager" in auth.title.lower():
            query = query.filter(FacultyLeaveRequest.status.in_([LeaveStatus.PENDING_OM, LeaveStatus.APPROVED, LeaveStatus.REJECTED]))
        elif "principal" in auth.title.lower():
            query = query.filter(FacultyLeaveRequest.status.in_([LeaveStatus.PENDING_PRINCIPAL, LeaveStatus.APPROVED, LeaveStatus.REJECTED]))
        elif "hr" in auth.title.lower():
            # HR sees all leaves
            pass

    requests = query.order_by(FacultyLeaveRequest.created_at.desc()).all()
    
    for req in requests:
        fac = db.query(Faculty).filter(Faculty.id == req.faculty_id).first()
        req.faculty_name = f"{fac.first_name} {fac.last_name}" if fac else "Unknown"
        for arr in req.arrangements:
            sub = db.query(Faculty).filter(Faculty.id == arr.substitute_faculty_id).first()
            arr.substitute_faculty_name = f"{sub.first_name} {sub.last_name}" if sub else "Unknown"
            
    return requests

@router.get("/requests/{request_id}", response_model=FacultyLeaveRequestResponse)
def get_single_leave_request(
    request_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return get_leave_request_detail(request_id, db)

def get_leave_request_detail(request_id: int, db: Session):
    req = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.id == request_id).first()
    if not req:
        raise HTTPException(status_code=404, detail="Request not found")
        
    fac = db.query(Faculty).filter(Faculty.id == req.faculty_id).first()
    req.faculty_name = f"{fac.first_name} {fac.last_name}" if fac else "Unknown"
    
    if getattr(req, "compensation_verifier_id", None):
        verifier = db.query(Faculty).filter(Faculty.id == req.compensation_verifier_id).first()
        req.compensation_verifier_name = f"{verifier.first_name} {verifier.last_name}" if verifier else "Unknown"
    
    for arr in req.arrangements:
        sub = db.query(Faculty).filter(Faculty.id == arr.substitute_faculty_id).first()
        arr.substitute_faculty_name = f"{sub.first_name} {sub.last_name}" if sub else "Unknown"
        
    return req

@router.get("/substitute-requests", response_model=List[FacultyLeaveRequestResponse])
def get_substitute_requests(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role not in [UserRole.FACULTY, UserRole.HOD, UserRole.AUTHORITY]:
        raise HTTPException(status_code=403, detail="Access denied")
        
    faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
    
    if not faculty:
        return []
    
    arrangements = db.query(FacultyDutyArrangement).filter(
        FacultyDutyArrangement.substitute_faculty_id == faculty.id,
        FacultyDutyArrangement.status == ArrangementStatus.PENDING
    ).all()
    
    request_ids = list(set([a.leave_request_id for a in arrangements]))
    requests = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.id.in_(request_ids)).all()
    response_data = []
    for req in requests:
        fac = db.query(Faculty).filter(Faculty.id == req.faculty_id).first()
        req_dict = {
            "id": req.id,
            "faculty_id": req.faculty_id,
            "leave_type": req.leave_type,
            "from_date": req.from_date,
            "to_date": req.to_date,
            "duration_days": req.duration_days,
            "reason": req.reason,
            "attachment_url": req.attachment_url,
            "compensation_verifier_id": req.compensation_verifier_id,
            "compensation_date": req.compensation_date,
            "compensation_purpose": req.compensation_purpose,
            "status": req.status,
            "hod_approved_by": req.hod_approved_by,
            "dean_approved_by": req.dean_approved_by,
            "om_approved_by": req.om_approved_by,
            "rejection_reason": req.rejection_reason,
            "faculty_name": f"{fac.first_name} {fac.last_name}" if fac else "Unknown",
            "created_at": req.created_at,
            "updated_at": req.updated_at,
            "arrangements": []
        }
        
        for arr in req.arrangements:
            if arr.substitute_faculty_id == faculty.id:
                sub = db.query(Faculty).filter(Faculty.id == arr.substitute_faculty_id).first()
                arr_dict = {
                    "id": arr.id,
                    "leave_request_id": arr.leave_request_id,
                    "substitute_faculty_id": arr.substitute_faculty_id,
                    "subject": arr.subject,
                    "class_section": arr.class_section,
                    "period": arr.period,
                    "day": arr.day,
                    "compensation_date": arr.compensation_date,
                    "compensation_period": arr.compensation_period,
                    "status": arr.status,
                    "substitute_faculty_name": f"{sub.first_name} {sub.last_name}" if sub else "Unknown",
                    "created_at": arr.created_at,
                    "updated_at": arr.updated_at
                }
                req_dict["arrangements"].append(arr_dict)
                
        if req_dict["arrangements"]:
            response_data.append(req_dict)
            
    return response_data

@router.put("/substitute-requests/{arr_id}")
def update_substitute_request(
    arr_id: int,
    status: str, # "accepted" or "rejected"
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role not in [UserRole.FACULTY, UserRole.HOD, UserRole.AUTHORITY]:
        raise HTTPException(status_code=403, detail="Access denied")
        
    faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
    
    if not faculty:
        raise HTTPException(status_code=403, detail="User is not a faculty member")
        
    arr = db.query(FacultyDutyArrangement).filter(
        FacultyDutyArrangement.id == arr_id,
        FacultyDutyArrangement.substitute_faculty_id == faculty.id
    ).first()
    
    if not arr:
        raise HTTPException(status_code=404, detail="Arrangement not found")
        
    if arr.status != ArrangementStatus.PENDING:
        raise HTTPException(status_code=400, detail="This arrangement has already been processed")
        
    if status.lower() == "accepted":
        arr.status = ArrangementStatus.ACCEPTED
    elif status.lower() == "rejected":
        arr.status = ArrangementStatus.REJECTED
    else:
        raise HTTPException(status_code=400, detail="Invalid status")
        
    db.commit()
    
    # Check if all arrangements for the request are accepted
    req = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.id == arr.leave_request_id).first()
    
    # If any arrangement is rejected, reject the entire leave request
    any_rejected = any(a.status == ArrangementStatus.REJECTED for a in req.arrangements)
    
    if any_rejected:
        req.status = LeaveStatus.REJECTED
        req.rejection_reason = "One or more substitute faculty rejected the duty arrangement."
        db.commit()
        return {"message": "Arrangement rejected. Leave request has been rejected."}
    
    # Only move to PENDING_HOD if ALL arrangements are accepted
    all_accepted = all(a.status == ArrangementStatus.ACCEPTED for a in req.arrangements)
    
    if all_accepted and req.status == LeaveStatus.PENDING_SUBSTITUTE:
        req.status = LeaveStatus.PENDING_HOD
        db.commit()
        return {"message": "All substitutes have accepted. Leave request forwarded to HOD for approval."}
        
    return {"message": "Status updated successfully. Waiting for other substitute approvals."}

@router.put("/requests/{request_id}/approve")
def approve_leave_request(
    request_id: int,
    action: str, # "approve" or "reject"
    reason: str = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    req = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.id == request_id).first()
    if not req:
        raise HTTPException(status_code=404, detail="Request not found")
        
    if action.lower() == "reject":
        req.status = LeaveStatus.REJECTED
        req.rejection_reason = reason or "Rejected by authority"
        db.commit()
        return {"message": "Request rejected"}
        
    if current_user.role == UserRole.HOD and req.status == LeaveStatus.PENDING_HOD:
        fac = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
        req.status = LeaveStatus.PENDING_DEAN
        req.hod_approved_by = fac.id
    elif current_user.role == UserRole.AUTHORITY:
        from app.models.authority import Authority
        auth = db.query(Authority).filter(Authority.user_id == current_user.id).first()
        if "dean" in auth.title.lower() and req.status == LeaveStatus.PENDING_DEAN:
            req.status = LeaveStatus.PENDING_OM
            req.dean_approved_by = auth.id
        elif ("om" in auth.title.lower() or "office manager" in auth.title.lower()) and req.status == LeaveStatus.PENDING_OM:
            req.status = LeaveStatus.PENDING_PRINCIPAL
            req.om_approved_by = auth.id
        elif "principal" in auth.title.lower() and req.status == LeaveStatus.PENDING_PRINCIPAL:
            req.status = LeaveStatus.APPROVED
            req.principal_approved_by = auth.id
            
            # Deduct leave balance
            academic_year = "2023-2024"
            balance = db.query(FacultyLeaveBalance).filter(FacultyLeaveBalance.faculty_id == req.faculty_id, FacultyLeaveBalance.academic_year == academic_year).first()
            if balance:
                ltype = req.leave_type.lower()
                if "casual" in ltype:
                    balance.casual_leaves_used += req.duration_days
                elif "restricted" in ltype or "rh" in ltype:
                    balance.restricted_leaves_used += req.duration_days
                elif "earned" in ltype:
                    balance.earned_leaves_used += req.duration_days
                elif "vacation" in ltype:
                    balance.vacation_leaves_used += req.duration_days
                elif "compensation" in ltype:
                    balance.compensation_leaves_used += req.duration_days
                elif "academic" in ltype or "od" in ltype or "duty" in ltype:
                    balance.academic_leaves_used += req.duration_days
                elif "sick" in ltype or "medical" in ltype:
                    balance.sick_leaves_used += req.duration_days
    else:
        raise HTTPException(status_code=403, detail="Not authorized to approve at this stage")
        
    db.commit()
    return {"message": "Request approved"}

@router.get("/compensation-verifications", response_model=List[FacultyLeaveRequestResponse])
def get_compensation_verifications(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role not in [UserRole.FACULTY, UserRole.HOD, UserRole.AUTHORITY]:
        raise HTTPException(status_code=403, detail="Access denied")
        
    requests = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.compensation_verifier_id == current_user.id,
        FacultyLeaveRequest.status == LeaveStatus.PENDING_COMPENSATION_VERIFICATION
    ).all()
    
    response_data = []
    for req in requests:
        response_data.append(get_leave_request_detail(req.id, db))
        
    return response_data

@router.put("/compensation-verifications/{request_id}")
def verify_compensation_leave(
    request_id: int,
    action: str, # "approve" or "reject"
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role not in [UserRole.FACULTY, UserRole.HOD, UserRole.AUTHORITY]:
        raise HTTPException(status_code=403, detail="Access denied")
        
    req = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.id == request_id,
        FacultyLeaveRequest.compensation_verifier_id == current_user.id,
        FacultyLeaveRequest.status == LeaveStatus.PENDING_COMPENSATION_VERIFICATION
    ).first()
    
    if not req:
        raise HTTPException(status_code=404, detail="Request not found or not pending your verification")
        
    if action.lower() == "approve":
        if req.arrangements:
            all_accepted = all(a.status == ArrangementStatus.ACCEPTED for a in req.arrangements)
            if all_accepted:
                req.status = LeaveStatus.PENDING_HOD
                msg = "Compensation verified successfully. All substitutes have already accepted. Request forwarded to HOD."
            else:
                req.status = LeaveStatus.PENDING_SUBSTITUTE
                msg = "Compensation verified successfully. Request forwarded to substitute faculty for duty arrangement approval."
        else:
            req.status = LeaveStatus.PENDING_HOD
            msg = "Compensation verified successfully. Request forwarded to HOD."
            
        db.commit()
        return {"message": msg}
    elif action.lower() == "reject":
        req.status = LeaveStatus.REJECTED
        req.rejection_reason = "Compensation claim was rejected by the verifier."
        db.commit()
        return {"message": "Compensation rejected. Request has been cancelled."}
    else:
        raise HTTPException(status_code=400, detail="Invalid action")

@router.get("/all-verifiers")
def get_all_verifiers(db: Session = Depends(get_db)):
    verifiers = []
    
    faculties = db.query(Faculty).all()
    for f in faculties:
        verifiers.append({
            "id": f.user_id,
            "name": f"{f.first_name} {f.last_name}",
            "designation": f.designation or "Faculty"
        })
        
    from app.models.authority import Authority
    authorities = db.query(Authority).all()
    for a in authorities:
        verifiers.append({
            "id": a.user_id,
            "name": f"{a.first_name} {a.last_name}",
        })
        
    return verifiers

@router.get("/admin/balances/{faculty_id}", response_model=FacultyLeaveBalanceResponse)
def admin_get_leave_balances(
    faculty_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Admin/Authority endpoint to get leave balances of a specific faculty."""
    if current_user.role not in [UserRole.ADMIN, UserRole.AUTHORITY]:
        raise HTTPException(status_code=403, detail="Only admins/authorities can view faculty balances")
        
    faculty = db.query(Faculty).filter(Faculty.id == faculty_id).first()
    if not faculty:
        raise HTTPException(status_code=404, detail="Faculty profile not found")
        
    academic_year = "2023-2024" # Default for now
    balance = db.query(FacultyLeaveBalance).filter(
        FacultyLeaveBalance.faculty_id == faculty.id,
        FacultyLeaveBalance.academic_year == academic_year
    ).first()
    
    if not balance:
        balance = FacultyLeaveBalance(faculty_id=faculty.id, academic_year=academic_year)
        db.add(balance)
        db.commit()
        db.refresh(balance)
        
    return balance

@router.put("/admin/balances/bulk", response_model=dict)
def admin_bulk_update_leave_balances(
    balance_update: FacultyLeaveBalanceUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Admin/Authority endpoint to update leave balance totals for all faculties."""
    if current_user.role not in [UserRole.ADMIN, UserRole.AUTHORITY]:
        raise HTTPException(status_code=403, detail="Only admins/authorities can update faculty balances")
        
    academic_year = "2023-2024" # Default for now
    update_data = balance_update.model_dump(exclude_unset=True)
    
    if not update_data:
        return {"message": "No data provided for update", "updated_count": 0}
        
    faculties = db.query(Faculty).all()
    updated_count = 0
    for faculty in faculties:
        balance = db.query(FacultyLeaveBalance).filter(
            FacultyLeaveBalance.faculty_id == faculty.id,
            FacultyLeaveBalance.academic_year == academic_year
        ).first()
        
        if not balance:
            balance = FacultyLeaveBalance(faculty_id=faculty.id, academic_year=academic_year)
            db.add(balance)
            
        for field, value in update_data.items():
            setattr(balance, field, value)
        updated_count += 1
        
    db.commit()
    return {"message": "Bulk update successful", "updated_count": updated_count}

@router.put("/admin/balances/{faculty_id}", response_model=FacultyLeaveBalanceResponse)
def admin_update_leave_balances(
    faculty_id: int,
    balance_update: FacultyLeaveBalanceUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Admin/Authority endpoint to update leave balance totals for a specific faculty."""
    if current_user.role not in [UserRole.ADMIN, UserRole.AUTHORITY]:
        raise HTTPException(status_code=403, detail="Only admins/authorities can update faculty balances")
        
    faculty = db.query(Faculty).filter(Faculty.id == faculty_id).first()
    if not faculty:
        raise HTTPException(status_code=404, detail="Faculty profile not found")
        
    academic_year = "2023-2024" # Default for now
    balance = db.query(FacultyLeaveBalance).filter(
        FacultyLeaveBalance.faculty_id == faculty.id,
        FacultyLeaveBalance.academic_year == academic_year
    ).first()
    
    if not balance:
        balance = FacultyLeaveBalance(faculty_id=faculty.id, academic_year=academic_year)
        db.add(balance)
        db.commit()
        db.refresh(balance)

    update_data = balance_update.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(balance, field, value)

    db.commit()
    db.refresh(balance)
    return balance

@router.get("/hour-permission-data")
def get_hour_permission_data(
    on_date: str, start_time: str, end_time: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
    if not faculty:
        raise HTTPException(404, "Faculty profile not found")

    d = datetime.strptime(on_date, "%Y-%m-%d").date()
    day_name = d.strftime("%a").lower()[:3]
    st = datetime.strptime(start_time, "%H:%M").time()
    et = datetime.strptime(end_time, "%H:%M").time()

    my_assignments = db.query(CourseAssignment).filter(
        CourseAssignment.faculty_id == faculty.id, CourseAssignment.is_active == True
    ).all()
    assignment_ids = [a.id for a in my_assignments]

    conflict_slot = db.query(TimetableSlot).filter(
        TimetableSlot.course_assignment_id.in_(assignment_ids),
        TimetableSlot.day == day_name
    ).all()
    conflict_slots = [s for s in conflict_slot if s.start_time < et and s.end_time > st]

    other_faculty = db.query(Faculty).filter(Faculty.id != faculty.id, Faculty.is_active == True).all()

    conflicts_data = []

    if not conflict_slots:
        subs = []
        for f in other_faculty:
            if f.department_id != faculty.department_id:
                continue
            busy_slots = db.query(TimetableSlot).join(CourseAssignment, TimetableSlot.course_assignment_id == CourseAssignment.id).filter(
                CourseAssignment.faculty_id == f.id,
                TimetableSlot.day == day_name
            ).all()
            is_busy = any(bs.start_time < et and bs.end_time > st for bs in busy_slots)
            if not is_busy:
                subs.append({"id": f.id, "name": f"{f.first_name} {f.last_name}", "designation": f.designation})
                
        conflicts_data.append({
            "class_section": "Department Works",
            "section_id": None,
            "course_code": "Department Works",
            "period": f"{start_time} - {end_time}",
            "available_substitutes": subs
        })

    for cs in conflict_slots:
        assignment = db.query(CourseAssignment).filter(CourseAssignment.id == cs.course_assignment_id).first()
        course = db.query(Course).filter(Course.id == assignment.course_id).first()
        section = db.query(Section).filter(Section.id == assignment.section_id).first()
        department = db.query(Department).filter(Department.id == section.department_id).first()

        subs = []
        for f in other_faculty:
            teaches = db.query(CourseAssignment).filter(
                CourseAssignment.faculty_id == f.id,
                CourseAssignment.section_id == section.id,
                CourseAssignment.is_active == True
            ).first()
            if not teaches:
                continue
            busy_slots = db.query(TimetableSlot).filter(
                TimetableSlot.course_assignment_id == teaches.id, TimetableSlot.day == day_name
            ).all()
            is_busy = any(bs.start_time < cs.end_time and bs.end_time > cs.start_time for bs in busy_slots)
            if not is_busy:
                subs.append({"id": f.id, "name": f"{f.first_name} {f.last_name}", "designation": f.designation})

        conflicts_data.append({
            "class_section": f"{department.code if department else 'Dept'} Year-{section.year} {section.name}",
            "section_id": section.id,
            "course_code": course.code,
            "period": cs.period_display,
            "available_substitutes": subs
        })

    # Always append Department Works if we had conflicts
    if conflict_slots:
        subs = []
        for f in other_faculty:
            if f.department_id != faculty.department_id:
                continue
            busy_slots = db.query(TimetableSlot).join(CourseAssignment, TimetableSlot.course_assignment_id == CourseAssignment.id).filter(
                CourseAssignment.faculty_id == f.id,
                TimetableSlot.day == day_name
            ).all()
            is_busy = any(bs.start_time < et and bs.end_time > st for bs in busy_slots)
            if not is_busy:
                subs.append({"id": f.id, "name": f"{f.first_name} {f.last_name}", "designation": f.designation})
                
        conflicts_data.append({
            "class_section": "Department Works",
            "section_id": None,
            "course_code": "Department Works",
            "period": f"{start_time} - {end_time}",
            "available_substitutes": subs
        })

    return {"has_conflict": True, "conflicts": conflicts_data}


@router.get("/altered-class-advisor-duties")
def get_altered_class_advisor_duties(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    faculty = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
    if not faculty:
        return []

    import datetime as dt
    today = dt.datetime.now().date()
    rows = db.query(FacultyDutyArrangement).join(
        FacultyLeaveRequest, FacultyDutyArrangement.leave_request_id == FacultyLeaveRequest.id
    ).filter(
        FacultyDutyArrangement.substitute_faculty_id == faculty.id,
        FacultyDutyArrangement.subject == "Class Advisor",
        FacultyDutyArrangement.status == ArrangementStatus.ACCEPTED,
        FacultyLeaveRequest.from_date <= today,
        FacultyLeaveRequest.to_date >= today,
        FacultyLeaveRequest.status.notin_([LeaveStatus.REJECTED, LeaveStatus.WITHDRAWN])
    ).all()

    result = []
    for arr in rows:
        section = db.query(Section).filter(Section.id == arr.section_id).first()
        if section:
            result.append({
                "arrangement_id": arr.id,
                "section_id": section.id,
                "class_section": arr.class_section,
                "original_advisor_id": section.class_advisor_id
            })
    return result


def is_effective_class_advisor(faculty_id: int, section_id: int, on_date, db: Session) -> bool:
    section = db.query(Section).filter(Section.id == section_id).first()
    if section and section.class_advisor_id == faculty_id:
        return True
    return db.query(FacultyDutyArrangement).join(
        FacultyLeaveRequest, FacultyDutyArrangement.leave_request_id == FacultyLeaveRequest.id
    ).filter(
        FacultyDutyArrangement.substitute_faculty_id == faculty_id,
        FacultyDutyArrangement.section_id == section_id,
        FacultyDutyArrangement.subject == "Class Advisor",
        FacultyDutyArrangement.status == ArrangementStatus.ACCEPTED,
        FacultyLeaveRequest.from_date <= on_date,
        FacultyLeaveRequest.to_date >= on_date,
        FacultyLeaveRequest.status.notin_([LeaveStatus.REJECTED, LeaveStatus.WITHDRAWN])
    ).first() is not None
