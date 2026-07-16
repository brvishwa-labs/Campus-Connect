from sqlalchemy import text
from app.core.database import engine

def migrate():
    with engine.begin() as conn:
        try:
            conn.execute(text("ALTER TABLE course_plan_topics ADD COLUMN experiment_name VARCHAR(500)"))
            print("Added experiment_name column successfully.")
        except Exception as e:
            print(f"Error adding experiment_name: {e}")

        try:
            conn.execute(text("ALTER TABLE course_plan_topics ADD COLUMN resources VARCHAR(500)"))
            print("Added resources column successfully.")
        except Exception as e:
            print(f"Error adding resources: {e}")

if __name__ == "__main__":
    migrate()
