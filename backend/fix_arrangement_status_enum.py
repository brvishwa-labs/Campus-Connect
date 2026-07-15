"""
Fix ArrangementStatus enum case mismatch
Run this script to fix the enum values in the database
"""
from sqlalchemy import create_engine, text
import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
engine = create_engine(DATABASE_URL)

with engine.connect() as conn:
    # Check current enum values
    result = conn.execute(text("SELECT enum_range(NULL::arrangementstatus);"))
    current_values = result.fetchone()[0]
    print(f"Current enum values: {current_values}")
    
    # If enum has uppercase values like {PENDING,ACCEPTED,REJECTED}
    # We need to alter it to lowercase {pending,accepted,rejected}
    
    if 'PENDING' in current_values:
        print("Fixing enum values to lowercase...")
        
        # Step 1: Add new lowercase values
        conn.execute(text("ALTER TYPE arrangementstatus ADD VALUE IF NOT EXISTS 'pending';"))
        conn.execute(text("ALTER TYPE arrangementstatus ADD VALUE IF NOT EXISTS 'accepted';"))
        conn.execute(text("ALTER TYPE arrangementstatus ADD VALUE IF NOT EXISTS 'rejected';"))
        conn.commit()
        
        # Step 2: Update existing data to use lowercase
        conn.execute(text("UPDATE faculty_duty_arrangements SET status = 'pending' WHERE status = 'PENDING';"))
        conn.execute(text("UPDATE faculty_duty_arrangements SET status = 'accepted' WHERE status = 'ACCEPTED';"))
        conn.execute(text("UPDATE faculty_duty_arrangements SET status = 'rejected' WHERE status = 'REJECTED';"))
        conn.commit()
        
        print("✅ Enum values fixed! Database now uses lowercase values.")
    else:
        print("✅ Enum values are already correct (lowercase)")
