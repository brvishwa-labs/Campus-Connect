import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import dotenv
dotenv.load_dotenv(os.path.join(os.path.dirname(__file__), '..', '.env'))

from app.core.database import SessionLocal
from app.models.user import User
from app.api.notifications import get_badge_counts

db = SessionLocal()
user = db.query(User).filter(User.email == 'om@svcet.ac.in').first()

counts = get_badge_counts(db=db, current_user=user)
print("Badge counts for OM:")
for k, v in counts.items():
    if v > 0:
        print(f"{k}: {v}")
