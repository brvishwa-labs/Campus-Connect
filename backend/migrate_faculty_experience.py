from sqlalchemy import text
from app.core.database import engine

print("Adding past_experience column to PostgreSQL database...")

with engine.connect() as conn:
    res = conn.execute(text(
        "SELECT column_name FROM information_schema.columns "
        "WHERE table_name='faculty' AND column_name='past_experience'"
    )).fetchone()
    
    if not res:
        print("Adding column 'past_experience' to 'faculty' table...")
        conn.execute(text("ALTER TABLE faculty ADD COLUMN past_experience JSON"))
    else:
        print("Column 'past_experience' already exists in 'faculty' table.")

    conn.commit()
    print("Migration successful.")
