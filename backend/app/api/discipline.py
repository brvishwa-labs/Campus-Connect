from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import List, Optional
from datetime import date, datetime, timedelta

from app.core.database import get_db
from app.core.security import get_current_active_user
from app.models.user import User
from app.models.student import Student
from app.models.department import Department
from app.models.discipline import DisciplineRecord, IncidentCategory
from app.schemas.discipline import (
    DisciplineCreate, DisciplineUpdate, DisciplineResponse, 
    DisciplineAnalytics, CategoryCount, TrendPoint, DepartmentCount, MentorCount, StudentCount
)

router = APIRouter()

def _serialize_record(record: DisciplineRecord) -> dict:
    reporter_name = record.reported_by.email if record.reported_by else None
    if record.reported_by:
        if record.reported_by.faculty_profile:
            reporter_name = f"{record.reported_by.faculty_profile.first_name} {record.reported_by.faculty_profile.last_name}"
        elif record.reported_by.authority_profile:
            reporter_name = f"{record.reported_by.authority_profile.first_name} {record.reported_by.authority_profile.last_name}"
        elif record.reported_by.role == 'admin':
            reporter_name = 'Admin'

    mentor_name = "Unassigned"
    if record.student and record.student.mentor_assignment and record.student.mentor_assignment.mentor:
        mentor_name = f"{record.student.mentor_assignment.mentor.first_name} {record.student.mentor_assignment.mentor.last_name}"

    return {
        "id": record.id,
        "student_id": record.student_id,
        "reported_by_id": record.reported_by_id,
        "incident_type": record.incident_type,
        "incident_date": record.incident_date,
        "remarks": record.remarks,
        "action_status": record.action_status,
        "action_taken": record.action_taken,
        "is_locked": record.is_locked,
        "created_at": record.created_at,
        "updated_at": record.updated_at,
        "student_name": f"{record.student.first_name} {record.student.last_name}" if record.student else None,
        "student_register_number": record.student.register_number if record.student else None,
        "student_mentor": mentor_name,
        "reporter_name": reporter_name,
        "reporter_role": record.reported_by.role if record.reported_by else None
    }

