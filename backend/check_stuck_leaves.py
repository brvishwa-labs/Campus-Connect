import sys
import os

# Add backend to path so we can import app modules
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy.orm import Session
from app.core.database import engine
from app.models.leave import FacultyLeaveRequest, LeaveStatus, ArrangementStatus

def main():
    print("Checking for stuck leave requests...")
    with Session(engine) as db:
        stuck_requests = db.query(FacultyLeaveRequest).filter(
            FacultyLeaveRequest.status == LeaveStatus.PENDING_ALTERNATE_HOD
        ).all()
        
        for req in stuck_requests:
            print(f"Req {req.id} from faculty {req.faculty_id}, status: {req.status}")
            all_accepted = all(a.status == ArrangementStatus.ACCEPTED for a in req.arrangements)
            print(f"  All arrangements accepted? {all_accepted}")
            
            if all_accepted:
                req.status = LeaveStatus.PENDING_DEAN
                db.commit()
                print(f"  -> Fixed req {req.id}, moved to PENDING_DEAN")

if __name__ == "__main__":
    main()
