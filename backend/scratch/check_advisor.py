import os
import sys

sys.path.append(r"c:\Users\ADVANCED COMPUTING\Desktop\Campus-Connect\backend")

from app.core.database import SessionLocal
from app.models.faculty import Faculty
from app.models.academic import Section

def check_advisor():
    db = SessionLocal()
    fac = db.query(Faculty).filter(Faculty.first_name.ilike("%Loganathan%")).first()
    if not fac:
        print("Loganathan not found")
        return
        
    sections = db.query(Section).filter(Section.class_advisor_id == fac.id).all()
    print(f"Loganathan (ID {fac.id}) is class advisor for {len(sections)} sections.")
    for s in sections:
        print(f"Section {s.id}: {s.name}")

if __name__ == "__main__":
    check_advisor()
