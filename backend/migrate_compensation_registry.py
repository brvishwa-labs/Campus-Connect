from sqlalchemy import create_engine, text
from app.core.config import get_settings
from app.models.leave import Base, CompensationRegistryRequest

settings = get_settings()

def run_migration():
    engine = create_engine(settings.DATABASE_URL)
    
    # 1. Create the compensation_registry_requests table
    print("Creating compensation_registry_requests table if it does not exist...")
    CompensationRegistryRequest.__table__.create(engine, checkfirst=True)
    print("Successfully created compensation_registry_requests table.")
    
    # 2. Add compensation_registry_id to faculty_leave_requests
    with engine.connect() as conn:
        print("Checking if compensation_registry_id exists in faculty_leave_requests...")
        try:
            conn.execute(text("ALTER TABLE faculty_leave_requests ADD COLUMN compensation_registry_id INTEGER;"))
            conn.commit()
            print("Successfully added compensation_registry_id to faculty_leave_requests.")
        except Exception as e:
            if "already exists" in str(e) or "Duplicate column" in str(e):
                print("Column compensation_registry_id already exists.")
            else:
                print("Notice/Error while adding column:", e)

if __name__ == "__main__":
    run_migration()
