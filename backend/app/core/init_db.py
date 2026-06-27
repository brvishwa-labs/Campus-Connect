"""
Database initialization script.
Run this to create all tables in the campus_connect database.

Usage: python -m app.core.init_db
"""

from app.core.database import engine, Base

# This import triggers all model registrations via __init__.py
import app.models  # noqa: F401


def init_db():
    """Create all tables defined in our ORM models."""
    print("Creating all database tables...")
    Base.metadata.create_all(bind=engine)
    print("[OK] All tables created successfully!")
    
    # Print the list of tables created
    for table_name in Base.metadata.tables:
        print(f"  -> {table_name}")


if __name__ == "__main__":
    init_db()
