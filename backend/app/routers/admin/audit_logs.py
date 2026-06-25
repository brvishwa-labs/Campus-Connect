from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, desc
from typing import List, Optional
from app.database import get_db
from app.models.audit_log import AuditLog
from app.models.user import User
from app.schemas.admin import AuditLogResponse
from app.middleware.auth import require_admin

router = APIRouter(prefix="/api/v1/admin/audit-logs", tags=["Admin - Audit Logs"])


@router.get("/", response_model=List[AuditLogResponse])
async def get_audit_logs(
    action: Optional[str] = None,
    resource: Optional[str] = None,
    user_email: Optional[str] = None,
    status: Optional[str] = None,
    limit: int = Query(default=50, le=200),
    offset: int = 0,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Get audit logs with optional filters."""
    query = select(AuditLog)
    if action:
        query = query.where(AuditLog.action.ilike(f"%{action}%"))
    if resource:
        query = query.where(AuditLog.resource.ilike(f"%{resource}%"))
    if user_email:
        query = query.where(AuditLog.user_email.ilike(f"%{user_email}%"))
    if status:
        query = query.where(AuditLog.status == status)

    query = query.order_by(desc(AuditLog.timestamp)).limit(limit).offset(offset)

    result = await db.execute(query)
    logs = result.scalars().all()

    return [AuditLogResponse.model_validate(log) for log in logs]
