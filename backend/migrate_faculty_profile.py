from sqlalchemy import text
from app.core.database import engine

print("Connecting to PostgreSQL database...")

columns_to_add = [
    ("pan_card", "VARCHAR(50)"),
    ("aadhar_number", "VARCHAR(12)"),
    ("accommodation", "VARCHAR(50)"),
    ("transportation", "VARCHAR(50)"),
    ("bus_number", "VARCHAR(50)"),
    ("mother_name", "VARCHAR(150)"),
    ("father_name", "VARCHAR(150)"),
    ("emergency_contacts", "JSON"),
    ("academic_history", "JSON")
]

with engine.connect() as conn:
    for col_name, col_type in columns_to_add:
        # Check if column exists
        res = conn.execute(text(
            "SELECT column_name FROM information_schema.columns "
            "WHERE table_name='faculty' AND column_name=:col"
        ), {"col": col_name}).fetchone()
        
        if not res:
            print(f"Adding column '{col_name}' to 'faculty' table...")
            conn.execute(text(f"ALTER TABLE faculty ADD COLUMN {col_name} {col_type}"))
        else:
            print(f"Column '{col_name}' already exists in 'faculty' table.")

    # Check if employment_type exists
    res = conn.execute(text(
        "SELECT column_name FROM information_schema.columns "
        "WHERE table_name='faculty' AND column_name='employment_type'"
    )).fetchone()
    
    if res:
        print("Dropping column 'employment_type' from 'faculty' table...")
        conn.execute(text("ALTER TABLE faculty DROP COLUMN employment_type"))
    else:
        print("Column 'employment_type' already dropped.")

    conn.commit()
    print("Migration successful.")
