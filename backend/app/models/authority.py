"""
Campus Connect ERP — Authority Model

For college-level roles: Principal, Vice Principal, Dean, Office Manager, etc.
These are NOT department-specific — they are institution-wide.
"""

from sqlalchemy import (
    Column, Integer, String, DateTime, ForeignKey, Boolean
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.core.database import Base


class Authority(Base):
    __tablename__ = "authorities"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True, nullable=False)

    # --- Personal Details ---
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    title = Column(String(100), nullable=False)   # Principal, Vice Principal, Dean, Office Manager
    email = Column(String(255), unique=True, nullable=False)
    phone = Column(String(15), nullable=False)
    employee_id = Column(String(50), unique=True, nullable=False)

    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    user = relationship("User", back_populates="authority_profile")
