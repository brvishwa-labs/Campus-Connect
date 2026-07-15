import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import dotenv
dotenv.load_dotenv(os.path.join(os.path.dirname(__file__), '..', '.env'))

from app.core.database import engine
from app.models.base import Base
import app.models.__init__  # This imports all models

print("Creating tables...")
Base.metadata.create_all(bind=engine)
print("Tables created successfully!")
