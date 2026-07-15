"""Test API call for get_my_courses"""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from app.core.database import SessionLocal
from app.models.user import User
from app.api.faculty import get_my_courses
import json

db = SessionLocal()
user = db.query(User).filter(User.email.ilike("%cseanbus%")).first()

if not user:
    print("User not found")
    sys.exit(1)

# Set date to today (2026-07-16) - note: the API uses date_type.today() internally, 
# so we might need to mock date.today() if it doesn't match, but the system date is 2026-07-16.
try:
    courses = get_my_courses(db=db, current_user=user)
    print("SUCCESS: Returned courses")
    for c in courses:
        print(f"- id={c['id']}, course_code={c['course']['code']}, is_substitute={c['is_substitute']}, original_faculty={c['original_faculty_name']}")
except Exception as e:
    import traceback
    traceback.print_exc()

db.close()
