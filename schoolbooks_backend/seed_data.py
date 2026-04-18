"""
Script to seed test data into the SchoolBooks database
"""
import uuid
from datetime import datetime
from sqlalchemy.orm import Session
from app.core.database import SessionLocal, engine, Base
from app.models.models import User, Vendor, Book, Category
from app.core.security import get_password_hash

# Test data
VENDORS_DATA = [
    {
        "name": "ClassRoom Publishers",
        "email": "contact@classroom.in",
        "phone": "9876543210",
        "business_name": "ClassRoom Publishers Pvt Ltd",
        "address": "Mumbai, Maharashtra",
    },
    {
        "name": "Academic World",
        "email": "sales@academicworld.in",
        "phone": "9876543211",
        "business_name": "Academic World Ltd",
        "address": "Delhi, India",
    },
    {
        "name": "Knowledge Hub",
        "email": "support@knowledgehub.com",
        "phone": "9876543212",
        "business_name": "Knowledge Hub Educational",
        "address": "Bangalore, Karnataka",
    },
]

BOOKS_DATA = [
    # CBSE Class 10
    {
        "title": "Mathematics Part 1",
        "author": "R.S. Aggarwal",
        "publisher": "Arihant Publishers",
        "board": "CBSE",
        "grade": "Class 10",
        "subject": "Mathematics",
        "isbn": "978-8173-1001",
        "price": 299.99,
        "discounted_price": 249.99,
        "stock_quantity": 50,
        "description": "Comprehensive mathematics textbook with solved examples and practice questions.",
    },
    {
        "title": "Science textbook Part 1",
        "author": "NCERT",
        "publisher": "NCERT",
        "board": "CBSE",
        "grade": "Class 10",
        "subject": "Science",
        "isbn": "978-8173-1002",
        "price": 349.99,
        "discounted_price": 299.99,
        "stock_quantity": 45,
        "description": "Official NCERT Science textbook for Class 10 with experiments and activities.",
    },
    {
        "title": "English Literature",
        "author": "Various Authors",
        "publisher": "NCERT",
        "board": "CBSE",
        "grade": "Class 10",
        "subject": "English",
        "isbn": "978-8173-1003",
        "price": 249.99,
        "discounted_price": 199.99,
        "stock_quantity": 60,
        "description": "Collection of stories, poems and plays for Class 10 English.",
    },
    {
        "title": "Social Studies Class 10",
        "author": "NCERT",
        "publisher": "NCERT",
        "board": "CBSE",
        "grade": "Class 10",
        "subject": "Social Studies",
        "isbn": "978-8173-1004",
        "price": 299.99,
        "stock_quantity": 40,
        "description": "History, Geography and Civics combined textbook.",
    },
    # CBSE Class 12
    {
        "title": "Physics Part 1",
        "author": "H.C. Verma",
        "publisher": "Bharati Bhawan",
        "board": "CBSE",
        "grade": "Class 12",
        "subject": "Physics",
        "isbn": "978-8173-1005",
        "price": 449.99,
        "discounted_price": 399.99,
        "stock_quantity": 35,
        "description": "Advanced physics concepts with numerical problems and solutions.",
    },
    {
        "title": "Chemistry The Central Science",
        "author": "Brown & LeMay",
        "publisher": "Pearson",
        "board": "CBSE",
        "grade": "Class 12",
        "subject": "Chemistry",
        "isbn": "978-8173-1006",
        "price": 499.99,
        "discounted_price": 449.99,
        "stock_quantity": 30,
        "description": "Comprehensive chemistry textbook with mechanisms and reactions.",
    },
    {
        "title": "Biology Class 12",
        "author": "NCERT",
        "publisher": "NCERT",
        "board": "CBSE",
        "grade": "Class 12",
        "subject": "Biology",
        "isbn": "978-8173-1007",
        "price": 399.99,
        "discounted_price": 349.99,
        "stock_quantity": 40,
        "description": "Comprehensive biology covering all life sciences topics.",
    },
    # ICSE Books
    {
        "title": "Concise Mathematics Class 9",
        "author": "Selina Publishers",
        "publisher": "Selina Publishers",
        "board": "ICSE",
        "grade": "Class 9",
        "subject": "Mathematics",
        "isbn": "978-8173-1008",
        "price": 279.99,
        "discounted_price": 239.99,
        "stock_quantity": 55,
        "description": "ICSE formatted mathematics with solved exercises.",
    },
    {
        "title": "Physics Class 9",
        "author": "Frank Publisher",
        "publisher": "Frank Publisher",
        "board": "ICSE",
        "grade": "Class 9",
        "subject": "Physics",
        "isbn": "978-8173-1009",
        "price": 329.99,
        "stock_quantity": 38,
        "description": "Laboratory based physics experiments for ICSE.",
    },
    # State Board
    {
        "title": "Maharashtra State Board Math",
        "author": "State Board",
        "publisher": "State Board",
        "board": "State Board",
        "grade": "Class 8",
        "subject": "Mathematics",
        "state_board": "Maharashtra",
        "isbn": "978-8173-1010",
        "price": 199.99,
        "stock_quantity": 70,
        "description": "Mathematics textbook as per Maharashtra State Board curriculum.",
    },
    {
        "title": "Hindi Literature",
        "author": "Hindi Sahitya",
        "publisher": "Hindi Publishers",
        "board": "State Board",
        "grade": "Class 8",
        "subject": "Hindi",
        "state_board": "Maharashtra",
        "isbn": "978-8173-1011",
        "price": 149.99,
        "stock_quantity": 65,
        "description": "Hindi literature stories and poetry collection.",
    },
    # Class 5-6
    {
        "title": "EVS Class 5",
        "author": "NCERT",
        "publisher": "NCERT",
        "board": "CBSE",
        "grade": "Class 5",
        "subject": "Environmental Studies",
        "isbn": "978-8173-1012",
        "price": 129.99,
        "stock_quantity": 80,
        "description": "Environmental studies with activities for young learners.",
    },
    {
        "title": "English for Class 6",
        "author": "NCERT",
        "publisher": "NCERT",
        "board": "CBSE",
        "grade": "Class 6",
        "subject": "English",
        "isbn": "978-8173-1013",
        "price": 179.99,
        "discounted_price": 149.99,
        "stock_quantity": 75,
        "description": "Grammar, reading comprehension and creative writing for Class 6.",
    },
    {
        "title": "Mathematics Textbook Class 6",
        "author": "NCERT",
        "publisher": "NCERT",
        "board": "CBSE",
        "grade": "Class 6",
        "subject": "Mathematics",
        "isbn": "978-8173-1014",
        "price": 149.99,
        "stock_quantity": 85,
        "description": "Fundamental mathematics concepts with visual learning.",
    },
]


