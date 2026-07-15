import urllib.request
import urllib.parse
import json

from app.core.database import SessionLocal
from app.models.user import User
from app.models.faculty import Faculty
db = SessionLocal()
andal = db.query(Faculty).filter(Faculty.id == 21).first()
user = db.query(User).filter(User.id == andal.user_id).first()
print(f"Andal email: {user.email}")
db.close()

# Login using urllib
url = "http://127.0.0.1:8000/api/auth/login"
data = urllib.parse.urlencode({"username": user.email, "password": "password"}).encode()
req = urllib.request.Request(url, data=data, method="POST")
try:
    with urllib.request.urlopen(req) as response:
        res_data = json.loads(response.read().decode())
        token = res_data["access_token"]
        print("Logged in successfully!")
except Exception as e:
    print("Login failed with default password, trying alternative...")
    data = urllib.parse.urlencode({"username": user.email, "password": "password123"}).encode()
    req = urllib.request.Request(url, data=data, method="POST")
    with urllib.request.urlopen(req) as response:
        res_data = json.loads(response.read().decode())
        token = res_data["access_token"]
        print("Logged in successfully!")

# Get leave preparation data
url_prep = "http://127.0.0.1:8000/api/leave/leave-preparation-data?from_date=2026-07-23&to_date=2026-07-23"
req_prep = urllib.request.Request(url_prep, headers={"Authorization": f"Bearer {token}"})
with urllib.request.urlopen(req_prep) as response:
    data = json.loads(response.read().decode())
    print("available_faculty sample:")
    for f in data.get("available_faculty", [])[:3]:
        print(f)
    print("my_schedule sample:")
    for item in data.get("my_schedule", []):
        print(f"Day: {item.get('day')}, Course: {item.get('course_code')}")
        print("available_substitutes:")
        for sub in item.get("available_substitutes", []):
            print(f"  - {sub['name']} (ID: {sub['id']}), Course: {sub.get('course_code')}, department_id: {sub.get('department_id')}")
