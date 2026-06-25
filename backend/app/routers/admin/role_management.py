from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from typing import List, Optional
from pydantic import BaseModel
from app.database import get_db
from app.models.user import User, UserRole
from app.schemas.auth import UserResponse, PasswordReset
from app.middleware.auth import require_admin
from app.utils.hashing import hash_password

router = APIRouter(prefix="/api/v1/admin/roles", tags=["Admin - Role Management"])


class RoleUpdate(BaseModel):
    role: UserRole


@router.get("/users", response_model=List[UserResponse])
async def get_users_by_role(
    role: Optional[UserRole] = None,
    search: Optional[str] = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Get all users, optionally filtered by role and search."""
    query = select(User)
    if role:
        query = query.where(User.role == role)
    if search:
        query = query.where((User.full_name.ilike(f"%{search}%")) | (User.email.ilike(f"%{search}%")))
    
    query = query.order_by(User.full_name)
    result = await db.execute(query)
    return result.scalars().all()


@router.put("/{user_id}/role")
async def update_user_role(
    user_id: int,
    data: RoleUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Change the role of an existing user."""
    if user_id == current_user.id:
        raise HTTPException(status_code=400, detail="Cannot change your own role")

    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user.role = data.role
    await db.flush()
    return {"message": f"User role updated to {data.role.value}"}


@router.post("/{user_id}/reset-password")
async def reset_user_password(
    user_id: int,
    data: PasswordReset,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Force reset a user's password."""
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user.password_hash = hash_password(data.new_password)
    await db.flush()
    return {"message": "Password reset successfully"}
