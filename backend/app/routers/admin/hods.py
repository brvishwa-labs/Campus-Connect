from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from typing import List
from app.database import get_db
from app.models.department import Department
from app.models.user import User, UserRole
from app.schemas.admin import HODAssignRequest
from app.middleware.auth import require_admin

router = APIRouter(prefix="/api/v1/admin/hods", tags=["Admin - HODs"])


@router.get("/")
async def get_hod_assignments(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Get all HOD assignments."""
    result = await db.execute(select(Department).order_by(Department.name))
    departments = result.scalars().all()

    assignments = []
    for dept in departments:
        hod_info = None
        if dept.hod_id:
            hod_result = await db.execute(select(User).where(User.id == dept.hod_id))
            hod = hod_result.scalar_one_or_none()
            if hod:
                hod_info = {
                    "id": hod.id,
                    "name": hod.full_name,
                    "email": hod.email,
                }

        assignments.append({
            "department_id": dept.id,
            "department_name": dept.name,
            "department_code": dept.code,
            "is_active": dept.is_active,
            "hod": hod_info,
        })

    return assignments


@router.post("/assign")
async def assign_hod(
    data: HODAssignRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Assign a faculty as HOD of a department."""
    dept_result = await db.execute(select(Department).where(Department.id == data.department_id))
    dept = dept_result.scalar_one_or_none()
    if not dept:
        raise HTTPException(status_code=404, detail="Department not found")

    user_result = await db.execute(select(User).where(User.id == data.faculty_user_id))
    user = user_result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Update the user's role to HOD
    user.role = UserRole.HOD
    dept.hod_id = user.id

    await db.flush()
    return {"message": f"{user.full_name} assigned as HOD of {dept.name}"}


@router.delete("/{department_id}/remove")
async def remove_hod(
    department_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Remove HOD assignment from a department."""
    dept_result = await db.execute(select(Department).where(Department.id == department_id))
    dept = dept_result.scalar_one_or_none()
    if not dept:
        raise HTTPException(status_code=404, detail="Department not found")

    if dept.hod_id:
        user_result = await db.execute(select(User).where(User.id == dept.hod_id))
        user = user_result.scalar_one_or_none()
        if user:
            user.role = UserRole.FACULTY

    dept.hod_id = None
    await db.flush()
    return {"message": f"HOD removed from {dept.name}"}
