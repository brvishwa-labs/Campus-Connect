"""
migrate_accountant_role.py — Add 'ACCOUNTANT' role to PostgreSQL enum + create accountant user

Run this ONCE:
    cd backend
    python migrate_accountant_role.py

What it does:
  1. Adds 'ACCOUNTANT' to the PostgreSQL userrole enum type (ALTER TYPE)
  2. Creates a default accountant user via raw SQL:
       Email    : accountant@svcet.edu
       Password : Accountant@123
"""

import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app.core.database import engine
import app.models  # noqa — registers all models


def run():
    print("=" * 60)
    print("Campus Connect — Accountant Role Migration")
    print("=" * 60)

    from sqlalchemy import text

    with engine.connect() as conn:

        # ── Step 1: Check existing enum labels ───────────────────
        result = conn.execute(text(
            "SELECT enumlabel FROM pg_enum "
            "JOIN pg_type ON pg_enum.enumtypid = pg_type.oid "
            "WHERE pg_type.typname = 'userrole'"
        ))
        existing_labels = [row[0] for row in result]
        print(f"  Current enum values: {existing_labels}")

        # ── Step 2: Add ACCOUNTANT to PostgreSQL enum if missing ──
        if "ACCOUNTANT" in existing_labels:
            print("  [SKIP]   'ACCOUNTANT' already exists in userrole enum.")
        else:
            # ALTER TYPE ADD VALUE must run outside a transaction block in PG < 12
            # In PG >= 12 it's fine inside a transaction, but COMMIT first for safety
            conn.execute(text("COMMIT"))
            conn.execute(text("ALTER TYPE userrole ADD VALUE 'ACCOUNTANT'"))
            conn.execute(text("COMMIT"))
            print("  [ALTER]  Added 'ACCOUNTANT' to userrole enum.")

        # ── Step 3: Create accountant user via raw SQL ────────────
        existing_user = conn.execute(text(
            "SELECT id FROM users WHERE email = 'accountant@svcet.edu'"
        )).fetchone()

        if existing_user:
            print("  [SKIP]   accountant@svcet.edu already exists.")
        else:
            # Hash the password using bcrypt directly
            import bcrypt
            password = "Accountant@123"
            hashed = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")

            conn.execute(text(
                "INSERT INTO users (email, hashed_password, role, is_active) "
                "VALUES (:email, :hashed, 'ACCOUNTANT', true)"
            ), {"email": "accountant@svcet.edu", "hashed": hashed})
            conn.execute(text("COMMIT"))
            print("  [CREATE] Accountant user created.")
            print("           Email    : accountant@svcet.edu")
            print("           Password : Accountant@123")
            print("           Role     : ACCOUNTANT")

    print()
    print("Migration complete!")
    print("=" * 60)
    print()
    print("Login credentials:")
    print("  URL      : http://localhost:5173/login")
    print("  Email    : accountant@svcet.edu")
    print("  Password : Accountant@123")


if __name__ == "__main__":
    try:
        run()
    except Exception as exc:
        print(f"\nERROR: {exc}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
