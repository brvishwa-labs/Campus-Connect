from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import traceback
from app.api import (
    auth, admin, departments, faculty, 
    students, authorities, discipline, late, leave, class_advisor
)
from app.core.config import get_settings

settings = get_settings()

import os
from fastapi.staticfiles import StaticFiles
from contextlib import asynccontextmanager
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from app.tasks.attendance_cron import startup_catchup, run_9am_cron
from app.core.database import SessionLocal
import logging

logger = logging.getLogger(__name__)

# Ensure static directories exist before mounting
os.makedirs("uploads", exist_ok=True)
os.makedirs("uploads/messages", exist_ok=True)
@asynccontextmanager
async def lifespan(app: FastAPI):
    # --- Startup ---
    logger.info("Running startup sequence...")
    db = SessionLocal()
    try:
        startup_catchup(db)
    finally:
        db.close()
        
    scheduler = BackgroundScheduler()
    scheduler.add_job(
        run_9am_cron, 
        CronTrigger(hour=9, minute=0, second=0), 
        id="faculty_attendance_9am"
    )
    scheduler.start()
    logger.info("APScheduler started successfully.")
    
    yield
    
    # --- Shutdown ---
    scheduler.shutdown()
    logger.info("APScheduler stopped.")

app = FastAPI(
    title="Campus Connect ERP API",
    description="Backend API for Campus Connect Education Resource Planning System",
    version="1.0.0",
    lifespan=lifespan,
)

app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

@app.exception_handler(Exception)
async def global_exception_handler(request, exc):
    return JSONResponse(
        status_code=500,
        content={"detail": str(exc), "traceback": traceback.format_exc()}
    )

# Configure CORS for the React frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins = [
    "http://localhost:5173",
    "http://localhost:5174",
    "http://localhost:3000",
    "http://localhost:4173",
    settings.FRONTEND_URL,
    ],
    allow_origin_regex=r"https?://.*",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include Routers
app.include_router(discipline.router, prefix="/api/discipline", tags=["Discipline"])
app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])
app.include_router(admin.router, prefix="/api/admin", tags=["Admin"])
app.include_router(departments.router, prefix="/api/departments", tags=["Departments"])
app.include_router(faculty.router, prefix="/api/faculty", tags=["Faculty"])
app.include_router(students.router, prefix="/api/students", tags=["Students"])
app.include_router(late.router, prefix="/api/late", tags=["Late Tracker"])
app.include_router(authorities.router, prefix="/api/authorities", tags=["Authorities"])
app.include_router(leave.router, prefix="/api/leave", tags=["Leave Management"])
app.include_router(class_advisor.router, prefix="/api/class-advisor", tags=["Class Advisor"])

from app.api import courses
app.include_router(courses.router, prefix="/api/courses", tags=["Courses"])
from app.api import course_plan
app.include_router(course_plan.router, prefix="/api/course-plan", tags=["Course Plan"])
from app.api import hod
app.include_router(hod.router, prefix="/api/hod", tags=["HOD"])
from app.api import announcements
app.include_router(announcements.router, prefix="/api/announcements", tags=["Announcements"])
from app.api import student_portal
app.include_router(student_portal.router, prefix="/api/student-portal", tags=["Student Portal"])
from app.api import dashboard
app.include_router(dashboard.router, prefix="/api/dashboard", tags=["Dashboard"])

from app.api import gatepass
app.include_router(gatepass.router, prefix="/api/gatepass", tags=["Gate Pass"])

from app.api import faculty_gatepass
app.include_router(faculty_gatepass.router, prefix="/api/faculty-gatepass", tags=["Faculty Gate Pass"])

from app.api import notifications
app.include_router(notifications.router, prefix="/api/notifications", tags=["Notifications"])

from app.api import alumni
app.include_router(alumni.router, prefix="/api/admin", tags=["Alumni"])

from app.api import retest
app.include_router(retest.router, prefix="/api/retest", tags=["Retest Marks"])

from app.api import messaging
app.include_router(messaging.router, prefix="/api/messaging", tags=["Messaging"])

from app.api import fees
app.include_router(fees.router, prefix="/api/fees", tags=["Fees & Accounts"])


import asyncio
from app.core.tasks import faculty_attendance_job

@app.on_event("startup")
async def startup_event():
    asyncio.create_task(faculty_attendance_job())

@app.get("/")
def read_root():
    return {"message": "Welcome to Campus Connect ERP API"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}

