import os
import sys
from sqlalchemy import create_engine, text

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.core.config import get_settings

def run_migration():
    settings = get_settings()
    print(f"Connecting to database: {settings.DATABASE_URL.split('@')[-1]}")
    # In PostgreSQL, we cannot run ALTER TYPE inside a transaction block easily.
    # We will use autocommit mode.
    engine = create_engine(settings.DATABASE_URL, isolation_level="AUTOCOMMIT")
    
    with engine.connect() as conn:
        try:
            conn.execute(text("ALTER TABLE faculty_leave_requests ADD COLUMN compensation_verifier_id INTEGER REFERENCES faculty(id);"))
            print("Successfully added 'compensation_verifier_id' column")
        except Exception as e:
            print("Notice or error adding 'compensation_verifier_id':", e)
            
        try:
            conn.execute(text("ALTER TABLE faculty_leave_requests ADD COLUMN compensation_date DATE;"))
            print("Successfully added 'compensation_date' column")
        except Exception as e:
            print("Notice or error adding 'compensation_date':", e)
            
        try:
            conn.execute(text("ALTER TABLE faculty_leave_requests ADD COLUMN compensation_purpose VARCHAR(500);"))
            print("Successfully added 'compensation_purpose' column")
        except Exception as e:
            print("Notice or error adding 'compensation_purpose':", e)
            
        try:
            conn.execute(text("ALTER TYPE leavestatus ADD VALUE 'pending_compensation_verification';"))
            print("Successfully added 'pending_compensation_verification' to leavestatus ENUM")
        except Exception as e:
            print("Notice or error adding ENUM value:", e)
            
    print("Migration completed.")

if __name__ == "__main__":
    run_migration()
