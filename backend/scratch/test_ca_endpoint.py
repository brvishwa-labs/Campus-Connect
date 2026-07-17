import os
import sys

sys.path.append(r"c:\Users\ADVANCED COMPUTING\Desktop\Campus-Connect\backend")

from app.core.database import SessionLocal
from app.api.class_advisor import get_timetable
from app.models.user import User
from app.models.faculty import Faculty

def test_endpoint():
    db = SessionLocal()
    fac = db.query(Faculty).filter(Faculty.first_name.ilike("%Loganathan%")).first()
    user = db.query(User).filter(User.id == fac.user_id).first()
    
    result = get_timetable(date="2026-07-13", db=db, current_user=user)
    
    print("Printing first 5 slots returned by get_timetable:")
    for slot in result[:5]:
        print(f"Slot ID: {slot.id} | Day: '{slot.day}' | Start: '{slot.start_time}'")

if __name__ == "__main__":
    test_endpoint()
