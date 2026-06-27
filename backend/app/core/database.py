from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from app.core.config import get_settings

settings = get_settings()

# SQLAlchemy engine — the single connection pool to PostgreSQL
engine = create_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,       # Verify connections before using them
    pool_size=10,             # Max persistent connections
    max_overflow=20,          # Extra connections under load
    echo=False,               # Set True for SQL debug logging
)

# Session factory — each request gets its own session
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base class for all ORM models
Base = declarative_base()


def get_db():
    """
    FastAPI dependency that provides a database session per request.
    Automatically closes the session when the request is done.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
