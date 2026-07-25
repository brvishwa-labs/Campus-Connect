import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy import text
from app.core.database import engine

def migrate():
    with engine.connect() as conn:
        try:
            print("Adding is_pinned and is_for_review columns to msg_conversations...")
            conn.execute(text("""
                ALTER TABLE msg_conversations 
                ADD COLUMN IF NOT EXISTS is_pinned BOOLEAN DEFAULT FALSE;
            """))
            conn.execute(text("""
                ALTER TABLE msg_conversations 
                ADD COLUMN IF NOT EXISTS is_for_review BOOLEAN DEFAULT FALSE;
            """))
            conn.commit()
            print("Migration completed successfully.")
        except Exception as e:
            conn.rollback()
            print(f"Error during migration: {e}")

if __name__ == "__main__":
    migrate()
