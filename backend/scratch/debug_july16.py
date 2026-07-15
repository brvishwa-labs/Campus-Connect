from app.core.database import SessionLocal
from app.models.faculty import Faculty
from app.models.academic import CourseAssignment, Course, Section
from app.models.user import User
from app.models.department import Department
from app.api.leave import get_leave_preparation_data

db = SessionLocal()

# Andal is faculty ID 21
andal = db.query(Faculty).filter(Faculty.id == 21).first()
user = db.query(User).filter(User.id == andal.user_id).first()

# Let's call get_leave_preparation_data for Thursday July 16, 2026
# (Wait, let's find what day 2026-07-16 is: Thursday)
data = get_leave_preparation_data(from_date="2026-07-16", to_date="2026-07-16", db=db, current_user=user)

print("my_schedule items count:", len(data["my_schedule"]))
for item in data["my_schedule"]:
    print(f"Day: {item.get('day')}, Course: {item.get('course_code')}, Class: {item.get('class_section')}")
    print("available_substitutes:")
    for sub in item.get("available_substitutes", []):
        print(f"  - {sub['name']} (ID: {sub['id']}), Course: {sub.get('course_code')}, department_id: {sub.get('department_id')}")

db.close()
