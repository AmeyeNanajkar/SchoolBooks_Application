#!/usr/bin/env python
"""Seed script to populate categories in the database"""
import uuid
from app.core.database import SessionLocal
from app.models.models import Category

BOARDS = ["CBSE", "ICSE", "State Board"]
GRADES = [
    "Nursery", "LKG", "UKG",
    "Class 1", "Class 2", "Class 3", "Class 4", "Class 5",
    "Class 6", "Class 7", "Class 8", "Class 9", "Class 10",
    "Class 11", "Class 12"
]
SUBJECTS = [
    "Mathematics", "Science", "English", "Hindi", "Social Studies",
    "Physics", "Chemistry", "Biology", "History", "Geography",
    "Economics", "Accountancy", "Business Studies", "Computer Science",
    "Environmental Studies", "Sanskrit", "Physical Education"
]


def seed_categories():
    db = SessionLocal()

    try:
        # Clear existing categories
        db.query(Category).delete()
        db.commit()

        # Seed boards
        for idx, board in enumerate(BOARDS):
            category = Category(
                id=str(uuid.uuid4()),
                name=board,
                type="board",
                order=idx
            )
            db.add(category)

        # Seed grades
        for idx, grade in enumerate(GRADES):
            category = Category(
                id=str(uuid.uuid4()),
                name=grade,
                type="grade",
                order=idx
            )
            db.add(category)

        # Seed subjects
        for idx, subject in enumerate(SUBJECTS):
            category = Category(
                id=str(uuid.uuid4()),
                name=subject,
                type="subject",
                order=idx
            )
            db.add(category)

        db.commit()
        print(f"[OK] Seeded {len(BOARDS)} boards")
        print(f"[OK] Seeded {len(GRADES)} grades")
        print(f"[OK] Seeded {len(SUBJECTS)} subjects")

    except Exception as e:
        print(f"[ERROR] Error seeding categories: {e}")
        db.rollback()
    finally:
        db.close()


if __name__ == "__main__":
    seed_categories()
