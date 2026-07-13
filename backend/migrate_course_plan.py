"""
Migration script to add co and po columns to course_plan_topics table,
and increase cognitive_level column length.
"""

import sys
from sqlalchemy import create_engine, text
from app.core.config import get_settings

def migrate():
    """Add co and po fields, alter cognitive_level length"""
    settings = get_settings()
    engine = create_engine(settings.DATABASE_URL)
    
    # SQL to add the new columns
    add_columns_sql = """
    ALTER TABLE course_plan_topics 
    ADD COLUMN IF NOT EXISTS co VARCHAR(100),
    ADD COLUMN IF NOT EXISTS po VARCHAR(200);
    """
    
    # SQL to alter column type length
    alter_column_sql = """
    ALTER TABLE course_plan_topics 
    ALTER COLUMN cognitive_level TYPE VARCHAR(100);
    """
    
    try:
        with engine.connect() as conn:
            conn.execute(text(add_columns_sql))
            conn.execute(text(alter_column_sql))
            conn.commit()
            print("Successfully added co and po columns and increased cognitive_level column size.")
    except Exception as e:
        print(f"Error during migration: {e}")
        sys.exit(1)

if __name__ == "__main__":
    print("Starting course plan fields migration...")
    migrate()
