import os
from app.core.database import engine, Base

# Import all models so they are registered with Base.metadata
from app.models import *

def init_db():
    print("Creating database tables...")
    Base.metadata.create_all(bind=engine)
    print("Database tables created successfully!")

if __name__ == "__main__":
    init_db()
