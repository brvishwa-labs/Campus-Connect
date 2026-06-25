import asyncio
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.database import async_session_factory, init_db
from app.models.user import User, UserRole
from app.utils.hashing import hash_password


async def seed_admin():
    print("Initializing database...")
    await init_db()

    print("Checking for existing admin user...")
    async with async_session_factory() as session:
        result = await session.execute(select(User).where(User.email == "admin@campusconnect.edu"))
        admin = result.scalar_one_or_none()

        if not admin:
            print("Creating default admin user...")
            new_admin = User(
                email="admin@campusconnect.edu",
                password_hash=hash_password("admin123"),
                full_name="System Administrator",
                role=UserRole.ADMIN,
                phone="+1234567890",
            )
            session.add(new_admin)
            await session.commit()
            print("Admin user created: admin@campusconnect.edu / admin123")
        else:
            print("Admin user already exists.")


if __name__ == "__main__":
    asyncio.run(seed_admin())
