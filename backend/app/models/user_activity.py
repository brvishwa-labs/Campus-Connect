"""
Campus Connect ERP — User Activity Tracking Model

Tracks when users last viewed specific pages/sections for notification badge management.
"""

from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.core.database import Base


class UserPageView(Base):
    """Track when a user last viewed a specific page/section"""
    __tablename__ = "user_page_views"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    page_path = Column(String(255), nullable=False)  # e.g., "/faculty/leave", "/student/marks"
    last_viewed_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    user = relationship("User")

    # Ensure one row per user per page
    __table_args__ = (
        {"schema": None},
    )
