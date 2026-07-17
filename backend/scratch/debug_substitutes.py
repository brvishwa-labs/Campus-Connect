from app.core.database import SessionLocal
from app.models.faculty import Faculty
from app.models.academic import CourseAssignment, Course, Section
from app.models.user import User

db = SessionLocal()

# Find Mrs. Saranya Vadivelu
saranya = db.query(Faculty).filter(Faculty.last_name.like("%Saranya%") | Faculty.first_name.like("%Saranya%")).first()
if saranya:
    print(f"Faculty Found: {saranya.first_name} {saranya.last_name} (ID: {saranya.id})")
    
    # Get assignments
    assignments = db.query(CourseAssignment).filter(CourseAssignment.faculty_id == saranya.id).all()
    print(f"Assignments count: {len(assignments)}")
    for a in assignments:
        course = db.query(Course).filter(Course.id == a.course_id).first()
        section = db.query(Section).filter(Section.id == a.section_id).first()
        print(f" - Assignment ID: {a.id}, Active: {a.is_active}, Course: {course.code if course else 'None'} ({course.name if course else 'None'}), Section: {section.name if section else 'None'} (Year {section.year if section else 'None'})")
else:
    print("Saranya not found")

db.close()
