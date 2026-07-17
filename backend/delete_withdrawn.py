from app.core.database import SessionLocal
from app.models.leave import FacultyLeaveRequest, FacultyDutyArrangement, LeaveStatus
db = SessionLocal()

# Find all requests with status withdrawn
withdrawn_reqs = db.query(FacultyLeaveRequest).filter(
    FacultyLeaveRequest.status == LeaveStatus.WITHDRAWN
).all()

for req in withdrawn_reqs:
    print(f"Deleting Request ID: {req.id}")
    db.query(FacultyDutyArrangement).filter(FacultyDutyArrangement.leave_request_id == req.id).delete()
    db.delete(req)

db.commit()
db.close()
print("All withdrawn requests deleted successfully!")
