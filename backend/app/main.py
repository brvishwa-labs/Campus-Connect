from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from app.config import settings
from app.database import init_db, close_db

# Routers
from app.routers import auth
from app.routers.dashboard import router as dashboard_router
from app.routers.admin.departments import router as departments_router
from app.routers.admin.faculty import router as faculty_router
from app.routers.admin.students import router as students_router
from app.routers.admin.courses import router as courses_router
from app.routers.admin.hods import router as hods_router
from app.routers.admin.high_authorities import router as high_authorities_router
from app.routers.admin.announcements import router as announcements_router
from app.routers.admin.audit_logs import router as audit_logs_router
from app.routers.admin.role_management import router as roles_router
from app.routers.admin.discipline import router as discipline_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: Initialize DB tables (for dev only, use alembic in prod)
    await init_db()
    yield
    # Shutdown: Close DB
    await close_db()


app = FastAPI(
    title=settings.APP_NAME,
    description="Campus Connect ERP Backend API",
    version="1.0.0",
    lifespan=lifespan,
)

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Include Routers
app.include_router(auth.router)
app.include_router(dashboard_router)
app.include_router(departments_router)
app.include_router(faculty_router)
app.include_router(students_router)
app.include_router(courses_router)
app.include_router(hods_router)
app.include_router(high_authorities_router)
app.include_router(announcements_router)
app.include_router(audit_logs_router)
app.include_router(roles_router)
app.include_router(discipline_router)


@app.get("/")
async def root():
    return {"message": f"Welcome to {settings.APP_NAME} API"}
