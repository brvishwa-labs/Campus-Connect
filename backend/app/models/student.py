from datetime import datetime
from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey
from app.database import Base


class Student(Base):
    __tablename__ = "students"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True, nullable=False)
    register_no = Column(String(50), unique=True, nullable=False)
    name = Column(String(255), nullable=False)
    department_id = Column(Integer, ForeignKey("departments.id"), nullable=False)
    year = Column(Integer, nullable=False, default=1)
    semester = Column(Integer, nullable=False, default=1)
    section = Column(String(10), nullable=False, default="A")
    batch = Column(String(20), nullable=True)
    academic_year = Column(String(20), nullable=True)
    phone = Column(String(20), nullable=True)
    parent_phone = Column(String(20), nullable=True)
    address = Column(String(500), nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def __repr__(self):
        return f"<Student(id={self.id}, name='{self.name}', register_no='{self.register_no}')>"
