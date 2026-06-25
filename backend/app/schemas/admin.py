from pydantic import BaseModel
from typing import Optional
from datetime import datetime


# --- Department Schemas ---
class DepartmentCreate(BaseModel):
    name: str
    code: str
    description: Optional[str] = None


class DepartmentUpdate(BaseModel):
    name: Optional[str] = None
    code: Optional[str] = None
    description: Optional[str] = None
    is_active: Optional[bool] = None


class DepartmentResponse(BaseModel):
    id: int
    name: str
    code: str
    description: Optional[str] = None
    is_active: bool
    hod_id: Optional[int] = None
    hod_name: Optional[str] = None
    student_count: Optional[int] = 0
    faculty_count: Optional[int] = 0
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# --- Faculty Schemas ---
class FacultyCreate(BaseModel):
    email: str
    password: str
    name: str
    faculty_code: str
    department_id: int
    designation: Optional[str] = "Assistant Professor"
    qualification: Optional[str] = None
    experience_years: Optional[int] = 0
    specialization: Optional[str] = None
    phone: Optional[str] = None


class FacultyUpdate(BaseModel):
    name: Optional[str] = None
    department_id: Optional[int] = None
    designation: Optional[str] = None
    qualification: Optional[str] = None
    experience_years: Optional[int] = None
    specialization: Optional[str] = None
    phone: Optional[str] = None
    is_active: Optional[bool] = None


class FacultyResponse(BaseModel):
    id: int
    user_id: int
    faculty_code: str
    name: str
    department_id: int
    department_name: Optional[str] = None
    designation: Optional[str] = None
    qualification: Optional[str] = None
    experience_years: Optional[int] = 0
    specialization: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    is_active: bool
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# --- Student Schemas ---
class StudentCreate(BaseModel):
    email: str
    password: str
    name: str
    register_no: str
    department_id: int
    year: int = 1
    semester: int = 1
    section: str = "A"
    batch: Optional[str] = None
    academic_year: Optional[str] = None
    phone: Optional[str] = None
    parent_phone: Optional[str] = None
    address: Optional[str] = None


class StudentUpdate(BaseModel):
    name: Optional[str] = None
    department_id: Optional[int] = None
    year: Optional[int] = None
    semester: Optional[int] = None
    section: Optional[str] = None
    batch: Optional[str] = None
    academic_year: Optional[str] = None
    phone: Optional[str] = None
    parent_phone: Optional[str] = None
    address: Optional[str] = None
    is_active: Optional[bool] = None


class StudentResponse(BaseModel):
    id: int
    user_id: int
    register_no: str
    name: str
    department_id: int
    department_name: Optional[str] = None
    year: int
    semester: int
    section: str
    batch: Optional[str] = None
    academic_year: Optional[str] = None
    phone: Optional[str] = None
    parent_phone: Optional[str] = None
    email: Optional[str] = None
    is_active: bool
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class BatchPromoteRequest(BaseModel):
    department_id: Optional[int] = None
    from_year: int
    from_semester: int
    to_year: int
    to_semester: int


# --- Course Schemas ---
class CourseCreate(BaseModel):
    course_code: str
    name: str
    department_id: int
    semester: int
    credits: int = 3
    regulation: Optional[str] = None
    academic_year: Optional[str] = None
    course_type: Optional[str] = "Theory"
    description: Optional[str] = None


class CourseUpdate(BaseModel):
    name: Optional[str] = None
    department_id: Optional[int] = None
    semester: Optional[int] = None
    credits: Optional[int] = None
    regulation: Optional[str] = None
    academic_year: Optional[str] = None
    course_type: Optional[str] = None
    description: Optional[str] = None
    is_active: Optional[bool] = None


class CourseResponse(BaseModel):
    id: int
    course_code: str
    name: str
    department_id: int
    department_name: Optional[str] = None
    semester: int
    credits: int
    regulation: Optional[str] = None
    academic_year: Optional[str] = None
    course_type: Optional[str] = None
    description: Optional[str] = None
    is_active: bool
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# --- Announcement Schemas ---
class AnnouncementCreate(BaseModel):
    title: str
    content: str
    category: str = "general"
    target_audience: str = "all"
    target_department_id: Optional[int] = None
    is_pinned: bool = False


class AnnouncementUpdate(BaseModel):
    title: Optional[str] = None
    content: Optional[str] = None
    category: Optional[str] = None
    target_audience: Optional[str] = None
    target_department_id: Optional[int] = None
    is_pinned: Optional[bool] = None
    is_active: Optional[bool] = None


class AnnouncementResponse(BaseModel):
    id: int
    title: str
    content: str
    category: str
    target_audience: str
    target_department_id: Optional[int] = None
    created_by: int
    created_by_name: Optional[str] = None
    is_active: bool
    is_pinned: bool
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# --- HOD Assignment ---
class HODAssignRequest(BaseModel):
    department_id: int
    faculty_user_id: int


# --- Audit Log ---
class AuditLogResponse(BaseModel):
    id: int
    timestamp: Optional[datetime] = None
    user_id: Optional[int] = None
    user_email: Optional[str] = None
    role: Optional[str] = None
    action: str
    resource: Optional[str] = None
    resource_id: Optional[int] = None
    status: str
    details: Optional[str] = None
    ip_address: Optional[str] = None

    class Config:
        from_attributes = True
