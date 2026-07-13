from datetime import datetime, date
from sqlalchemy.orm import Session
from app.models.department import Department
from app.core.config import get_settings

def get_sem_start_date(department_id: int, db: Session) -> date:
    """
    Returns the semester start date for a given department.
    If the department has not set a specific start date, falls back to the global SEM_START_DATE.
    """
    settings = get_settings()
    
    if department_id:
        dept = db.query(Department).filter(Department.id == department_id).first()
        if dept and dept.current_sem_start_date:
            return dept.current_sem_start_date.date()
            
    return datetime.strptime(settings.SEM_START_DATE, "%Y-%m-%d").date()
