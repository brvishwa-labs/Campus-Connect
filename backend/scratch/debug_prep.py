from app.core.database import SessionLocal
from app.models.faculty import Faculty
from app.models.academic import CourseAssignment, Course, Section
from app.models.user import User
from app.models.department import Department
from app.api.leave import get_leave_preparation_data

db = SessionLocal()

# Find the faculty who teaches CSOE802 to CSE Year-4 A
csoe = db.query(Course).filter(Course.code == "CSOE802").first()
sec = db.query(Section).filter(Section.name == "A", Section.year == 4).first()
if csoe and sec:
    assign = db.query(CourseAssignment).filter(CourseAssignment.course_id == csoe.id, CourseAssignment.section_id == sec.id, CourseAssignment.is_active == True).first()
    if assign:
        fac = db.query(Faculty).filter(Faculty.id == assign.faculty_id).first()
        print(f"CSOE802 teacher: {fac.first_name} {fac.last_name} (ID: {fac.id})")
        user = db.query(User).filter(User.id == fac.user_id).first()
        
        # Now mock get_leave_preparation_data
        data = get_leave_preparation_data(from_date="2026-07-20", to_date="2026-07-20", db=db, current_user=user)
        print("Schedule items:")
        for item in data["my_schedule"]:
            print(f"Day: {item['day']}, Course: {item['course_code']}, Class: {item['class_section']}")
            print("Available substitutes:")
            for sub in item["available_substitutes"]:
                print(f"  - {sub['name']} (ID: {sub['id']}), Course: {sub.get('course_code')}")
    else:
        print("Assignment not found")
else:
    print("Course or Section not found")

db.close()
