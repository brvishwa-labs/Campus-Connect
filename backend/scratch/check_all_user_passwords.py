import psycopg2
from app.core.security import verify_password, get_password_hash

url = "postgresql://postgres:admin@localhost:5432/campus_connect"

try:
    conn = psycopg2.connect(url)
    cur = conn.cursor()
    
    cur.execute("SELECT id, email, role, hashed_password FROM users")
    users = cur.fetchall()
    
    candidates = [
        "admin123", "faculty123", "student123", "auth123", "svcet@123",
        "password", "password123", "welcome123", "Password123", "123456", "12345678"
    ]
    
    working_users = []
    unknown_users = []
    
    for uid, email, role, hpw in users:
        found = False
        for cand in candidates:
            if verify_password(cand, hpw):
                working_users.append((email, role, cand))
                found = True
                break
        if not found:
            unknown_users.append((email, role))
            
    print("=== WORKING USER CREDENTIALS FOUND IN DB ===")
    for email, role, pw in working_users[:20]:
        print(f"Role: {role:<15} | Email: {email:<35} | Password: {pw}")
        
    print(f"\nTotal users with known passwords: {len(working_users)}")
    print(f"Total users with unknown passwords: {len(unknown_users)}")
    
    if unknown_users:
        print("\nSample unknown password users:")
        for email, role in unknown_users[:10]:
            print(f"Role: {role:<15} | Email: {email}")

    cur.close()
    conn.close()
except Exception as e:
    print("Error:", e)
