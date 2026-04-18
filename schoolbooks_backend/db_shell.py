"""
Interactive database shell for SchoolBooks
Usage: python db_shell.py
"""
import os
from app.core.database import SessionLocal
from app.models.models import Book, User, Vendor, Order, Cart, Review
from sqlalchemy import func

db = SessionLocal()

print("""
=================================================
    SchoolBooks Database Interactive Shell
=================================================

Available commands:
  books()          - List all books
  users()          - List all users
  vendors()        - List all vendors
  orders()         - List all orders
  search_books(term) - Search books by title/author
  book_by_id(id)   - Get book by ID
  user_by_email(email) - Get user by email
  stats()          - Show database statistics
  db               - Raw SQLAlchemy session object
  exit()           - Exit shell
""")

def books(limit=10):
    """List books"""
    books = db.query(Book).limit(limit).all()
    for b in books:
        print(f"\n[BOOK] {b.title}")
        print(f"   Author: {b.author} | ISBN: {b.isbn}")
        print(f"   Board: {b.board} | Grade: {b.grade} | Subject: {b.subject}")
        print(f"   Price: Rs {b.price} | Stock: {b.stock_quantity}")

def users(limit=10):
    """List users"""
    users_list = db.query(User).limit(limit).all()
    for u in users_list:
        print(f"\n[USER] {u.name} ({u.email})")
        print(f"   Role: {u.role} | Phone: {u.phone}")
        print(f"   Verified: {u.is_verified} | Active: {u.is_active}")

def vendors(limit=10):
    """List vendors"""
    vendors_list = db.query(Vendor).limit(limit).all()
    for v in vendors_list:
        print(f"\n[VENDOR] {v.business_name}")
        print(f"   Contact: {v.contact_person} | Email: {v.email}")
        print(f"   Phone: {v.phone} | Status: {v.status}")

def orders(limit=10):
    """List orders"""
    orders_list = db.query(Order).limit(limit).all()
    if not orders_list:
        print("No orders found")
    for o in orders_list:
        print(f"\n[ORDER] #{o.order_number}")
        print(f"   Status: {o.status} | Total: Rs {o.total_amount}")
        print(f"   Payment: {o.payment_method} ({o.payment_status})")

def search_books(term):
    """Search books"""
    results = db.query(Book).filter(
        (Book.title.ilike(f"%{term}%")) |
        (Book.author.ilike(f"%{term}%"))
    ).all()
    if not results:
        print(f"No books found matching '{term}'")
    for b in results:
        print(f"\n[BOOK] {b.title} by {b.author}")
        print(f"   ISBN: {b.isbn} | Price: Rs {b.price}")

def book_by_id(book_id):
    """Get book by ID"""
    book = db.query(Book).filter(Book.id == book_id).first()
    if book:
        print(f"\n[BOOK] {book.title}")
        print(f"   Author: {book.author}")
        print(f"   ISBN: {book.isbn}")
        print(f"   Board: {book.board} | Grade: {book.grade} | Subject: {book.subject}")
        print(f"   Price: Rs {book.price} | Stock: {book.stock_quantity}")
        print(f"   Description: {book.description}")
    else:
        print(f"Book with ID {book_id} not found")

def user_by_email(email):
    """Get user by email"""
    user = db.query(User).filter(User.email == email).first()
    if user:
        print(f"\n[USER] {user.name}")
        print(f"   Email: {user.email}")
        print(f"   Phone: {user.phone}")
        print(f"   Role: {user.role}")
        print(f"   Verified: {user.is_verified}")
    else:
        print(f"User with email {email} not found")

def stats():
    """Show database statistics"""
    print("\n[STATS] Database Statistics:")
    print(f"   Books: {db.query(func.count(Book.id)).scalar()}")
    print(f"   Users: {db.query(func.count(User.id)).scalar()}")
    print(f"   Vendors: {db.query(func.count(Vendor.id)).scalar()}")
    print(f"   Orders: {db.query(func.count(Order.id)).scalar()}")
    print(f"   Reviews: {db.query(func.count(Review.id)).scalar()}")

# Show initial stats
stats()

# Interactive loop
import code
code.interact(local=locals(), banner="")
