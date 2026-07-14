from app.core.database import SessionLocal
from app.models.academic import Course

db = SessionLocal()
try:
    # Get first course
    course = db.query(Course).first()
    if course:
        print(f"Found course: {course.name} (Code: {course.code})")
        print(f"Current syllabus: {course.syllabus}")
        
        # Modify syllabus
        old_syllabus = course.syllabus
        course.syllabus = "Test Syllabus Updated"
        db.commit()
        db.refresh(course)
        print(f"Updated syllabus in DB: {course.syllabus}")
        
        # Reset back
        course.syllabus = old_syllabus
        db.commit()
        print("Restored original syllabus")
    else:
        print("No courses found to test")
finally:
    db.close()
