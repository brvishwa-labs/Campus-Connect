import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.core.database import SessionLocal
from app.models.department import Department
from app.models.student import Student
from app.models.faculty import Faculty
from app.models.user import User
from app.models.attendance import Attendance, FacultyAttendance
from app.models.grade import Grade
from app.models.late import LateRecord, LateEntryNotification
from app.models.discipline import DisciplineRecord
from app.models.gatepass import GatePass, FacultyGatePass
from app.models.leave import StudentLeaveRequest, FacultyLeaveRequest, FacultyDutyArrangement, FacultyLeaveBalance
from app.models.messaging import Conversation, Message
from app.models.mentorship import MentoringMeeting, AdvisingLog
from app.models.academic import CourseAssignment, Enrollment, MentorAssignment, Section
from app.models.course_plan import CoursePlan, CoursePlanTopic
from app.models.lms import TimetableSlot, LMSResource
from app.models.retest import RetestMark

def hard_delete_cse():
    db = SessionLocal()
    try:
        # Find CSE department
        dept = db.query(Department).filter(Department.name == "Computer Science and Engineering").first()
        if not dept:
            print("CSE department not found.")
            return

        print(f"Starting hard deletion for CSE (ID: {dept.id})...")

        # Get all Student IDs and User IDs
        cse_students = db.query(Student).filter(Student.department_id == dept.id).all()
        student_ids = [s.id for s in cse_students]
        student_user_ids = [s.user_id for s in cse_students]
        
        # Get all Faculty IDs and User IDs
        cse_faculties = db.query(Faculty).filter(Faculty.department_id == dept.id).all()
        faculty_ids = [f.id for f in cse_faculties]
        faculty_user_ids = [f.user_id for f in cse_faculties]

        print(f"Found {len(student_ids)} students and {len(faculty_ids)} faculty.")

        if student_ids:
            # Delete dependent records for Students
            deleted = db.query(Attendance).filter(Attendance.student_id.in_(student_ids)).delete(synchronize_session=False)
            print(f"Deleted {deleted} Student Attendance records.")

            deleted = db.query(Grade).filter(Grade.student_id.in_(student_ids)).delete(synchronize_session=False)
            print(f"Deleted {deleted} Grade records.")

            deleted = db.query(RetestMark).filter(RetestMark.student_id.in_(student_ids)).delete(synchronize_session=False)
            print(f"Deleted {deleted} RetestMark records.")

            deleted = db.query(LateRecord).filter(LateRecord.student_id.in_(student_ids)).delete(synchronize_session=False)
            print(f"Deleted {deleted} LateRecord records.")
            deleted = db.query(LateEntryNotification).filter(LateEntryNotification.student_id.in_(student_ids)).delete(synchronize_session=False)
            print(f"Deleted {deleted} LateEntryNotification records.")

            deleted = db.query(DisciplineRecord).filter(DisciplineRecord.student_id.in_(student_ids)).delete(synchronize_session=False)
            print(f"Deleted {deleted} Discipline records.")

            deleted = db.query(StudentLeaveRequest).filter(StudentLeaveRequest.student_id.in_(student_ids)).delete(synchronize_session=False)
            print(f"Deleted {deleted} Student Leave Requests.")

            deleted = db.query(Enrollment).filter(Enrollment.student_id.in_(student_ids)).delete(synchronize_session=False)
            print(f"Deleted {deleted} Enrollments.")

        if faculty_ids:
            # Delete dependent records for Faculty
            deleted = db.query(FacultyAttendance).filter(FacultyAttendance.faculty_id.in_(faculty_ids)).delete(synchronize_session=False)
            print(f"Deleted {deleted} Faculty Attendance records.")

            deleted = db.query(FacultyDutyArrangement).filter(
                (FacultyDutyArrangement.substitute_faculty_id.in_(faculty_ids)) | 
                (FacultyDutyArrangement.leave_request_id.in_(
                    db.query(FacultyLeaveRequest.id).filter(FacultyLeaveRequest.faculty_id.in_(faculty_ids))
                ))
            ).delete(synchronize_session=False)
            print(f"Deleted {deleted} Faculty Duty Arrangements.")

            deleted = db.query(FacultyLeaveRequest).filter(FacultyLeaveRequest.faculty_id.in_(faculty_ids)).delete(synchronize_session=False)
            print(f"Deleted {deleted} Faculty Leave Requests.")

            deleted = db.query(FacultyLeaveBalance).filter(FacultyLeaveBalance.faculty_id.in_(faculty_ids)).delete(synchronize_session=False)
            print(f"Deleted {deleted} Faculty Leave Balances.")

            # Course Assignments & Timetable Slots
            course_assignments = db.query(CourseAssignment).filter(CourseAssignment.faculty_id.in_(faculty_ids)).all()
            ca_ids = [ca.id for ca in course_assignments]
            if ca_ids:
                # Delete Course Plans and their dependencies
                course_plans = db.query(CoursePlan).filter(CoursePlan.course_assignment_id.in_(ca_ids)).all()
                cp_ids = [cp.id for cp in course_plans]
                if cp_ids:
                    deleted = db.query(CoursePlanTopic).filter(CoursePlanTopic.course_plan_id.in_(cp_ids)).delete(synchronize_session=False)
                    print(f"Deleted {deleted} Course Plan Topics.")
                    deleted = db.query(CoursePlan).filter(CoursePlan.id.in_(cp_ids)).delete(synchronize_session=False)
                    print(f"Deleted {deleted} Course Plans.")

                deleted = db.query(TimetableSlot).filter(TimetableSlot.course_assignment_id.in_(ca_ids)).delete(synchronize_session=False)
                print(f"Deleted {deleted} Timetable Slots.")
                deleted = db.query(CourseAssignment).filter(CourseAssignment.faculty_id.in_(faculty_ids)).delete(synchronize_session=False)
                print(f"Deleted {deleted} Course Assignments.")

        if student_ids or faculty_ids:
            # Gate passes & Mentor Assignments & Logs
            if student_ids:
                deleted = db.query(GatePass).filter(GatePass.student_id.in_(student_ids)).delete(synchronize_session=False)
                print(f"Deleted {deleted} Student Gate Passes.")
            
            if faculty_ids:
                deleted = db.query(FacultyGatePass).filter(FacultyGatePass.faculty_id.in_(faculty_ids)).delete(synchronize_session=False)
                print(f"Deleted {deleted} Faculty Gate Passes.")
                
                # Also delete gate passes where faculty was an approver to avoid FK issues
                deleted = db.query(GatePass).filter((GatePass.mentor_id.in_(faculty_ids)) | (GatePass.hod_id.in_(faculty_ids))).delete(synchronize_session=False)
                print(f"Deleted {deleted} Gate Passes approved by CSE Faculty.")
                
                deleted = db.query(FacultyGatePass).filter(FacultyGatePass.hod_id.in_(faculty_ids)).delete(synchronize_session=False)
                print(f"Deleted {deleted} Faculty Gate Passes approved by CSE HOD.")

            deleted = db.query(MentoringMeeting).filter(
                (MentoringMeeting.student_id.in_(student_ids)) | (MentoringMeeting.mentor_id.in_(faculty_ids))
            ).delete(synchronize_session=False)
            print(f"Deleted {deleted} Mentoring Meetings.")

            deleted = db.query(AdvisingLog).filter(
                (AdvisingLog.student_id.in_(student_ids)) | (AdvisingLog.mentor_id.in_(faculty_ids))
            ).delete(synchronize_session=False)
            print(f"Deleted {deleted} Advising Logs.")
            
            if student_ids:
                conversations = db.query(Conversation).filter(Conversation.student_id.in_(student_ids)).all()
                conv_ids = [c.id for c in conversations]
                if conv_ids:
                    deleted = db.query(Message).filter(Message.conversation_id.in_(conv_ids)).delete(synchronize_session=False)
                    print(f"Deleted {deleted} Messages.")
                    deleted = db.query(Conversation).filter(Conversation.id.in_(conv_ids)).delete(synchronize_session=False)
                    print(f"Deleted {deleted} Conversations.")

            mentor_query = db.query(MentorAssignment).filter(
                (MentorAssignment.student_id.in_(student_ids)) | (MentorAssignment.mentor_id.in_(faculty_ids))
            )
            deleted = mentor_query.delete(synchronize_session=False)
            print(f"Deleted {deleted} Mentor Assignments.")

        # Delete profiles
        if student_ids:
            deleted = db.query(Student).filter(Student.department_id == dept.id).delete(synchronize_session=False)
            print(f"Deleted {deleted} Student profiles.")

        if faculty_ids:
            deleted = db.query(LMSResource).filter(LMSResource.uploaded_by_id.in_(faculty_ids)).delete(synchronize_session=False)
            print(f"Deleted {deleted} LMS Resources.")
            updated = db.query(Section).filter(Section.class_advisor_id.in_(faculty_ids)).update({"class_advisor_id": None}, synchronize_session=False)
            print(f"Removed Class Advisor from {updated} sections.")
            updated = db.query(Department).filter(Department.hod_id.in_(faculty_ids)).update({"hod_id": None}, synchronize_session=False)
            print(f"Removed HOD from {updated} departments.")
            deleted = db.query(Faculty).filter(Faculty.department_id == dept.id).delete(synchronize_session=False)
            print(f"Deleted {deleted} Faculty profiles.")

        # Delete Users
        user_ids = student_user_ids + faculty_user_ids
        if user_ids:
            deleted = db.query(User).filter(User.id.in_(user_ids)).delete(synchronize_session=False)
            print(f"Deleted {deleted} User accounts.")

        db.commit()
        print("Successfully committed hard deletion to database.")

    except Exception as e:
        db.rollback()
        print(f"Error during hard delete: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    hard_delete_cse()
