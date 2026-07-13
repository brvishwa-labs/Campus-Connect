"""
Migration: Create the `holidays` table.

Run once:
    python migrate_holidays.py
"""

import os
from sqlalchemy import create_engine, text

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:admin@10.1.10.24:5432/campus_connect"
)

engine = create_engine(DATABASE_URL)


def migrate():
    with engine.connect() as conn:
        conn.execute(text("""
            CREATE TABLE IF NOT EXISTS holidays (
                id          SERIAL PRIMARY KEY,
                date        DATE        NOT NULL UNIQUE,
                name        VARCHAR(200) NOT NULL,
                created_by_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
                created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
            );
        """))
        conn.execute(text("CREATE INDEX IF NOT EXISTS ix_holidays_date ON holidays (date);"))
        conn.commit()
        print("OK: holidays table created (or already exists).")



if __name__ == "__main__":
    migrate()
