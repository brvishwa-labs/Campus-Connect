"""
Migration script to add user_page_views table for notification badge tracking.
Run this once to create the table.
"""

from sqlalchemy import create_engine, Column, Integer, String, DateTime, ForeignKey, text
from sqlalchemy.sql import func
from app.core.config import get_settings

settings = get_settings()

# Create engine
engine = create_engine(settings.DATABASE_URL)

# SQL to create the table
create_table_sql = """
CREATE TABLE IF NOT EXISTS user_page_views (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    page_path VARCHAR(255) NOT NULL,
    last_viewed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, page_path)
);

CREATE INDEX IF NOT EXISTS idx_user_page_views_user_id ON user_page_views(user_id);
CREATE INDEX IF NOT EXISTS idx_user_page_views_page_path ON user_page_views(page_path);
"""

if __name__ == "__main__":
    print("Creating user_page_views table...")
    with engine.connect() as conn:
        conn.execute(text(create_table_sql))
        conn.commit()
    print("✅ Table created successfully!")
