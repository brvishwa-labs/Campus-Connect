import sqlite3
import os

DB_PATH = os.path.join(os.path.dirname(__file__), "campus_connect.db")

def migrate():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    try:
        # Check if column exists
        cursor.execute("PRAGMA table_info(sections)")
        columns = [info[1] for info in cursor.fetchall()]
        
        if 'batch' in columns:
            print("Dropping 'batch' column from 'sections' table...")
            cursor.execute("ALTER TABLE sections DROP COLUMN batch")
            conn.commit()
            print("Successfully dropped 'batch' column.")
        else:
            print("Column 'batch' does not exist in 'sections' table. Already migrated.")
            
    except sqlite3.OperationalError as e:
        print(f"Error dropping column directly: {e}")
        print("Falling back to table recreation...")
        
        # SQLite older than 3.35 workaround
        try:
            cursor.execute("BEGIN TRANSACTION;")
            
            # Create a new table without the batch column
            cursor.execute('''
                CREATE TABLE sections_new (
                    id INTEGER NOT NULL PRIMARY KEY,
                    department_id INTEGER NOT NULL,
                    name VARCHAR(10) NOT NULL,
                    year INTEGER NOT NULL,
                    class_advisor_id INTEGER,
                    is_active BOOLEAN,
                    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY(department_id) REFERENCES departments (id),
                    FOREIGN KEY(class_advisor_id) REFERENCES faculty (id)
                )
            ''')
            
            # Copy data
            cursor.execute('''
                INSERT INTO sections_new (id, department_id, name, year, class_advisor_id, is_active, created_at)
                SELECT id, department_id, name, year, class_advisor_id, is_active, created_at
                FROM sections
            ''')
            
            # Drop old table
            cursor.execute("DROP TABLE sections")
            
            # Rename new table to old table
            cursor.execute("ALTER TABLE sections_new RENAME TO sections")
            
            # Recreate indexes if any
            cursor.execute("CREATE INDEX ix_sections_id ON sections (id)")
            
            conn.commit()
            print("Successfully migrated using table recreation workaround.")
        except Exception as fallback_e:
            conn.rollback()
            print(f"Fallback migration failed: {fallback_e}")
            
    finally:
        conn.close()

if __name__ == "__main__":
    migrate()
