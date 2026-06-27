from pydantic import BaseModel, EmailStr, ConfigDict
from typing import Optional
from datetime import datetime

class AuthorityBase(BaseModel):
    first_name: str
    last_name: str
    title: str
    email: EmailStr
    phone: str
    employee_id: str

class AuthorityCreate(AuthorityBase):
    password: str

class AuthorityUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    title: Optional[str] = None
    phone: Optional[str] = None
    employee_id: Optional[str] = None
    is_active: Optional[bool] = None

class AuthorityResponse(AuthorityBase):
    id: int
    user_id: int
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None

    model_config = ConfigDict(from_attributes=True)
