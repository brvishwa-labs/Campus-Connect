from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.sql import func
from app.core.database import Base

class NotificationView(Base):
    __tablename__ = "notification_views"
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    sector = Column(String(50), nullable=False)
    last_viewed_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
