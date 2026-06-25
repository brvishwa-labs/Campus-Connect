import enum
from datetime import datetime
from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Text, Enum as SAEnum
from app.database import Base


class AnnouncementTarget(str, enum.Enum):
    ALL = "all"
    STUDENTS = "students"
    FACULTY = "faculty"
    HODS = "hods"
    DEPARTMENT = "department"


class AnnouncementCategory(str, enum.Enum):
    GENERAL = "general"
    URGENT = "urgent"
    ACADEMIC = "academic"
    EVENT = "event"
    EXAMINATION = "examination"


class Announcement(Base):
    __tablename__ = "announcements"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    title = Column(String(255), nullable=False)
    content = Column(Text, nullable=False)
    category = Column(SAEnum(AnnouncementCategory), default=AnnouncementCategory.GENERAL)
    target_audience = Column(SAEnum(AnnouncementTarget), default=AnnouncementTarget.ALL)
    target_department_id = Column(Integer, ForeignKey("departments.id"), nullable=True)
    created_by = Column(Integer, ForeignKey("users.id"), nullable=False)
    is_active = Column(Boolean, default=True)
    is_pinned = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def __repr__(self):
        return f"<Announcement(id={self.id}, title='{self.title}')>"