@router.post("/", response_model=DisciplineResponse, status_code=status.HTTP_201_CREATED)
def create_record(
    record_in: DisciplineCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Create a new discipline record. 
    Accessible by Admin, Higher Authority, HOD, and Faculty.
    Students cannot create discipline records.
    """
    if current_user.role == "student":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Students cannot report discipline incidents")

    student = db.query(Student).filter(Student.id == record_in.student_id).first()
    if not student:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")

    new_record = DisciplineRecord(
        student_id=record_in.student_id,
        reported_by_id=current_user.id,
        incident_type=record_in.incident_type,
        incident_date=record_in.incident_date or date.today(),
        remarks=record_in.remarks,
        action_taken=record_in.action_taken,
        is_locked=True  # Automatically locked upon creation
    )
    
    db.add(new_record)
    db.commit()
    db.refresh(new_record)
    
    return _serialize_record(new_record)


@router.get("/", response_model=List[DisciplineResponse])
def get_records(
    department_id: Optional[int] = None,
    student_id: Optional[int] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Get discipline records based on role.
    Admin & Higher Auth: View all (or filter by dept).
    HOD: View all in their dept.
    Faculty: View all in their dept (or specific assigned).
    Student: View only their own.
    """
    query = db.query(DisciplineRecord).join(Student)
    
    if current_user.role == "student":
        # Students can only view their own
        student = db.query(Student).filter(Student.user_id == current_user.id).first()
        if not student:
            return []
        query = query.filter(DisciplineRecord.student_id == student.id)
    
    elif current_user.role == "hod":
        # HOD sees all in their department
        if current_user.faculty_profile and current_user.faculty_profile.department_id:
            query = query.filter(Student.department_id == current_user.faculty_profile.department_id)
            
    elif current_user.role == "faculty":
        # Faculty sees ONLY incidents they reported
        query = query.filter(DisciplineRecord.reported_by_id == current_user.id)
            
    if department_id and current_user.role in ["admin", "authority"]:
        query = query.filter(Student.department_id == department_id)
        
    if student_id and current_user.role != "student":
        query = query.filter(DisciplineRecord.student_id == student_id)
        
    records = query.order_by(DisciplineRecord.created_at.desc()).all()
    return [_serialize_record(r) for r in records]


@router.put("/{record_id}", response_model=DisciplineResponse)
def update_record(
    record_id: int,
    record_in: DisciplineUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Edit a discipline record.
    ONLY Admins can edit locked records.
    """
    if current_user.role != "admin":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only Admins can edit discipline records")
        
    record = db.query(DisciplineRecord).filter(DisciplineRecord.id == record_id).first()
    if not record:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Record not found")
        
    if record_in.incident_type is not None:
        record.incident_type = record_in.incident_type
    if record_in.incident_date is not None:
        record.incident_date = record_in.incident_date
    if record_in.remarks is not None:
        record.remarks = record_in.remarks
    if record_in.action_taken is not None:
        record.action_taken = record_in.action_taken
    if record_in.is_locked is not None:
        record.is_locked = record_in.is_locked
        
    db.commit()
    db.refresh(record)
    return _serialize_record(record)


@router.delete("/{record_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_record(
    record_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Delete a discipline record.
    ONLY Admins can delete.
    """
    if current_user.role != "admin":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only Admins can delete discipline records")
        
    record = db.query(DisciplineRecord).filter(DisciplineRecord.id == record_id).first()
    if not record:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Record not found")
        
    db.delete(record)
    db.commit()


@router.get("/analytics", response_model=DisciplineAnalytics)
def get_analytics(
    department_id: Optional[int] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Get Discipline Analytics.
    Admin & Authority get overall (unless department_id is passed).
    HOD gets their own department automatically.
    """
    query = db.query(DisciplineRecord).join(Student)
    
    if current_user.role == "hod":
        if current_user.faculty_profile and current_user.faculty_profile.department_id:
            query = query.filter(Student.department_id == current_user.faculty_profile.department_id)
    elif department_id:
        query = query.filter(Student.department_id == department_id)
        
    total = query.count()
    
    # Category Distribution
    cat_dist = db.query(
        DisciplineRecord.incident_type, 
        func.count(DisciplineRecord.id)
    ).join(Student)
    
    if current_user.role == "hod" and current_user.faculty_profile and current_user.faculty_profile.department_id:
        cat_dist = cat_dist.filter(Student.department_id == current_user.faculty_profile.department_id)
    elif department_id:
        cat_dist = cat_dist.filter(Student.department_id == department_id)
        
    cat_dist = cat_dist.group_by(DisciplineRecord.incident_type).all()
    categories = [CategoryCount(category=str(c[0].value), count=c[1]) for c in cat_dist]
    
    # Trend (Last 7 Days)
    today = date.today()
    trends = []
    for i in range(6, -1, -1):
        target_date = today - timedelta(days=i)
        
        q_trend = db.query(DisciplineRecord).join(Student).filter(
            func.date(DisciplineRecord.incident_date) == target_date
        )
        if current_user.role == "hod" and current_user.faculty_profile and current_user.faculty_profile.department_id:
            q_trend = q_trend.filter(Student.department_id == current_user.faculty_profile.department_id)
        elif department_id:
            q_trend = q_trend.filter(Student.department_id == department_id)
            
        count = q_trend.count()
        trends.append(TrendPoint(period=target_date.strftime("%b %d"), count=count))

    # Department Distribution (Only for Authority/Admin)
    dept_distribution = None
    if current_user.role in ["authority", "admin"] and not department_id:
        from app.models.department import Department
        dept_dist = db.query(
            Department.code, 
            func.count(DisciplineRecord.id)
        ).join(Student, Student.department_id == Department.id)\
         .join(DisciplineRecord, DisciplineRecord.student_id == Student.id)\
         .group_by(Department.code).all()
        
        dept_distribution = [DepartmentCount(department=str(c[0]), count=c[1]) for c in dept_dist]

    # Mentor Distribution (For Authority/Admin and HOD)
    mentor_distribution = None
    if current_user.role in ["authority", "admin", "hod"]:
        from app.models.academic import MentorAssignment
        from app.models.faculty import Faculty
        
        mentor_query = db.query(
            Faculty.first_name, Faculty.last_name,
            func.count(DisciplineRecord.id)
        ).select_from(DisciplineRecord)\
         .join(Student, DisciplineRecord.student_id == Student.id)\
         .join(MentorAssignment, MentorAssignment.student_id == Student.id)\
         .join(Faculty, MentorAssignment.mentor_id == Faculty.id)
        
        if current_user.role == "hod" and current_user.faculty_profile and current_user.faculty_profile.department_id:
            mentor_query = mentor_query.filter(Student.department_id == current_user.faculty_profile.department_id)
        elif department_id:
            mentor_query = mentor_query.filter(Student.department_id == department_id)
            
        mentor_dist_data = mentor_query.group_by(Faculty.id).all()
        mentor_distribution = [MentorCount(mentor=f"{c[0]} {c[1]}", count=c[2]) for c in mentor_dist_data]
        mentor_distribution.sort(key=lambda x: x.count, reverse=True)

    # Student Distribution (For Authority/Admin and HOD)
    student_distribution = None
    if current_user.role in ["authority", "admin", "hod"]:
        from app.models.academic import MentorAssignment
        from app.models.faculty import Faculty
        
        student_query = db.query(
            Student.first_name, Student.last_name, Student.register_number,
            Faculty.first_name, Faculty.last_name,
            func.count(DisciplineRecord.id)
        ).select_from(DisciplineRecord)\
         .join(Student, DisciplineRecord.student_id == Student.id)\
         .outerjoin(MentorAssignment, MentorAssignment.student_id == Student.id)\
         .outerjoin(Faculty, MentorAssignment.mentor_id == Faculty.id)
        
        if current_user.role == "hod" and current_user.faculty_profile and current_user.faculty_profile.department_id:
            student_query = student_query.filter(Student.department_id == current_user.faculty_profile.department_id)
        elif department_id:
            student_query = student_query.filter(Student.department_id == department_id)
            
        student_dist_data = student_query.group_by(Student.id, Faculty.id).all()
        student_distribution = [
            StudentCount(
                student_name=f"{c[0]} {c[1]}", 
                register_number=c[2],
                mentor=f"{c[3]} {c[4]}" if c[3] else "Unassigned", 
                count=c[5]
            ) 
            for c in student_dist_data
        ]
        student_distribution.sort(key=lambda x: x.count, reverse=True)

    return DisciplineAnalytics(
        total_incidents=total,
        category_distribution=categories,
        recent_trend=trends,
        department_distribution=dept_distribution,
        mentor_distribution=mentor_distribution,
        student_distribution=student_distribution
    )
