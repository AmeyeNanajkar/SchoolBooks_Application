from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.models.models import Category

router = APIRouter()


@router.get("/boards")
async def get_boards(db: Session = Depends(get_db)):
    """Get all available boards from database"""
    boards = db.query(Category).filter(Category.type == "board").order_by(Category.order).all()
    return {
        "items": [{"id": b.id, "name": b.name} for b in boards]
    }


@router.get("/grades")
async def get_grades(db: Session = Depends(get_db)):
    """Get all available grades from database"""
    grades = db.query(Category).filter(Category.type == "grade").order_by(Category.order).all()
    return {
        "items": [{"id": g.id, "name": g.name} for g in grades]
    }


@router.get("/subjects")
async def get_subjects(db: Session = Depends(get_db)):
    """Get all available subjects from database"""
    subjects = db.query(Category).filter(Category.type == "subject").order_by(Category.order).all()
    return {
        "items": [{"id": s.id, "name": s.name} for s in subjects]
    }
