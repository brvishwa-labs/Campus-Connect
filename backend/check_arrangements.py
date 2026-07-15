from app.core.database import SessionLocal
from app.models.leave import FacultyDutyArrangement, FacultyLeaveRequest
db = SessionLocal()
arrs = db.query(FacultyDutyArrangement).all()
for a in arrs:
    print(f"ID: {a.id}, ReqID: {a.leave_request_id}, SubFaculty: {a.substitute_faculty_id}, Subject: {a.subject}, Status: {a.status}")
db.close()
