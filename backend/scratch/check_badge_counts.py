import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import dotenv
dotenv.load_dotenv(os.path.join(os.path.dirname(__file__), '..', '.env'))

from app.core.database import SessionLocal
from app.models.user import User, UserRole
from app.models.authority import Authority
from app.models.gatepass import GatePass, GatePassStatus

db = SessionLocal()

emails = ['om@svcet.ac.in', 'om@gmail.com', 'om.test@svcet.ac.in']
for email in emails:
    user = db.query(User).filter(User.email == email).first()
    if not user:
        continue

    print(f"\nUser: {user.email}, Role: {user.role}")

    auth = db.query(Authority).filter(Authority.user_id == user.id).first()
    if auth:
        title = auth.title.lower().strip()
        print(f"Title: {title}")
        
        if "manager" in title or "principal" in title:
            q = db.query(GatePass).filter(
                GatePass.status == GatePassStatus.PENDING_OM,
                GatePass.is_deleted_by_student == False
            )
            count = q.count()
            print(f"OM Gatepass Count: {count}")
    else:
        print("No authority profile found.")
