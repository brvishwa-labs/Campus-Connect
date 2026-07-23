"""
Migration: Ensure project_guidelines, project_teams_data, and seminar_topics_data columns exist in courses table.
Run: python migrate_project_teams_seminar.py
"""
import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

from app.core.database import engine
from sqlalchemy import text

print("Running project_teams_seminar migration for courses table...")

with engine.connect() as conn:
    columns_to_add = [
        ('project_guidelines', 'TEXT'),
        ('project_teams_data', 'TEXT'),
        ('seminar_topics_data', 'TEXT'),
    ]
    for col_name, col_type in columns_to_add:
        result = conn.execute(text(f"""
            SELECT column_name 
            FROM information_schema.columns 
            WHERE table_name = 'courses' AND column_name = '{col_name}'
        """))
        exists = result.fetchone()
        
        if exists:
            print(f"Column '{col_name}' already exists. Skipping.")
        else:
            conn.execute(text(f'ALTER TABLE courses ADD COLUMN {col_name} {col_type}'))
            conn.commit()
            print(f"SUCCESS: Column '{col_name}' added to courses table.")

print("Migration complete.")
