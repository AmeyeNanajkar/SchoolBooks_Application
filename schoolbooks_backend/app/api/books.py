from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from app.core.database import get_db
from app.core.security import get_current_user
from app.models.models import User, Book, Review
from app.schemas.schemas import UserResponse
import uuid

router = APIRouter()

SAMPLE_BOOKS = [
    {
        "id": str(uuid.uuid4()),
        "title": "NCERT Mathematics Class 10",
        "author": "NCERT",
        "board": "CBSE",
        "grade": "Class 10",
        "subject": "Mathematics",
        "price": 250.0,
        "discounted_price": 225.0,
        "isbn": "9788119210001",
        "description": "NCERT Mathematics textbook for Class 10",
        "rating": 4.5,
        "review_count": 120,
    },
    {
        "id": str(uuid.uuid4()),
        "title": "NCERT Science Class 10",
        "author": "NCERT",
        "board": "CBSE",
        "grade": "Class 10",
        "subject": "Science",
        "price": 280.0,
        "discounted_price": 252.0,
        "isbn": "9788119210002",
        "description": "NCERT Science textbook for Class 10",
        "rating": 4.3,
        "review_count": 95,
    },
    {
        "id": str(uuid.uuid4()),
        "title": "ICSE Mathematics Class 10",
        "author": "Selina",
        "board": "ICSE",
        "grade": "Class 10",
        "subject": "Mathematics",
        "price": 450.0,
        "discounted_price": 405.0,
        "isbn": "9788119210003",
        "description": "Concise Mathematics for ICSE Class 10",
        "rating": 4.6,
        "review_count": 80,
    },
    {
        "id": str(uuid.uuid4()),
        "title": "NCERT English Class 9",
        "author": "NCERT",
        "board": "CBSE",
        "grade": "Class 9",
        "subject": "English",
        "price": 180.0,
        "discounted_price": 162.0,
        "isbn": "9788119210004",
        "description": "Beehive English textbook for Class 9",
        "rating": 4.2,
        "review_count": 65,
    },
    {
        "id": str(uuid.uuid4()),
        "title": "NCERT Hindi Class 8",
        "author": "NCERT",
        "board": "CBSE",
        "grade": "Class 8",
        "subject": "Hindi",
        "price": 150.0,
        "discounted_price": None,
        "isbn": "9788119210005",
        "description": "NCERT Hindi textbook for Class 8",
        "rating": 4.0,
        "review_count": 45,
    },
]


@router.get("")
async def get_books(
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    board: Optional[str] = None,
    grade: Optional[str] = None,
    subject: Optional[str] = None,
    db: Session = Depends(get_db),
):
    books = SAMPLE_BOOKS
    if board:
        books = [b for b in books if b["board"].lower() == board.lower()]
    if grade:
        books = [b for b in books if grade.lower() in b["grade"].lower()]
    if subject:
        books = [b for b in books if subject.lower() in b["subject"].lower()]

    start = (page - 1) * limit
    end = start + limit
    paginated_books = books[start:end]

    return {"items": paginated_books, "total": len(books), "page": page, "limit": limit}


@router.get("/search")
async def search_books(
    q: str = Query(..., min_length=1),
    board: Optional[str] = None,
    grade: Optional[str] = None,
    subject: Optional[str] = None,
    publisher: Optional[str] = None,
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
):
    books = [
        b
        for b in SAMPLE_BOOKS
        if q.lower() in b["title"].lower() or q.lower() in b["author"].lower()
    ]

    if board:
        books = [b for b in books if b["board"].lower() == board.lower()]
    if grade:
        books = [b for b in books if grade.lower() in b["grade"].lower()]
    if subject:
        books = [b for b in books if subject.lower() in b["subject"].lower()]

    start = (page - 1) * limit
    end = start + limit
    paginated_books = books[start:end]

    return {"items": paginated_books, "total": len(books), "page": page, "limit": limit}


@router.get("/recommendations")
async def get_recommendations(
    book_id: str = Query(...),
    limit: int = Query(10, ge=1, le=50),
    db: Session = Depends(get_db),
):
    return {"items": SAMPLE_BOOKS[:limit], "total": limit}


@router.get("/{book_id}")
async def get_book(book_id: str, db: Session = Depends(get_db)):
    for book in SAMPLE_BOOKS:
        if book["id"] == book_id:
            return book
    raise HTTPException(status_code=404, detail="Book not found")


@router.get("/{book_id}/reviews")
async def get_book_reviews(book_id: str, db: Session = Depends(get_db)):
    return {"items": [], "total": 0}
