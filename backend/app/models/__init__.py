"""
Campus Connect ERP — Central Model Registry

Import all models here so SQLAlchemy's `Base.metadata` sees every table.
Any new model file must be imported in this module.
"""

# Core
from app.models.user import User, UserRole
from app.models.department import Department, ProgramOutcome
from app.models.faculty import Faculty
from app.models.student import Student
from app.models.authority import Authority
from app.models.alumni import Alumni
from app.models.discipline import DisciplineRecord
from app.models.late import LateRecord
from app.models.gatepass import GatePass, GatePassStatus
from app.models.notification_view import NotificationView

# Academic
from app.models.academic import (
    Section,
    Course, CourseType,
    CourseAssignment,
    Enrollment,
    MentorAssignment,
)

# Mentorship
from app.models.mentorship import MentoringMeeting, MeetingStatus, AdvisingLog

# Operations
from app.models.attendance import Attendance, AttendanceStatus, Holiday
from app.models.leave import (
    FacultyLeaveRequest, FacultyDutyArrangement, FacultyLeaveBalance,
    StudentLeaveRequest, StudentLeaveStatus,
    LeaveStatus, ArrangementStatus,
)
from app.models.grade import Grade, GradeType, AssignmentGrade, Seminar
from app.models.lms import LMSResource, ResourceType, Announcement, TimetableSlot, DayOfWeek
from app.models.course_plan import CoursePlan, CoursePlanTopic
from app.models.messaging import Conversation, Message
from app.models.notification_view import NotificationView

__all__ = [
    "User", "UserRole",
    "Department", "ProgramOutcome",
    "Faculty",
    "Student",
    "Authority",
    "Alumni",
    "DisciplineRecord",
    "LateRecord",
    "GatePass", "GatePassStatus",
    "Section",
    "Course", "CourseType",
    "CourseAssignment",
    "Enrollment",
    "MentorAssignment",
    "MentoringMeeting", "MeetingStatus", "AdvisingLog",
    "Attendance", "AttendanceStatus", "Holiday",
    "FacultyLeaveRequest", "FacultyDutyArrangement", "FacultyLeaveBalance",
    "StudentLeaveRequest", "StudentLeaveStatus",
    "LeaveStatus", "ArrangementStatus",
    "Grade", "GradeType", "AssignmentGrade", "Seminar",
    "LMSResource", "ResourceType",
    "Announcement",
    "TimetableSlot", "DayOfWeek",
    "CoursePlan", "CoursePlanTopic",
    "Conversation", "Message",
    "NotificationView",
]
