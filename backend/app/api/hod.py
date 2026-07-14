from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session, joinedload
from typing import List

from app.core.database import get_db
from app.models.user import User
from app.models.faculty import Faculty
from app.models.student import Student
from app.models.department import Department
from app.models.academic import Section, Course, CourseAssignment, MentorAssignment
from app.models.lms import TimetableSlot, Announcement
from app.schemas.hod import (
    SectionCreate, SectionUpdate, SectionResponse,
    CourseAssignmentCreate, CourseAssignmentResponse,
    MentorAssignmentCreate, MentorAssignmentResponse,
    HodDashboardResponse,
    TimetableSlotCreate, TimetableSlotResponse, TimetableBulkCreate,
    AnnouncementCreate, AnnouncementResponse,
    AssignStudentsRequest
)
from typing import List, Optional
from app.core.security import get_current_active_user

router = APIRouter()


def get_hod_department(current_user: User, db: Session):
    """
    Helper: Given the current user (who must be an HOD), return their department.
    """
    if current_user.role != "hod":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access restricted to HODs")

    faculty_profile = db.query(Faculty).filter(Faculty.user_id == current_user.id).first()
    if not faculty_profile:
        raise HTTPException(status_code=404, detail="Faculty profile not found for this HOD user")

    department = db.query(Department).filter(Department.hod_id == faculty_profile.id).first()
    if not department:
        raise HTTPException(status_code=404, detail="No department assigned to this HOD")

    return department, faculty_profile


# ── Dashboard ──────────────────────────────────────────

