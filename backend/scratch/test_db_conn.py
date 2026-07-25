import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

db_url = os.getenv("DATABASE_URL")
print("DATABASE_URL from .env:", db_url)

print("\n--- Testing Neon DB Connection with timeout ---")
try:
    conn = psycopg2.connect(db_url, connect_timeout=3)
    print("SUCCESS connecting to Neon!")
    conn.close()
except Exception as e:
    print("FAILED to connect to Neon:", e)

print("\n--- Testing Local DB Connections with timeout ---")
local_urls = [
    "postgresql://postgres:admin@localhost:5432/campus_connect",
    "postgresql://postgres:postgres@localhost:5432/campus_connect",
    "postgresql://postgres:postgres@localhost:5432/postgres",
    "postgresql://postgres:admin@localhost:5432/postgres",
    "postgresql://postgres:@localhost:5432/postgres",
]

for url in local_urls:
    try:
        conn = psycopg2.connect(url, connect_timeout=3)
        print(f"SUCCESS connecting to {url}!")
        conn.close()
    except Exception as e:
        print(f"FAILED connecting to {url}: {e}")
