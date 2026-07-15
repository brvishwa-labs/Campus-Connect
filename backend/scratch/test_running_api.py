import urllib.request
import json
from app.core.database import SessionLocal
from app.models.user import User
from app.models.faculty import Faculty
from app.core.security import create_access_token

db = SessionLocal()
andal = db.query(Faculty).filter(Faculty.id == 21).first()
user = db.query(User).filter(User.id == andal.user_id).first()
print(f"Andal ID: {andal.id}, User ID: {user.id}, Email: {user.email}")

# Generate token directly
token = create_access_token({"sub": str(user.id)})
db.close()

# Get leave preparation data from the running FastAPI server on port 8000
url_prep = "http://127.0.0.1:8000/api/leave/leave-preparation-data?from_date=2026-07-23&to_date=2026-07-23"
req_prep = urllib.request.Request(url_prep, headers={"Authorization": f"Bearer {token}"})

try:
    with urllib.request.urlopen(req_prep) as response:
        data = json.loads(response.read().decode())
        print("\nSUCCESS! Response from running server:")
        print("available_faculty sample:")
        for f in data.get("available_faculty", [])[:3]:
            print(f)
except Exception as e:
    print("API request failed:", e)
