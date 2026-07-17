from sqlalchemy import create_engine
from app.core.config import get_settings
from app.models.leave import Base, RestrictedHoliday

settings = get_settings()

def run_migration():
    engine = create_engine(settings.DATABASE_URL)
    print("Creating restricted_holidays table if it does not exist...")
    RestrictedHoliday.__table__.create(engine, checkfirst=True)
    print("Successfully created restricted_holidays table.")

if __name__ == "__main__":
    run_migration()
