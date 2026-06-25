from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from typing import List, Optional
from app.database import get_db
from app.models.announcement import Announcement, AnnouncementCategory, AnnouncementTarget
from app.models.user import User
from app.models.department import Department
from app.schemas.admin import AnnouncementCreate, AnnouncementUpdate, AnnouncementResponse
from app.middleware.auth import require_admin

router = APIRouter(prefix="/api/v1/admin/announcements", tags=["Admin - Announcements"])


@router.get("/", response_model=List[AnnouncementResponse])
async def get_announcements(
    category: Optional[str] = None,
    target_audience: Optional[str] = None,
    is_active: Optional[bool] = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Get all announcements with optional filters."""
    query = select(Announcement)
    if category:
        query = query.where(Announcement.category == category)
    if target_audience:
        query = query.where(Announcement.target_audience == target_audience)
    if is_active is not None:
        query = query.where(Announcement.is_active == is_active)
    query = query.order_by(Announcement.created_at.desc())

    result = await db.execute(query)
    announcements = result.scalars().all()

    response = []
    for a in announcements:
        user_result = await db.execute(select(User).where(User.id == a.created_by))
        user = user_result.scalar_one_or_none()

        response.append(AnnouncementResponse(
            id=a.id, title=a.title, content=a.content,
            category=a.category.value if isinstance(a.category, AnnouncementCategory) else a.category,
            target_audience=a.target_audience.value if isinstance(a.target_audience, AnnouncementTarget) else a.target_audience,
            target_department_id=a.target_department_id,
            created_by=a.created_by,
            created_by_name=user.full_name if user else "Unknown",
            is_active=a.is_active, is_pinned=a.is_pinned,
            created_at=a.created_at,
        ))

    return response


@router.post("/", response_model=AnnouncementResponse, status_code=201)
async def create_announcement(
    data: AnnouncementCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Create a new announcement."""
    announcement = Announcement(
        title=data.title,
        content=data.content,
        category=data.category,
        target_audience=data.target_audience,
        target_department_id=data.target_department_id,
        created_by=current_user.id,
        is_pinned=data.is_pinned,
    )
    db.add(announcement)
    await db.flush()
    await db.refresh(announcement)

    return AnnouncementResponse(
        id=announcement.id, title=announcement.title, content=announcement.content,
        category=data.category, target_audience=data.target_audience,
        target_department_id=announcement.target_department_id,
        created_by=announcement.created_by,
        created_by_name=current_user.full_name,
        is_active=announcement.is_active, is_pinned=announcement.is_pinned,
        created_at=announcement.created_at,
    )


@router.put("/{announcement_id}", response_model=AnnouncementResponse)
async def update_announcement(
    announcement_id: int,
    data: AnnouncementUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Update an announcement."""
    result = await db.execute(select(Announcement).where(Announcement.id == announcement_id))
    announcement = result.scalar_one_or_none()
    if not announcement:
        raise HTTPException(status_code=404, detail="Announcement not found")

    update_data = data.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(announcement, key, value)

    await db.flush()
    await db.refresh(announcement)

    user_result = await db.execute(select(User).where(User.id == announcement.created_by))
    user = user_result.scalar_one_or_none()

    return AnnouncementResponse(
        id=announcement.id, title=announcement.title, content=announcement.content,
        category=announcement.category.value if isinstance(announcement.category, AnnouncementCategory) else announcement.category,
        target_audience=announcement.target_audience.value if isinstance(announcement.target_audience, AnnouncementTarget) else announcement.target_audience,
        target_department_id=announcement.target_department_id,
        created_by=announcement.created_by,
        created_by_name=user.full_name if user else "Unknown",
        is_active=announcement.is_active, is_pinned=announcement.is_pinned,
        created_at=announcement.created_at,
    )


@router.delete("/{announcement_id}")
async def delete_announcement(
    announcement_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Delete an announcement."""
    result = await db.execute(select(Announcement).where(Announcement.id == announcement_id))
    announcement = result.scalar_one_or_none()
    if not announcement:
        raise HTTPException(status_code=404, detail="Announcement not found")

    await db.delete(announcement)
    return {"message": "Announcement deleted successfully"}
