import os
import sys
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from app.core.database import engine, Base
from app.models import *
from sqlalchemy import inspect, text

def sync_schema():
    inspector = inspect(engine)
    existing_tables = inspector.get_table_names()

    # Make sure all tables exist
    Base.metadata.create_all(bind=engine)

    with engine.connect() as conn:
        for table_name, table in Base.metadata.tables.items():
            if table_name not in existing_tables:
                continue

            existing_cols = {c["name"]: c for c in inspector.get_columns(table_name)}
            
            for col in table.columns:
                if col.name not in existing_cols:
                    # Determine column type
                    col_type = col.type.compile(engine.dialect)
                    nullable = "NULL" if col.nullable else "NOT NULL"
                    default_str = ""
                    if col.server_default is not None:
                        default_str = f" DEFAULT {col.server_default.arg}"
                    elif col.default is not None and col.default.is_scalar:
                        default_str = f" DEFAULT '{col.default.arg}'"
                    
                    sql = f'ALTER TABLE "{table_name}" ADD COLUMN "{col.name}" {col_type} {nullable}{default_str}'
                    print(f"Executing: {sql}")
                    try:
                        conn.execute(text(sql))
                        conn.commit()
                        print(f"Successfully added column {col.name} to {table_name}")
                    except Exception as e:
                        print(f"Failed to add column {col.name} to {table_name}: {e}")

if __name__ == "__main__":
    sync_schema()
