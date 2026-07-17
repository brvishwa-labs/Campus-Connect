from app.core.database import SessionLocal
from app.models.leave import FacultyLeaveRequest
db = SessionLocal()
req = db.query(FacultyLeaveRequest).all()
for r in req:
    print(f"ID: {r.id}, Faculty: {r.faculty_id}, Type: {r.leave_type}, Status: {r.status}")
db.close()
