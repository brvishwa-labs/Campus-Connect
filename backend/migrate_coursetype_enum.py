import os
from sqlalchemy import create_engine, text

from dotenv import load_dotenv
load_dotenv()

DATABASE_URL = os.environ.get("DATABASE_URL")
engine = create_engine(DATABASE_URL)

def run():
    with engine.connect().execution_options(isolation_level="AUTOCOMMIT") as conn:
        try:
            conn.execute(text("ALTER TYPE coursetype ADD VALUE IF NOT EXISTS 'GLOBAL';"))
            conn.execute(text("ALTER TYPE coursetype ADD VALUE IF NOT EXISTS 'global';"))
            print("Successfully added 'GLOBAL' and 'global' to CourseType Enum.")
        except Exception as e:
            print(f"Error: {e}")

if __name__ == "__main__":
    run()
