import sqlite3
import os

def migrate():
    # Database path
    db_path = "app.db"
    if not os.path.exists(db_path):
        print(f"Database {db_path} not found!")
        return

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    try:
        cursor.execute("ALTER TABLE course_plan_topics ADD COLUMN experiment_name VARCHAR(500)")
        print("Added experiment_name column successfully.")
    except sqlite3.OperationalError as e:
        if "duplicate column name" in str(e).lower():
            print("Column experiment_name already exists.")
        else:
            print(f"Error adding experiment_name: {e}")

    try:
        cursor.execute("ALTER TABLE course_plan_topics ADD COLUMN resources VARCHAR(500)")
        print("Added resources column successfully.")
    except sqlite3.OperationalError as e:
        if "duplicate column name" in str(e).lower():
            print("Column resources already exists.")
        else:
            print(f"Error adding resources: {e}")

    conn.commit()
    conn.close()
    print("Migration complete.")

if __name__ == "__main__":
    migrate()
