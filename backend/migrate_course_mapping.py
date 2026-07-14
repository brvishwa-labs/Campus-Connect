"""
Migration: Add co_po_mapping column to courses table.
Run: python migrate_course_mapping.py
"""
import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

from app.core.database import engine
from sqlalchemy import text

print("Running CO-PO mapping migration...")

with engine.connect() as conn:
    # Check if column exists
    result = conn.execute(text("""
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_name = 'courses' AND column_name = 'co_po_mapping'
    """))
    exists = result.fetchone()
    
    if exists:
        print("Column 'co_po_mapping' already exists. Skipping.")
    else:
        conn.execute(text('ALTER TABLE courses ADD COLUMN co_po_mapping TEXT'))
        conn.commit()
        print("SUCCESS: Column 'co_po_mapping' added to courses table.")

print("Migration complete.")
