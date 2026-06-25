from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.models.user import User
from app.middleware.auth import require_admin

router = APIRouter(prefix="/api/v1/admin/discipline", tags=["Admin - Discipline"])

@router.get("/reports")
async def get_discipline_reports(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Get discipline reports - placeholder for phase 2."""
    # Discipline model is complex and spans late entries/incidents.
    # Currently returning a placeholder for the UI layout.
    return []


@router.get("/analytics")
async def get_discipline_analytics(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Get discipline analytics - placeholder."""
    return {
        "monthly_trend": [],
        "department_comparison": [],
        "frequent_offenders": []
    }
