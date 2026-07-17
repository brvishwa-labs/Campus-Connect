from app.core.database import SessionLocal
from app.models.faculty import Faculty
from app.models.academic import CourseAssignment, Course, Section
from app.models.user import User
from app.models.department import Department
from app.api.leave import get_leave_preparation_data

db = SessionLocal()

# Find Andal
andal = db.query(Faculty).filter(Faculty.id == 21).first()
user = db.query(User).filter(User.id == andal.user_id).first()

# Mock get_leave_preparation_data for Thursday 2026-07-23 (which is a Thursday)
data = get_leave_preparation_data(from_date="2026-07-23", to_date="2026-07-23", db=db, current_user=user)

print("available_faculty count:", len(data["available_faculty"]))
for f in data["available_faculty"][:5]:
    print(f"Name: {f['name']}, ID: {f['id']}, teaches_same_section: {f.get('teaches_same_section')}, course_code: {f.get('course_code')}, department_id: {f.get('department_id')}")

# Check if Saranya is in available_faculty
saranya_in_all = next((f for f in data["available_faculty"] if f["id"] == 30), None)
print("Saranya in available_faculty:", saranya_in_all)

db.close()
