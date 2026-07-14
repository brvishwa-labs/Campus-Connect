import sys
import os

# Add the backend directory to sys.path so we can import from app
backend_dir = os.path.dirname(os.path.abspath(__file__))
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

from dotenv import load_dotenv
# Load environment variables (like DATABASE_URL)
load_dotenv(os.path.join(backend_dir, '.env'))

from sqlalchemy import create_engine, text
from app.core.config import get_settings

def migrate():
    settings = get_settings()
    engine = create_engine(settings.DATABASE_URL)
    
    with engine.connect() as conn:
        try:
            # Check if column exists
            result = conn.execute(text("""
                SELECT column_name 
                FROM information_schema.columns 
                WHERE table_name='courses' AND column_name='co_k_levels';
            """))
            if result.fetchone():
                print("Column 'co_k_levels' already exists in 'courses' table.")
            else:
                print("Adding 'co_k_levels' column to 'courses' table...")
                conn.execute(text("ALTER TABLE courses ADD COLUMN co_k_levels TEXT;"))
                conn.commit()
                print("Migration successful.")
        except Exception as e:
            print(f"Migration failed: {e}")
            sys.exit(1)

if __name__ == "__main__":
    migrate()
