import os
import sys

# Add the project root to the Python path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__))))

from app.core.database import engine, Base
from app.models.user import PasswordResetRequest

def migrate():
    print("Creating password_reset_requests table...")
    PasswordResetRequest.__table__.create(bind=engine, checkfirst=True)
    print("Migration successful.")

if __name__ == "__main__":
    migrate()
