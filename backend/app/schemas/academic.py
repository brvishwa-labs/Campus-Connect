from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime
from enum import Enum

class CourseTypeEnum(str, Enum):
    theory = "theory"
    lab = "lab"
    elective = "elective"
    open_elective = "open_elective"
    project = "project"

class CourseBase(BaseModel):
    department_id: int
    code: str
    name: str
    short_name: Optional[str] = None
    credits: int = 3
    course_type: CourseTypeEnum = CourseTypeEnum.theory
    semester: Optional[int] = None
    syllabus: Optional[str] = None
    objectives: Optional[str] = None
    outcomes: Optional[str] = None
    textbooks: Optional[str] = None
    references: Optional[str] = None
    prerequisites: Optional[str] = None
    co_po_mapping: Optional[str] = None
    co_k_levels: Optional[str] = None

class CourseCreate(CourseBase):
    pass

class CourseUpdate(BaseModel):
    department_id: Optional[int] = None
    code: Optional[str] = None
    name: Optional[str] = None
    short_name: Optional[str] = None
    credits: Optional[int] = None
    course_type: Optional[CourseTypeEnum] = None
    semester: Optional[int] = None
    syllabus: Optional[str] = None
    objectives: Optional[str] = None
    outcomes: Optional[str] = None
    textbooks: Optional[str] = None
    references: Optional[str] = None
    prerequisites: Optional[str] = None
    co_po_mapping: Optional[str] = None
    co_k_levels: Optional[str] = None
    is_active: Optional[bool] = None

class CourseResponse(CourseBase):
    id: int
    is_active: bool
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
