"""
Quick fix to check and update arrangement statuses
"""
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
import os

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
engine = create_engine(DATABASE_URL)

with engine.connect() as conn:
    # Check current arrangements
    result = conn.execute(text("""
        SELECT id, leave_request_id, substitute_faculty_id, status 
        FROM faculty_duty_arrangements 
        ORDER BY id DESC 
        LIMIT 10
    """))
    
    print("Recent arrangements:")
    for row in result:
        print(f"ID: {row[0]}, Leave Request: {row[1]}, Substitute: {row[2]}, Status: {row[3]}")
    
    # Update any arrangements that have wrong status
    print("\nUpdating all recent arrangements to PENDING status...")
    conn.execute(text("""
        UPDATE faculty_duty_arrangements 
        SET status = 'PENDING'
        WHERE leave_request_id IN (
            SELECT id FROM faculty_leave_requests 
            WHERE status = 'pending_substitute'
            ORDER BY created_at DESC 
            LIMIT 5
        )
    """))
    conn.commit()
    
    print("✅ Updated! All recent pending leave request arrangements now have PENDING status.")
    
    # Verify
    result = conn.execute(text("""
        SELECT id, leave_request_id, substitute_faculty_id, status 
        FROM faculty_duty_arrangements 
        ORDER BY id DESC 
        LIMIT 10
    """))
    
    print("\nVerification - Updated arrangements:")
    for row in result:
        print(f"ID: {row[0]}, Leave Request: {row[1]}, Substitute: {row[2]}, Status: {row[3]}")
