import sys
import os
sys.path.insert(0, os.getcwd())
from sqlalchemy import text
from app.core.database import engine

with engine.connect() as conn:
    res = conn.execute(text("SELECT enumlabel FROM pg_enum JOIN pg_type ON pg_enum.enumtypid = pg_type.oid WHERE pg_type.typname = 'leavestatus'")).fetchall()
    print([r[0] for r in res])
