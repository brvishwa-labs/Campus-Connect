import os
import sys
from sqlalchemy import create_engine, text

# Add the parent directory to Python path so we can import from app
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# pyrefly: ignore [missing-import]
from app.core.config import get_settings

def run_migration():
    settings = get_settings()   
    print(f"Connecting to database: {settings.DATABASE_URL.split('@')[-1]}")
    engine = create_engine(settings.DATABASE_URL)
    
    with engine.connect() as conn:
        # Add day column
        try:
            conn.execute(text("ALTER TABLE faculty_duty_arrangements ADD COLUMN day VARCHAR(10);"))
            print("Successfully added 'day' column to faculty_duty_arrangements")
        except Exception as e:
            print("Notice or error adding 'day' column:", e)
            
        # Add compensation_date column
        try:
            conn.execute(text("ALTER TABLE faculty_duty_arrangements ADD COLUMN compensation_date DATE;"))
            print("Successfully added 'compensation_date' column to faculty_duty_arrangements")
        except Exception as e:
            print("Notice or error adding 'compensation_date' column:", e)
            
        # Add compensation_period column
        try:
            conn.execute(text("ALTER TABLE faculty_duty_arrangements ADD COLUMN compensation_period VARCHAR(50);"))
            print("Successfully added 'compensation_period' column to faculty_duty_arrangements")
        except Exception as e:
            print("Notice or error adding 'compensation_period' column:", e)
            
        conn.commit()
    print("Migration completed.")

if __name__ == "__main__":
    run_migration()
