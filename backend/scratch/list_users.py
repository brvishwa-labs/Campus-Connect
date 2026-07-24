import psycopg2

url = "postgresql://postgres:admin@localhost:5432/campus_connect"
print("Connecting to local db:", url)

try:
    conn = psycopg2.connect(url)
    cur = conn.cursor()
    
    # Check what tables exist
    cur.execute("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public'
    """)
    tables = [row[0] for row in cur.fetchall()]
    print("Tables found:", tables)
    
    if 'users' in tables:
        cur.execute("SELECT id, email, role, is_active, hashed_password FROM users")
        users = cur.fetchall()
        print(f"\nFound {len(users)} users:")
        for u in users:
            print(f"ID: {u[0]}, Email: {u[1]}, Role: {u[2]}, Active: {u[3]}, HashedPW: {u[4][:20]}...")
    else:
        print("No users table found!")
        
    cur.close()
    conn.close()
except Exception as e:
    print("Error:", e)
