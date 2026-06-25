from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from typing import List, Optional
from app.database import get_db
from app.models.user import User, UserRole
from app.schemas.auth import UserCreate, UserUpdate, UserResponse
from app.middleware.auth import require_admin
from app.utils.hashing import hash_password

router = APIRouter(prefix="/api/v1/admin/high-authorities", tags=["Admin - High Authorities"])


@router.get("/", response_model=List[UserResponse])
async def get_high_authorities(
    role: Optional[UserRole] = None,
    is_active: Optional[bool] = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Get all high authorities (Dean, Principal, VP, OM)."""
    allowed_roles = [UserRole.DEAN, UserRole.PRINCIPAL, UserRole.VICE_PRINCIPAL, UserRole.OM]
    query = select(User).where(User.role.in_(allowed_roles))

    if role and role in allowed_roles:
        query = query.where(User.role == role)
    if is_active is not None:
        query = query.where(User.is_active == is_active)

    query = query.order_by(User.full_name)

    result = await db.execute(query)
    users = result.scalars().all()
    return users


@router.post("/", response_model=UserResponse, status_code=201)
async def create_high_authority(
    data: UserCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Create a new high authority account."""
    if data.role not in [UserRole.DEAN, UserRole.PRINCIPAL, UserRole.VICE_PRINCIPAL, UserRole.OM]:
        raise HTTPException(status_code=400, detail="Invalid role for high authority")

    existing_user = await db.execute(select(User).where(User.email == data.email))
    if existing_user.scalar_one_or_none():
        raise HTTPException(status_code=400, detail="Email already registered")

    user = User(
        email=data.email,
        password_hash=hash_password(data.password),
        full_name=data.full_name,
        role=data.role,
        phone=data.phone,
    )
    db.add(user)
    await db.flush()
    await db.refresh(user)

    return user


@router.put("/{user_id}", response_model=UserResponse)
async def update_high_authority(
    user_id: int,
    data: UserUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Update a high authority account."""
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    allowed_roles = [UserRole.DEAN, UserRole.PRINCIPAL, UserRole.VICE_PRINCIPAL, UserRole.OM]
    if user.role not in allowed_roles:
        raise HTTPException(status_code=400, detail="User is not a high authority")

    update_data = data.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(user, key, value)

    await db.flush()
    await db.refresh(user)
    return user


@router.patch("/{user_id}/toggle-status")
async def toggle_status(
    user_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Toggle high authority active/inactive status."""
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user.is_active = not user.is_active
    await db.flush()
    return {"message": f"Account {'activated' if user.is_active else 'deactivated'}", "is_active": user.is_active}