@router.get("/dashboard", response_model=HodDashboardResponse)
def hod_dashboard(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, faculty_profile = get_hod_department(current_user, db)

    faculty_count = db.query(Faculty).filter(Faculty.department_id == department.id).count()
    student_count = db.query(Student).filter(Student.department_id == department.id).count()
    course_count = db.query(Course).filter(Course.department_id == department.id).count()
    section_count = db.query(Section).filter(Section.department_id == department.id).count()
    assignment_count = db.query(CourseAssignment).join(Course).filter(
        Course.department_id == department.id,
        Course.is_active == True,
        CourseAssignment.is_active == True
    ).count()

    # Get HOD's full name and qualifications
    hod_name = f"{faculty_profile.first_name} {faculty_profile.last_name}" if faculty_profile else None
    hod_title = faculty_profile.qualification if faculty_profile and faculty_profile.qualification else None

    return HodDashboardResponse(
        department_name=department.name,
        department_code=department.code,
        faculty_count=faculty_count,
        student_count=student_count,
        course_count=course_count,
        section_count=section_count,
        assignment_count=assignment_count,
        hod_name=hod_name,
        hod_title=hod_title
    )

# ── Department Settings ───────────────────────────────

from app.schemas.department import DepartmentResponse, DepartmentSettingsUpdate

@router.get("/department-settings", response_model=DepartmentResponse)
def get_department_settings(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    return department

@router.put("/department-settings", response_model=DepartmentResponse)
def update_department_settings(
    settings: DepartmentSettingsUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    
    if settings.current_sem_start_date is not None:
        department.current_sem_start_date = settings.current_sem_start_date
    if settings.attendance_closed is not None:
        department.attendance_closed = settings.attendance_closed
        
    db.commit()
    db.refresh(department)
    return department



# ── Faculty (read-only for HOD) ──────────────────────────

@router.get("/faculty")
def hod_faculty(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    # Get all faculty from all departments (not just current HOD's department)
    faculty = db.query(Faculty).all()
    return [
        {
            "id": f.id,
            "first_name": f.first_name,
            "last_name": f.last_name,
            "employee_id": f.employee_id,
            "designation": f.designation,
            "college_email": f.college_email,
            "phone": f.phone,
        }
        for f in faculty
    ]


# ── Courses (read-only for HOD) ─────────────────────────

@router.get("/courses")
def hod_courses(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    courses = db.query(Course).filter(Course.department_id == department.id, Course.is_active == True).all()
    return [
        {
            "id": c.id,
            "code": c.code,
            "name": c.name,
            "credits": c.credits,
            "course_type": c.course_type.value if c.course_type else None,
            "semester": c.semester,
        }
        for c in courses
    ]


# ── Students (read-only for HOD) ────────────────────────

@router.get("/students")
def hod_students(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    students = db.query(Student).options(joinedload(Student.section)).filter(Student.department_id == department.id).all()
    return [
        {
            "id": s.id,
            "first_name": s.first_name,
            "last_name": s.last_name,
            "register_number": s.register_number,
            "batch": s.batch,
            "current_semester": s.current_semester,
            "section": {
                "id": s.section.id,
                "name": s.section.name,
                "year": s.section.year
            } if s.section else None
        }
        for s in students
    ]


# ── Sections CRUD ────────────────────────────────────────

@router.get("/sections", response_model=List[SectionResponse])
def get_sections(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    return db.query(Section).filter(Section.department_id == department.id).all()


@router.post("/sections", response_model=SectionResponse, status_code=status.HTTP_201_CREATED)
def create_section(
    section_in: SectionCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)

    # Check for duplicates
    existing = db.query(Section).filter(
        Section.department_id == department.id,
        Section.name == section_in.name,
        Section.year == section_in.year
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="This section already exists")

    new_section = Section(
        department_id=department.id,
        name=section_in.name,
        year=section_in.year
    )
    db.add(new_section)
    db.commit()
    db.refresh(new_section)
    return new_section


@router.put("/sections/{section_id}", response_model=SectionResponse)
def update_section(
    section_id: int,
    section_in: SectionUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    section = db.query(Section).filter(Section.id == section_id, Section.department_id == department.id).first()
    if not section:
        raise HTTPException(status_code=404, detail="Section not found")

    update_data = section_in.model_dump(exclude_unset=True)

    # Validate class advisor belongs to same department
    if "class_advisor_id" in update_data and update_data["class_advisor_id"]:
        advisor = db.query(Faculty).filter(
            Faculty.id == update_data["class_advisor_id"],
            Faculty.department_id == department.id
        ).first()
        if not advisor:
            raise HTTPException(status_code=400, detail="Class advisor must belong to your department")

    for field, value in update_data.items():
        setattr(section, field, value)

    db.commit()
    db.refresh(section)
    return section


@router.delete("/sections/{section_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_section(
    section_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    section = db.query(Section).filter(Section.id == section_id, Section.department_id == department.id).first()
    if not section:
        raise HTTPException(status_code=404, detail="Section not found")
        
    if db.query(Student).filter(Student.section_id == section_id).first():
        raise HTTPException(status_code=400, detail="Cannot delete this section because students are assigned to it. Please reassign them first.")
        
    if db.query(CourseAssignment).filter(CourseAssignment.section_id == section_id).first():
        raise HTTPException(status_code=400, detail="Cannot delete this section because it has active course assignments. Please delete all course assignments for this section first.")

    db.delete(section)
    db.commit()
    return None

@router.get("/sections/{section_id}/unassigned-students")
def get_unassigned_students(
    section_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    section = db.query(Section).filter(Section.id == section_id, Section.department_id == department.id).first()
    if not section:
        raise HTTPException(status_code=404, detail="Section not found")

    # Fetch students in the same department and year who don't have a section assigned
    students = db.query(Student).filter(
        Student.department_id == department.id,
        Student.current_year == section.year,
        Student.section_id == None,
        Student.is_active == True
    ).all()
    
    return [
        {
            "id": s.id,
            "first_name": s.first_name,
            "last_name": s.last_name,
            "register_number": s.register_number,
        }
        for s in students
    ]

@router.put("/sections/{section_id}/students")
def update_section_students(
    section_id: int,
    payload: AssignStudentsRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    section = db.query(Section).filter(Section.id == section_id, Section.department_id == department.id).first()
    if not section:
        raise HTTPException(status_code=404, detail="Section not found")

    # Unassign all students currently in this section
    db.query(Student).filter(Student.section_id == section_id).update({"section_id": None})
    
    # Assign the provided students to this section
    if payload.student_ids:
        # Verify that these students belong to the same department
        valid_students = db.query(Student).filter(
            Student.id.in_(payload.student_ids),
            Student.department_id == department.id
        ).all()
        
        valid_student_ids = [s.id for s in valid_students]
        if len(valid_student_ids) != len(payload.student_ids):
            raise HTTPException(status_code=400, detail="Some students do not exist or belong to a different department")
            
        db.query(Student).filter(Student.id.in_(valid_student_ids)).update({"section_id": section_id})

    db.commit()
    return {"message": "Students successfully assigned to the section"}


# ── Course Assignments CRUD ──────────────────────────────

@router.get("/assignments", response_model=List[CourseAssignmentResponse])
def get_assignments(
    section_id: Optional[int] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    query = db.query(CourseAssignment).options(
        joinedload(CourseAssignment.course),
        joinedload(CourseAssignment.faculty)
    ).join(Course).filter(
        Course.department_id == department.id,
        Course.is_active == True,
        CourseAssignment.is_active == True
    )
    if section_id:
        query = query.filter(CourseAssignment.section_id == section_id)
    return query.all()


@router.post("/assignments", response_model=CourseAssignmentResponse, status_code=status.HTTP_201_CREATED)
def create_assignment(
    assignment_in: CourseAssignmentCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)

    # Validate faculty belongs to this department
    faculty = db.query(Faculty).filter(
        Faculty.id == assignment_in.faculty_id,
        Faculty.department_id == department.id
    ).first()
    if not faculty:
        raise HTTPException(status_code=400, detail="Faculty member not found in your department")

    # Validate course belongs to this department
    course = db.query(Course).filter(
        Course.id == assignment_in.course_id,
        Course.department_id == department.id
    ).first()
    if not course:
        raise HTTPException(status_code=400, detail="Course not found in your department")

    # Validate section belongs to this department
    section = db.query(Section).filter(
        Section.id == assignment_in.section_id,
        Section.department_id == department.id
    ).first()
    if not section:
        raise HTTPException(status_code=400, detail="Section not found in your department")

    # Check for duplicate assignment
    existing = db.query(CourseAssignment).filter(
        CourseAssignment.course_id == assignment_in.course_id,
        CourseAssignment.section_id == assignment_in.section_id,
        CourseAssignment.academic_year == assignment_in.academic_year,
        CourseAssignment.semester == assignment_in.semester,
        CourseAssignment.is_active == True
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="This course is already assigned to this section for the given semester")

    new_assignment = CourseAssignment(**assignment_in.model_dump())
    db.add(new_assignment)
    db.commit()
    db.refresh(new_assignment)
    return new_assignment


@router.delete("/assignments/{assignment_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_assignment(
    assignment_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    assignment = (
        db.query(CourseAssignment)
        .join(Course)
        .filter(CourseAssignment.id == assignment_id, Course.department_id == department.id)
        .first()
    )
    if not assignment:
        raise HTTPException(status_code=404, detail="Assignment not found")
        
    # Delete associated timetable slots first to avoid FK constraint violations
    from app.models.lms import TimetableSlot
    db.query(TimetableSlot).filter(TimetableSlot.course_assignment_id == assignment_id).delete()

    assignment.is_active = False
    db.commit()
    return None


# ── Mentor Assignments CRUD ──────────────────────────────

@router.get("/mentors", response_model=List[MentorAssignmentResponse])
def get_mentors(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    return (
        db.query(MentorAssignment)
        .join(Faculty, MentorAssignment.mentor_id == Faculty.id)
        .filter(Faculty.department_id == department.id)
        .all()
    )


@router.post("/mentors", response_model=MentorAssignmentResponse, status_code=status.HTTP_201_CREATED)
def create_mentor(
    mentor_in: MentorAssignmentCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)

    faculty = db.query(Faculty).filter(
        Faculty.id == mentor_in.mentor_id,
        Faculty.department_id == department.id
    ).first()
    if not faculty:
        raise HTTPException(status_code=400, detail="Faculty member not found in your department")

    student = db.query(Student).filter(
        Student.id == mentor_in.student_id,
        Student.department_id == department.id
    ).first()
    if not student:
        raise HTTPException(status_code=400, detail="Student not found in your department")

    # Update existing or create new mentor assignment
    existing = db.query(MentorAssignment).filter(
        MentorAssignment.student_id == mentor_in.student_id
    ).first()
    if existing:
        existing.mentor_id = mentor_in.mentor_id
        existing.academic_year = mentor_in.academic_year
        db.commit()
        db.refresh(existing)
        return existing
    else:
        new_mentor = MentorAssignment(**mentor_in.model_dump())
        db.add(new_mentor)
        db.commit()
        db.refresh(new_mentor)
        return new_mentor

@router.delete("/mentors/student/{student_id}", status_code=status.HTTP_204_NO_CONTENT)
def unassign_mentor(
    student_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    
    assignment = (
        db.query(MentorAssignment)
        .join(Student, MentorAssignment.student_id == Student.id)
        .filter(MentorAssignment.student_id == student_id, Student.department_id == department.id)
        .first()
    )
    if assignment:
        db.delete(assignment)
        db.commit()
    return None


@router.delete("/mentors/{mentor_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_mentor(
    mentor_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    assignment = (
        db.query(MentorAssignment)
        .join(Faculty, MentorAssignment.mentor_id == Faculty.id)
        .filter(MentorAssignment.id == mentor_id, Faculty.department_id == department.id)
        .first()
    )
    if not assignment:
        raise HTTPException(status_code=404, detail="Mentor assignment not found")
    db.delete(assignment)
    db.commit()
    return None

# ── Timetable Management ──────────────────────────────────

@router.get("/timetable", response_model=List[TimetableSlotResponse])
def get_timetable(
    section_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    
    # Verify section belongs to this HOD's department
    section = db.query(Section).filter(Section.id == section_id, Section.department_id == department.id).first()
    if not section:
        raise HTTPException(status_code=404, detail="Section not found in your department")

    # Get all active course assignments for this section
    assignments = db.query(CourseAssignment).filter(
        CourseAssignment.section_id == section_id,
        CourseAssignment.is_active == True
    ).all()
    assignment_ids = [a.id for a in assignments]

    slots = db.query(TimetableSlot).filter(TimetableSlot.course_assignment_id.in_(assignment_ids)).all()
    # Format times as strings for response
    for s in slots:
        s.start_time = s.start_time.strftime("%H:%M")
        s.end_time = s.end_time.strftime("%H:%M")
    return slots

@router.post("/timetable", response_model=TimetableSlotResponse, status_code=status.HTTP_201_CREATED)
def create_timetable_slot(
    slot_in: TimetableSlotCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)

    # Verify assignment belongs to this department
    assignment = (
        db.query(CourseAssignment)
        .join(Course)
        .filter(CourseAssignment.id == slot_in.course_assignment_id, Course.department_id == department.id)
        .first()
    )
    if not assignment:
        raise HTTPException(status_code=404, detail="Course Assignment not found in your department")

    from datetime import datetime
    try:
        start_t = datetime.strptime(slot_in.start_time, "%H:%M").time()
        end_t = datetime.strptime(slot_in.end_time, "%H:%M").time()
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid time format. Use HH:MM")

    new_slot = TimetableSlot(
        course_assignment_id=slot_in.course_assignment_id,
        day=slot_in.day,
        start_time=start_t,
        end_time=end_t,
        room=slot_in.room
    )
    db.add(new_slot)
    db.commit()
    db.refresh(new_slot)
    new_slot.start_time = new_slot.start_time.strftime("%H:%M")
    new_slot.end_time = new_slot.end_time.strftime("%H:%M")
    return new_slot

@router.post("/timetable/bulk", status_code=status.HTTP_201_CREATED)
def bulk_create_timetable(
    payload: TimetableBulkCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    
    # 1. Verify section belongs to HOD
    section = db.query(Section).filter(Section.id == payload.section_id, Section.department_id == department.id).first()
    if not section:
        raise HTTPException(status_code=404, detail="Section not found in your department")
        
    # 2. Get all assignments for this section
    assignments = db.query(CourseAssignment).filter(CourseAssignment.section_id == payload.section_id).all()
    assignment_ids = [a.id for a in assignments]
    
    # 3. Delete existing slots for this section
    if assignment_ids:
        db.query(TimetableSlot).filter(TimetableSlot.course_assignment_id.in_(assignment_ids)).delete(synchronize_session=False)
        
    # 4. Insert new slots
    from datetime import datetime
    new_slots = []
    for slot_in in payload.slots:
        if slot_in.course_assignment_id not in assignment_ids:
            raise HTTPException(status_code=400, detail=f"Assignment {slot_in.course_assignment_id} does not belong to section {payload.section_id}")
            
        try:
            start_t = datetime.strptime(slot_in.start_time, "%H:%M").time()
            end_t = datetime.strptime(slot_in.end_time, "%H:%M").time()
        except ValueError:
            raise HTTPException(status_code=400, detail="Invalid time format. Use HH:MM")
            
        new_slots.append(TimetableSlot(
            course_assignment_id=slot_in.course_assignment_id,
            day=slot_in.day,
            start_time=start_t,
            end_time=end_t,
            room=slot_in.room
        ))
        
    if new_slots:
        db.add_all(new_slots)
        
    db.commit()
    return {"message": "Timetable updated successfully", "slots_added": len(new_slots)}

@router.delete("/timetable/{slot_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_timetable_slot(
    slot_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    slot = (
        db.query(TimetableSlot)
        .join(CourseAssignment)
        .join(Course)
        .filter(TimetableSlot.id == slot_id, Course.department_id == department.id)
        .first()
    )
    if not slot:
        raise HTTPException(status_code=404, detail="Slot not found")
    db.delete(slot)
    db.commit()
    return None

# ── Announcements Management ──────────────────────────────

@router.get("/announcements", response_model=List[AnnouncementResponse])
def get_announcements(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    return db.query(Announcement).filter(
        (Announcement.department_id == department.id) | (Announcement.is_global == True)
    ).order_by(Announcement.created_at.desc()).all()

@router.post("/announcements", response_model=AnnouncementResponse, status_code=status.HTTP_201_CREATED)
def create_announcement(
    ann_in: AnnouncementCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    
    new_ann = Announcement(
        department_id=department.id,
        posted_by_id=current_user.id,
        title=ann_in.title,
        content=ann_in.content,
        is_global=False # HODs can only post to their department
    )
    db.add(new_ann)
    db.commit()
    db.refresh(new_ann)
    return new_ann

@router.delete("/announcements/{ann_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_announcement(
    ann_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    department, _ = get_hod_department(current_user, db)
    ann = db.query(Announcement).filter(
        Announcement.id == ann_id,
        Announcement.department_id == department.id
    ).first()
    if not ann:
        raise HTTPException(status_code=404, detail="Announcement not found or not yours to delete")
    db.delete(ann)
    db.commit()
    return None

# ── Monitoring (Dummy endpoints for Phase 4 UI) ──────────────────────

@router.get("/attendance-summary")
def get_attendance_summary(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    from datetime import date
    from app.models.attendance import Attendance, AttendanceStatus
    from app.models.student import Student
    from app.models.academic import Section, CourseAssignment

    department, _ = get_hod_department(current_user, db)
    today = date.today()

    # Get all active sections in the HOD's department
    sections = db.query(Section).filter(
        Section.department_id == department.id,
        Section.is_active == True
    ).all()

    year_mapping = {
        1: "I Year",
        2: "II Year",
        3: "III Year",
        4: "IV Year"
    }

    year_breakdown = {}
    for y_name in year_mapping.values():
        year_breakdown[y_name] = {
            "sections": [],
            "totalRate": 0
        }

    total_present_all = 0
    total_absent_all = 0
    any_marked_today = False

    for section in sections:
        year_str = year_mapping.get(section.year, f"{section.year} Year")
        if year_str not in year_breakdown:
            year_breakdown[year_str] = {
                "sections": [],
                "totalRate": 0
            }

        students = db.query(Student).filter(
            Student.section_id == section.id,
            Student.is_active == True
        ).all()
        student_ids = [s.id for s in students]

        if not student_ids:
            continue

        # Get homeroom course_id
        homeroom_course_id = None
        assignment = db.query(CourseAssignment).filter(
            CourseAssignment.section_id == section.id,
            CourseAssignment.is_active == True
        ).order_by(CourseAssignment.id).first()
        if assignment:
            homeroom_course_id = assignment.course_id

        # Query attendance for today
        attendance_records = db.query(Attendance).filter(
            Attendance.student_id.in_(student_ids),
            Attendance.date == today
        )
        if homeroom_course_id:
            homeroom_records = attendance_records.filter(Attendance.course_id == homeroom_course_id).all()
            if homeroom_records:
                records = homeroom_records
            else:
                records = attendance_records.all()
        else:
            records = attendance_records.all()

        is_marked = len(records) > 0
        if is_marked:
            any_marked_today = True

        present_count = 0
        absent_count = 0

        # Unique status per student
        student_status = {}
        for r in records:
            if r.student_id not in student_status:
                student_status[r.student_id] = r.status

        for s in students:
            status = student_status.get(s.id)
            if status in [AttendanceStatus.PRESENT, AttendanceStatus.LATE, AttendanceStatus.ON_DUTY]:
                present_count += 1
                total_present_all += 1
            elif status == AttendanceStatus.ABSENT:
                absent_count += 1
                total_absent_all += 1

        year_breakdown[year_str]["sections"].append({
            "name": f"{year_str.split()[0]} {section.name}", # e.g. "III A"
            "present": present_count,
            "absent": absent_count,
            "is_marked": is_marked,
            "total_students": len(students)
        })

    # Calculate total rates
    for year_str, data in year_breakdown.items():
        yr_present = sum(s["present"] for s in data["sections"])
        yr_absent = sum(s["absent"] for s in data["sections"])
        if yr_present + yr_absent > 0:
            data["totalRate"] = int(round((yr_present / (yr_present + yr_absent)) * 100))
        else:
            data["totalRate"] = 0

    overall_rate = 0
    if total_present_all + total_absent_all > 0:
        overall_rate = int(round((total_present_all / (total_present_all + total_absent_all)) * 100))

    return {
        "overallRate": overall_rate,
        "isMarkedToday": any_marked_today,
        "yearBreakdown": year_breakdown
    }

@router.get("/results-summary")
def get_results_summary(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    from app.models.academic import Course
    from app.models.grade import Grade, GradeType, GRADE_PASS_MARKS
    from app.models.student import Student
    
    department, _ = get_hod_department(current_user, db)
    
    # Determine the active semester for each year by checking current students
    active_semesters = {}
    for yr in [1, 2, 3, 4]:
        student = db.query(Student).filter(
            Student.department_id == department.id, 
            Student.current_year == yr
        ).first()
        if student and student.current_semester:
            active_semesters[yr] = student.current_semester
            
    courses = db.query(Course).filter(
        Course.department_id == department.id,
        Course.is_active == True
    ).all()
    
    results_by_year = {
        "I Year": [],
        "II Year": [],
        "III Year": [],
        "IV Year": []
    }
    
    for course in courses:
        # Determine which year this course belongs to based on its semester
        course_year = None
        year_str = None
        if course.semester in [1, 2]:
            course_year = 1
            year_str = "I Year"
        elif course.semester in [3, 4]:
            course_year = 2
            year_str = "II Year"
        elif course.semester in [5, 6]:
            course_year = 3
            year_str = "III Year"
        elif course.semester in [7, 8]:
            course_year = 4
            year_str = "IV Year"
            
        if not course_year:
            continue
            
        # ONLY include the course if it belongs to the currently active semester for that year
        active_sem_for_this_year = active_semesters.get(course_year)
        if active_sem_for_this_year and course.semester != active_sem_for_this_year:
            continue
            
        # Get model exam grades for this course
        grades = db.query(Grade).filter(
            Grade.course_id == course.id,
            Grade.grade_type == GradeType.MODEL_EXAM
        ).all()
        
        total_graded = len(grades)
        pass_threshold = GRADE_PASS_MARKS.get(GradeType.MODEL_EXAM, 30)
        max_possible_marks = 60 # Model Exam max marks
        
        passed_count = 0
        failed_count = 0
        absent_count = 0
        sum_scores = 0
        highest_score = 0
        
        distribution = {
            "90-100%": 0,
            "80-89%": 0,
            "70-79%": 0,
            "60-69%": 0,
            "50-59%": 0,
            "<50% (Fail)": 0
        }
        
        for g in grades:
            if g.is_absent or g.marks_obtained is None:
                absent_count += 1
                continue
                
            score = float(g.marks_obtained)
            sum_scores += score
            if score > highest_score:
                highest_score = score
                
            if score >= pass_threshold:
                passed_count += 1
            else:
                failed_count += 1
                
            percentage = (score / max_possible_marks) * 100
            if percentage >= 90: distribution["90-100%"] += 1
            elif percentage >= 80: distribution["80-89%"] += 1
            elif percentage >= 70: distribution["70-79%"] += 1
            elif percentage >= 60: distribution["60-69%"] += 1
            elif percentage >= 50: distribution["50-59%"] += 1
            else: distribution["<50% (Fail)"] += 1
        
        pass_percentage = 0
        average_score = 0
        if total_graded > 0:
            pass_percentage = round((passed_count / total_graded) * 100, 1)
            average_score = round(sum_scores / (total_graded - absent_count), 1) if (total_graded - absent_count) > 0 else 0
            
        course_data = {
            "course_id": course.id,
            "course_code": course.code,
            "course_name": course.name,
            "course_type": course.course_type.value if course.course_type else "theory",
            "pass_percentage": pass_percentage,
            "total_students": total_graded,
            "passed": passed_count,
            "failed": failed_count,
            "absent": absent_count,
            "average_score": average_score,
            "highest_score": highest_score,
            "distribution": [
                {"name": "90-100%", "count": distribution["90-100%"]},
                {"name": "80-89%", "count": distribution["80-89%"]},
                {"name": "70-79%", "count": distribution["70-79%"]},
                {"name": "60-69%", "count": distribution["60-69%"]},
                {"name": "50-59%", "count": distribution["50-59%"]},
                {"name": "<50% (Fail)", "count": distribution["<50% (Fail)"]},
            ]
        }
        
        results_by_year[year_str].append(course_data)
        
    for yr in results_by_year:
        results_by_year[yr].sort(key=lambda x: x["pass_percentage"], reverse=True)
        
    return results_by_year

from sqlalchemy import func
from datetime import datetime, timedelta, date

@router.get("/attendance-analytics", response_model=dict)
def get_attendance_analytics(
    academic_year: Optional[str] = None,
    semester: Optional[int] = None,
    section_id: Optional[int] = None,
    faculty_id: Optional[int] = None,
    target_date: Optional[date] = None,
    time_scale: Optional[str] = "Daily",
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    from app.schemas.attendance import (
        OverviewStats, DonutData, TrendData, SectionComparison,
        HeatmapData, FacultyAttendanceStats, RiskDistribution,
        LiveStatus, StudentTableData, AttendanceAnalyticsResponse
    )
    from app.models.attendance import Attendance, AttendanceStatus
    from app.models.student import Student
    from app.models.faculty import Faculty
    
    department, _ = get_hod_department(current_user, db)
    t_date = target_date or date.today()
    
    # ---------------------------------------------------------
    # 0. Base Queries (Students & Faculty)
    # ---------------------------------------------------------
    students_query = db.query(Student).filter(Student.department_id == department.id, Student.is_active == True)
    if section_id:
        students_query = students_query.filter(Student.section_id == section_id)
        
    all_students = students_query.all()
    dept_student_ids = [s.id for s in all_students]
    
    from app.models.faculty import Faculty
    from app.models.leave import FacultyLeaveRequest, LeaveStatus as FacLeaveStatus
    from app.models.academic import CourseAssignment, Section
    
    dept_faculty = db.query(Faculty).filter(Faculty.department_id == department.id, Faculty.is_active == True).all()
    faculty_ids = [f.id for f in dept_faculty]
    total_faculty = len(dept_faculty)

    # ---------------------------------------------------------
    # 1. Overview Stats & Donuts
    # ---------------------------------------------------------
    students_present = 0
    students_absent = 0
    boys_present = 0
    girls_present = 0
    boys_absent = 0
    girls_absent = 0
    today_att = []
    
    # Pre-calculate department total regardless of filters
    total_students_dept = db.query(Student).filter(Student.department_id == department.id, Student.is_active == True).count()
    
    total_boys_dept = sum(1 for s in all_students if (s.gender or "").lower() == "male")
    total_girls_dept = sum(1 for s in all_students if (s.gender or "").lower() == "female")
    
    if dept_student_ids:
        today_att = db.query(Attendance).filter(
            Attendance.student_id.in_(dept_student_ids),
            Attendance.date == t_date
        ).all()
        
        student_day_status = {}
        for att in today_att:
            if att.status == AttendanceStatus.ABSENT:
                student_day_status[att.student_id] = "absent"
            else:
                if student_day_status.get(att.student_id) != "absent":
                    student_day_status[att.student_id] = "present"
                    
        students_present = sum(1 for status in student_day_status.values() if status == "present")
        students_absent = sum(1 for status in student_day_status.values() if status == "absent")
        
        student_gender = {s.id: (s.gender or "").lower() for s in all_students}
        for sid, status in student_day_status.items():
            gender = student_gender.get(sid, "")
            if status == "present":
                if gender == "male": boys_present += 1
                elif gender == "female": girls_present += 1
        # The user wants absentees to be calculated against the total department population.
        # So anyone not explicitly marked present is considered absent.
        students_absent = len(all_students) - students_present
        boys_absent = total_boys_dept - boys_present
        girls_absent = total_girls_dept - girls_present
        
    faculty_absent = 0
    if faculty_ids:
        faculty_absent = db.query(FacultyLeaveRequest).filter(
            FacultyLeaveRequest.faculty_id.in_(faculty_ids),
            FacultyLeaveRequest.status == "approved",
            FacultyLeaveRequest.from_date <= t_date,
            FacultyLeaveRequest.to_date >= t_date
        ).count()
        
    faculty_present = total_faculty - faculty_absent
    
    student_total = len(all_students)
    student_attendance_percentage = (students_present / student_total * 100) if student_total > 0 else 0.0
    faculty_attendance_percentage = (faculty_present / total_faculty * 100) if total_faculty > 0 else 0.0
    overview = OverviewStats(
        students_present=students_present,
        students_absent=students_absent,
        faculty_present=faculty_present,
        faculty_absent=faculty_absent,
        student_attendance_percentage=round(student_attendance_percentage, 1),
        faculty_attendance_percentage=round(faculty_attendance_percentage, 1),
        trend_indicator="stable",
        total_students_dept=total_students_dept,
        total_faculty_dept=total_faculty,
        total_boys_dept=total_boys_dept,
        total_girls_dept=total_girls_dept,
        boys_present=boys_present,
        girls_present=girls_present,
        boys_absent=boys_absent,
        girls_absent=girls_absent
    )
    
    student_donut = [
        DonutData(name="Present", value=students_present, color="#10b981"),
        DonutData(name="Absent", value=students_absent, color="#ef4444")
    ]
    
    faculty_donut = [
        DonutData(name="Present", value=faculty_present, color="#3b82f6"),
        DonutData(name="On Leave", value=faculty_absent, color="#f59e0b")
    ]
    
    # ---------------------------------------------------------
    # 2. Trends (10 points)
    # ---------------------------------------------------------
    trends = []
    step_days = 1 if time_scale == "Daily" else (7 if time_scale == "Weekly" else 30)
    start_date = t_date - timedelta(days=9 * step_days)
    
    trend_attendances = []
    if dept_student_ids:
        trend_attendances = db.query(Attendance).filter(
            Attendance.student_id.in_(dept_student_ids),
            Attendance.date >= start_date,
            Attendance.date <= t_date
        ).all()
        
    trend_faculty_leaves = []
    if faculty_ids:
        trend_faculty_leaves = db.query(FacultyLeaveRequest).filter(
            FacultyLeaveRequest.faculty_id.in_(faculty_ids),
            FacultyLeaveRequest.status == "approved",
            FacultyLeaveRequest.from_date <= t_date,
            FacultyLeaveRequest.to_date >= start_date
        ).all()
        
    for i in range(9, -1, -1):
        target = t_date - timedelta(days=i * step_days)
        
        # Students
        day_atts = [a for a in trend_attendances if a.date == target]
        s_day_status = {}
        for att in day_atts:
            if att.status == AttendanceStatus.ABSENT:
                s_day_status[att.student_id] = "absent"
            else:
                if s_day_status.get(att.student_id) != "absent":
                    s_day_status[att.student_id] = "present"
                    
        p_count = sum(1 for st in s_day_status.values() if st == "present")
        tot = len(all_students)
        a_count = tot - p_count
        s_pct = (p_count / tot * 100) if tot > 0 else 0.0
        
        # Faculty
        f_abs = sum(1 for l in trend_faculty_leaves if l.from_date <= target <= l.to_date)
        f_pres = total_faculty - f_abs
        f_pct = (f_pres / total_faculty * 100) if total_faculty > 0 else 0.0
        
        trends.append(TrendData(
            date=str(target),
            present=p_count,
            absent=a_count,
            percentage=round(s_pct, 1),
            faculty_percentage=round(f_pct, 1)
        ))
        
    # ---------------------------------------------------------
    # 3. Detailed Student Records (Moved up for reuse)
    # ---------------------------------------------------------
    from app.core.config import get_settings
    settings = get_settings()
    if department.current_sem_start_date:
        sem_start_date = department.current_sem_start_date.date()
    else:
        sem_start_date = datetime.strptime(settings.SEM_START_DATE, "%Y-%m-%d").date()

    attendance_by_student = {s.id: {"present": 0, "absent": 0} for s in all_students}
    if dept_student_ids:
        all_att = db.query(Attendance).filter(
            Attendance.student_id.in_(dept_student_ids),
            Attendance.date >= sem_start_date,
            Attendance.date <= t_date
        ).all()
        for att in all_att:
            if att.status == AttendanceStatus.HOLIDAY:
                continue
            if att.status in [AttendanceStatus.PRESENT, AttendanceStatus.LATE, AttendanceStatus.ON_DUTY]:
                attendance_by_student[att.student_id]["present"] += 1
            elif att.status == AttendanceStatus.ABSENT:
                attendance_by_student[att.student_id]["absent"] += 1
                
    student_table = []
    for s in all_students:
        counts = attendance_by_student[s.id]
        total_p = counts["present"]
        total_a = counts["absent"]
        total_days = total_p + total_a
        pct = (total_p / total_days * 100.0) if total_days > 0 else 0.0
        
        if total_days == 0:
            status = "Safe"
        elif pct >= 85:
            status = "Safe"
        elif pct >= 75:
            status = "Warning"
        else:
            status = "Critical"
            
        sec_name = s.section.name if s.section else f"Year {s.current_year or 'N/A'}"
        
        student_table.append(
            StudentTableData(
                student_id=s.id,
                register_number=s.register_number,
                name=f"{s.first_name} {s.last_name}",
                year=s.current_year or 1,
                section=s.section.name if s.section else 'N/A',
                total_present=total_p,
                total_absent=total_a,
                percentage=round(pct, 1),
                status=status
            )
        )
        
    # ---------------------------------------------------------
    # 4. Section Comparison & Risk Distribution
    # ---------------------------------------------------------
    section_stats = {}
    risk_stats = {}
    
    for st in student_table:
        s_obj = next((s for s in all_students if s.id == st.student_id), None)
        year = s_obj.current_year if s_obj else 1
        
        # Risk
        if year not in risk_stats:
            risk_stats[year] = {"safe": 0, "warning": 0, "critical": 0}
            
        if (st.total_present + st.total_absent) == 0 or st.percentage >= 85.0:
            risk_stats[year]["safe"] += 1
        elif st.percentage >= 75.0:
            risk_stats[year]["warning"] += 1
        else:
            risk_stats[year]["critical"] += 1
            
        # Section
        sec = st.section
        if sec not in section_stats:
            section_stats[sec] = {"year": year, "total_p": 0, "total_a": 0, "below_75": 0}
            
        section_stats[sec]["total_p"] += st.total_present
        section_stats[sec]["total_a"] += st.total_absent
        if st.percentage < 75.0 and (st.total_present + st.total_absent) > 0:
            section_stats[sec]["below_75"] += 1
            
    section_comparison = []
    for sec_name, stats in section_stats.items():
        tot = stats["total_p"] + stats["total_a"]
        pct = (stats["total_p"] / tot * 100) if tot > 0 else 0.0
        section_comparison.append(SectionComparison(
            year=stats["year"] or 1,
            section_name=sec_name,
            percentage=round(pct, 1),
            students_below_75=stats["below_75"]
        ))
        
    risk_distribution = [
        RiskDistribution(year=y, safe=r["safe"], warning=r["warning"], critical=r["critical"])
        for y, r in risk_stats.items()
    ]
    
    # ---------------------------------------------------------
    # 5. Heatmap (Last 30 Days)
    # ---------------------------------------------------------
    heatmap_start = t_date - timedelta(days=30)
    heatmap_atts = []
    if dept_student_ids:
        heatmap_atts = db.query(Attendance).filter(
            Attendance.student_id.in_(dept_student_ids),
            Attendance.status == AttendanceStatus.ABSENT,
            Attendance.date >= heatmap_start,
            Attendance.date <= t_date
        ).all()
        
    heatmap_counts = {}
    student_lookup = {st.student_id: {"year": st.year, "section": st.section} for st in student_table}
    
    for att in heatmap_atts:
        info = student_lookup.get(att.student_id)
        if not info:
            continue
        day_name = att.date.strftime("%A")
        period = att.hour or 1
        key = (day_name, period, info["year"], info["section"])
        heatmap_counts[key] = heatmap_counts.get(key, 0) + 1
        
    heatmap = [HeatmapData(day=d, period=p, year=y, section=s, absent_count=c) for (d, p, y, s), c in heatmap_counts.items()]
    if not heatmap:
        heatmap = [HeatmapData(day="Monday", period=1, year=1, section="A", absent_count=0)]
        
    # ---------------------------------------------------------
    # 6. Faculty Stats
    # ---------------------------------------------------------
    dept_pct = sum(sc.percentage for sc in section_comparison) / len(section_comparison) if section_comparison else 0.0
    faculty_stats = []
    
    for f in dept_faculty:
        assignments = db.query(CourseAssignment).filter(CourseAssignment.faculty_id == f.id).count()
        leaves_taken = db.query(FacultyLeaveRequest).filter(
            FacultyLeaveRequest.faculty_id == f.id,
            FacultyLeaveRequest.status == "approved"
        ).count()
        
        faculty_stats.append(FacultyAttendanceStats(
            faculty_name=f"{f.first_name} {f.last_name}",
            classes_handled=assignments,
            avg_student_attendance=round(dept_pct, 1),
            absentee_count=leaves_taken
        ))
        
    # ---------------------------------------------------------
    # 7. Live Status & Insights
    # ---------------------------------------------------------
    live_status = LiveStatus(
        ongoing_classes=len(set(a.course_id for a in today_att)) if today_att else 0,
        marked_classes=len(set(a.course_id for a in today_att)) if today_att else 0,
        present_now=students_present,
        absent_now=students_absent
    )
    
    insights = []
    if section_comparison:
        lowest_sec = min(section_comparison, key=lambda x: x.percentage)
        insights.append(f"{lowest_sec.section_name} has the lowest overall attendance at {lowest_sec.percentage}%.")
    
    total_critical = sum(r.critical for r in risk_distribution)
    if total_critical > 0:
        insights.append(f"{total_critical} students are currently in the critical risk zone (<75%) across the department.")
    else:
        insights.append("Great job! 0 students are currently in the critical risk zone.")
        
    if faculty_absent > 0:
        insights.append(f"{faculty_absent} faculty members are on leave today.")
    else:
        insights.append("All faculty members are present today.")
    
    response = AttendanceAnalyticsResponse(
        overview=overview,
        student_donut=student_donut,
        faculty_donut=faculty_donut,
        trends=trends,
        section_comparison=section_comparison,
        heatmap=heatmap,
        faculty_stats=faculty_stats,
        risk_distribution=risk_distribution,
        live_status=live_status,
        student_table=student_table,
        insights=insights
    )
    
    return response.model_dump()

@router.get("/faculty-attendance")
def get_faculty_attendance(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    from datetime import date
    from app.models.leave import FacultyLeaveRequest
    from app.models.faculty import Faculty

    department, _ = get_hod_department(current_user, db)
    today = date.today()

    # Get all faculty in HOD's department
    faculty_members = db.query(Faculty).filter(
        Faculty.department_id == department.id,
        Faculty.is_active == True
    ).all()
    faculty_ids = [f.id for f in faculty_members]

    # Get leave requests for today
    leaves = db.query(FacultyLeaveRequest).filter(
        FacultyLeaveRequest.faculty_id.in_(faculty_ids),
        FacultyLeaveRequest.from_date <= today,
        FacultyLeaveRequest.to_date >= today
    ).all()

    on_leave_list = []
    absent_list = []
    present_list = []

    faculty_status = {}

    for leave in leaves:
        status_str = str(leave.status.value) if hasattr(leave.status, 'value') else str(leave.status)
        status_lower = status_str.lower()
        if 'approved' in status_lower:
            faculty_status[leave.faculty_id] = "on_leave"
        elif 'rejected' in status_lower:
            faculty_status[leave.faculty_id] = "absent"

    for f in faculty_members:
        status = faculty_status.get(f.id)
        name = f"Dr. {f.first_name} {f.last_name}" if "HOD" not in f.designation else f"{f.first_name} {f.last_name}"
        if status == "on_leave":
            on_leave_list.append(name)
        elif status == "absent":
            absent_list.append(name)
        else:
            present_list.append(name)

    # In case there are no records at all and we want to provide some realistic mock fallback if empty:
    # Actually, the user says "Do NOT use dummy, hardcoded, or randomly generated data. Retrieve the actual records."
    # Since we seeded real records in the database, we return the actual lists!
    # But wait, what if the lists are empty? It's fine to show actual database records (which means 0 absent, 1 on leave).
    # That is correct and adheres strictly to the rule.
    
    return {
        "presentCount": len(present_list),
        "absentCount": len(absent_list),
        "onLeaveCount": len(on_leave_list),
        "presentFaculty": present_list,
        "absentFaculty": absent_list,
        "onLeaveFaculty": on_leave_list
    }

@router.get("/course-results/{course_id}")
def get_course_detailed_results(
    course_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    from app.models.academic import Course
    from app.models.grade import Grade, GradeType, GRADE_MAX_MARKS, GRADE_PASS_MARKS
    from app.models.student import Student

    department, _ = get_hod_department(current_user, db)

    course = db.query(Course).filter(
        Course.id == course_id,
        Course.department_id == department.id
    ).first()

    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    exam_types = [GradeType.INTERNAL_1, GradeType.INTERNAL_2, GradeType.MODEL_EXAM]
    exam_names = {
        GradeType.INTERNAL_1: "CIA 1",
        GradeType.INTERNAL_2: "CIA 2",
        GradeType.MODEL_EXAM: "Model Exam"
    }

    results_data = []

    for exam_type in exam_types:
        grades = db.query(Grade, Student).join(Student, Grade.student_id == Student.id).filter(
            Grade.course_id == course.id,
            Grade.grade_type == exam_type
        ).all()

        if not grades:
            continue

        total_graded = len(grades)
        max_possible_marks = GRADE_MAX_MARKS.get(exam_type, 100)
        pass_threshold = GRADE_PASS_MARKS.get(exam_type, 40)

        passed_count = 0
        failed_count = 0
        absent_count = 0
        sum_scores = 0
        highest_score = 0

        distribution = {
            "90-100%": 0, "80-89%": 0, "70-79%": 0, "60-69%": 0, "50-59%": 0, "<50% (Fail)": 0
        }

        student_list = []

        for g, s in grades:
            status = "Absent"
            if g.is_absent or g.marks_obtained is None:
                absent_count += 1
            else:
                score = float(g.marks_obtained)
                sum_scores += score
                if score > highest_score:
                    highest_score = score
                
                if score >= pass_threshold:
                    passed_count += 1
                    status = "Pass"
                else:
                    failed_count += 1
                    status = "Fail"
                
                percentage = (score / max_possible_marks) * 100
                if percentage >= 90: distribution["90-100%"] += 1
                elif percentage >= 80: distribution["80-89%"] += 1
                elif percentage >= 70: distribution["70-79%"] += 1
                elif percentage >= 60: distribution["60-69%"] += 1
                elif percentage >= 50: distribution["50-59%"] += 1
                else: distribution["<50% (Fail)"] += 1

            student_list.append({
                "id": s.id,
                "name": f"{s.first_name} {s.last_name}".strip(),
                "register_number": s.register_number,
                "marks_obtained": float(g.marks_obtained) if g.marks_obtained is not None else None,
                "max_marks": max_possible_marks,
                "status": status
            })

        # Sort students alphabetically by name
        student_list.sort(key=lambda x: x["name"])

        pass_percentage = round((passed_count / total_graded) * 100, 1) if total_graded > 0 else 0
        average_score = round(sum_scores / (total_graded - absent_count), 1) if (total_graded - absent_count) > 0 else 0

        results_data.append({
            "exam_key": exam_type.value,
            "exam_name": exam_names[exam_type],
            "analytics": {
                "pass_percentage": pass_percentage,
                "average_score": average_score,
                "highest_score": highest_score,
                "total_students": total_graded,
                "passed": passed_count,
                "failed": failed_count,
                "absent": absent_count,
                "distribution": [
                    {"name": "90-100%", "count": distribution["90-100%"]},
                    {"name": "80-89%", "count": distribution["80-89%"]},
                    {"name": "70-79%", "count": distribution["70-79%"]},
                    {"name": "60-69%", "count": distribution["60-69%"]},
                    {"name": "50-59%", "count": distribution["50-59%"]},
                    {"name": "<50% (Fail)", "count": distribution["<50% (Fail)"]},
                ]
            },
            "students": student_list
        })

    return {
        "course_code": course.code,
        "course_name": course.name,
        "exams": results_data
    }
