import os
from sqlalchemy import create_engine, text
from app.core.config import get_settings

settings = get_settings()
engine = create_engine(settings.DATABASE_URL)

with engine.connect() as conn:
    try:
        conn.execute(text("ALTER TABLE courses ADD COLUMN syllabus TEXT;"))
        print("Added syllabus column to courses table")
    except Exception as e:
        print("Error on adding syllabus column:", e)
    conn.commit()
print("Done")
