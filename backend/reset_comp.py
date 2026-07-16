from app.core.database import SessionLocal
from app.models.leave import FacultyLeaveBalance
db = SessionLocal()
db.query(FacultyLeaveBalance).update({'compensation_leaves_total': 0})
db.commit()
db.close()
print('Successfully reset compensation_leaves_total to 0 for all faculty.')
