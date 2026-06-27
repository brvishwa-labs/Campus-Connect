from pydantic import BaseModel, EmailStr, ConfigDict
from typing import Optional
from datetime import datetime, date

class FacultyBase(BaseModel):
    first_name: str
    last_name: str
    department_id: int
    employee_id: str
    college_email: EmailStr
    phone: str
    designation: Optional[str] = None
    specialization: Optional[str] = None
    gender: Optional[str] = None
    joining_date: Optional[date] = None

class FacultyCreate(FacultyBase):
    # Initial password for the user account
    password: str

class FacultyUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    department_id: Optional[int] = None
    employee_id: Optional[str] = None
    phone: Optional[str] = None
    designation: Optional[str] = None
    specialization: Optional[str] = None
    gender: Optional[str] = None
    is_active: Optional[bool] = None

class FacultyResponse(FacultyBase):
    id: int
    user_id: int
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    model_config = ConfigDict(from_attributes=True)
