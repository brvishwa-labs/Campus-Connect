from pydantic import BaseModel, EmailStr
from app.models.user import UserRole
from typing import Optional

class Token(BaseModel):
    access_token: str
    token_type: str
    user: dict

class TokenData(BaseModel):
    user_id: Optional[str] = None

class UserLogin(BaseModel):
    email: EmailStr
    password: str
