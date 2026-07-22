import os
from sqlalchemy import create_engine, text

DATABASE_URL = "postgresql://postgres:admin@localhost:5432/campus_connect"
engine = create_engine(DATABASE_URL)

alter_statements = [
    "ALTER TABLE students ADD COLUMN IF NOT EXISTS guardian_name VARCHAR(150);",
    "ALTER TABLE students ADD COLUMN IF NOT EXISTS guardian_phone VARCHAR(15);",
    "ALTER TABLE students ADD COLUMN IF NOT EXISTS guardian_occupation VARCHAR(100);",
    "ALTER TABLE students ADD COLUMN IF NOT EXISTS primary_contact VARCHAR(20);"
]

with engine.connect() as conn:
    for stmt in alter_statements:
        try:
            conn.execute(text(stmt))
            print(f"Executed: {stmt}")
        except Exception as e:
            print(f"Failed to execute {stmt}: {e}")
    conn.commit()
    print("Database migration complete.")
