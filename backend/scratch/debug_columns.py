from app.core.database import SessionLocal
from app.models.leave import FacultyDutyArrangement
import inspect

db = SessionLocal()
columns = [c.name for c in FacultyDutyArrangement.__table__.columns]
print("FacultyDutyArrangement columns:", columns)
db.close()
