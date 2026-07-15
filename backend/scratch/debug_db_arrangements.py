from app.core.database import SessionLocal
from app.models.leave import FacultyDutyArrangement

db = SessionLocal()
arrs = db.query(FacultyDutyArrangement).all()
print("Arrangements in database count:", len(arrs))
for a in arrs[:10]:
    print(f"ID: {a.id}, Subject: {a.subject}, Class Section: {a.class_section}, Period: {a.period}")
db.close()