def seed_data():
    """Seed test data into the database"""
    db = SessionLocal()
    try:
        # Check if data already exists
        existing_vendors = db.query(Vendor).count()
        if existing_vendors > 0:
            print("Database already seeded. Skipping...")
            return

        print("Starting data seeding...")

        # Create vendors and users
        vendor_ids = []
        for vendor_data in VENDORS_DATA:
            user = User(
                id=str(uuid.uuid4()),
                email=vendor_data["email"],
                name=vendor_data["name"],
                phone=vendor_data["phone"],
                password_hash=get_password_hash("vendor123"),
                role="vendor",
                is_verified=True,
                is_active=True,
            )
            db.add(user)
            db.flush()

            vendor = Vendor(
                id=str(uuid.uuid4()),
                user_id=user.id,
                business_name=vendor_data["business_name"],
                contact_person=vendor_data["name"],
                email=vendor_data["email"],
                phone=vendor_data["phone"],
                address=vendor_data["address"],
                status="approved",
            )
            db.add(vendor)
            db.flush()
            vendor_ids.append(vendor.id)
            print(f"Created vendor: {vendor_data['business_name']}")

        # Create books
        for i, book_data in enumerate(BOOKS_DATA):
            # Use different vendors for different books
            vendor_id = vendor_ids[i % len(vendor_ids)]

            book = Book(
                id=str(uuid.uuid4()),
                title=book_data["title"],
                author=book_data["author"],
                publisher=book_data.get("publisher"),
                board=book_data["board"],
                grade=book_data["grade"],
                subject=book_data["subject"],
                state_board=book_data.get("state_board"),
                isbn=book_data["isbn"],
                price=book_data["price"],
                discounted_price=book_data.get("discounted_price"),
                stock_quantity=book_data.get("stock_quantity", 50),
                description=book_data.get("description"),
                rating=4.5 if i % 3 == 0 else 4.0,
                review_count=10 + i,
                is_available=True,
                vendor_id=vendor_id,
            )
            db.add(book)
            print(f"Added book: {book_data['title']}")

        db.commit()
        print("\nData seeding completed successfully!")
        print(f"Created {len(VENDORS_DATA)} vendors")
        print(f"Created {len(BOOKS_DATA)} books")

    except Exception as e:
        db.rollback()
        print(f"Error seeding data: {e}")
        raise
    finally:
        db.close()


if __name__ == "__main__":
    seed_data()
