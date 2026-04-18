# How to Access the SchoolBooks Database

## Database Location
**File Path**: `e:\Repos\SchoolBooks_Application\schoolbooks_backend\schoolbooks.db`

**Database Type**: SQLite (for development)

---

## Method 1: Interactive Browser (Easiest) ⭐

Run this command in the backend directory:

```bash
cd e:/Repos/SchoolBooks_Application/schoolbooks_backend
python db_browser.py
```

This opens an interactive menu where you can:
- View all books
- Search for books by title/author
- View all users
- View all vendors
- View all orders
- See database statistics

**Example**:
```
SchoolBooks Database Browser
============================
1. View Books
2. Search Books
3. View Users
...

Enter choice: 1
```

---

## Method 2: Python Script

Copy this code into a Python file or REPL:

```python
from app.core.database import SessionLocal
from app.models.models import Book, User, Vendor
from sqlalchemy import func

db = SessionLocal()

# Count records
print(f"Total books: {db.query(func.count(Book.id)).scalar()}")
print(f"Total users: {db.query(func.count(User.id)).scalar()}")
print(f"Total vendors: {db.query(func.count(Vendor.id)).scalar()}")

# Get all books
books = db.query(Book).all()
for book in books:
    print(f"{book.title} - Rs {book.price}")

# Search for specific book
book = db.query(Book).filter(Book.title.ilike("%Mathematics%")).first()
print(f"Found: {book.title}")

# Get user by email
user = db.query(User).filter(User.email == "test@test.com").first()

db.close()
```

---

## Method 3: API Endpoints

### Get All Books
```
GET http://localhost:9000/api/v1/books
```

Response:
```json
{
  "items": [
    {
      "id": "...",
      "title": "Mathematics Part 1",
      "author": "R.S. Aggarwal",
      "price": 299.99,
      "board": "CBSE",
      "grade": "Class 10"
    }
  ]
}
```

### Search Books
```
GET http://localhost:9000/api/v1/books?search=Mathematics
```

### Get Books by Board/Grade
```
GET http://localhost:9000/api/v1/books?board=CBSE&grade=Class10
```

---

## Method 4: Direct File Access

### Using Python with SQLite directly:

```python
import sqlite3

# Connect to database
conn = sqlite3.connect('e:\\Repos\\SchoolBooks_Application\\schoolbooks_backend\\schoolbooks.db')
cursor = conn.cursor()

# Query
cursor.execute('SELECT * FROM books LIMIT 5')
books = cursor.fetchall()

for book in books:
    print(book)

conn.close()
```

---

## Useful Database Queries

### View All Books with Details
```python
db.query(Book).all()
```

### Search Books by Title
```python
db.query(Book).filter(Book.title.ilike("%search_term%")).all()
```

### Get Books by Grade and Subject
```python
db.query(Book).filter(Book.grade == "Class 10", Book.subject == "Mathematics").all()
```

### Get Books by Vendor
```python
db.query(Book).filter(Book.vendor_id == vendor_id).all()
```

### Get User Orders
```python
from app.models.models import Order
db.query(Order).filter(Order.user_id == user_id).all()
```

### Get All Vendors with Ratings
```python
db.query(Vendor).order_by(Vendor.rating.desc()).all()
```

### Count Books by Grade
```python
from sqlalchemy import func
db.query(Book.grade, func.count(Book.id)).group_by(Book.grade).all()
```

---

## Database Schema

### Main Tables
- **books** - Textbooks and study materials
- **users** - Students, vendors, admins
- **vendors** - Vendor profiles and details
- **orders** - Purchase orders
- **carts** - Shopping carts
- **reviews** - Book reviews and ratings
- **addresses** - Shipping addresses

### Key Relationships
```
User (1) -----> (Many) Orders
User (1) -----> (Many) Reviews
User (1) -----> (1) Cart
Vendor (1) ----> (Many) Books
User (1) -----> (1) Vendor
```

---

## Viewing Database File

### Option A: Download File
Copy the `.db` file from:
```
e:\Repos\SchoolBooks_Application\schoolbooks_backend\schoolbooks.db
```

Then open with:
- **DB Browser for SQLite** (Windows app - free)
- **DBeaver** (Professional tool)
- **VS Code SQLite extension**

### Option B: Command Line (if sqlite3 installed)
```bash
sqlite3 schoolbooks.db
> SELECT * FROM books LIMIT 5;
> SELECT * FROM users;
> .tables
> .schema
```

---

## Quick Stats

Current database has:
- **14 Books** (across CBSE, ICSE, State Board)
- **5 Users** (1 test user + 3 vendors + 1 admin)
- **3 Vendors** (ClassRoom Publishers, Academic World, Knowledge Hub)
- **0 Orders** (ready to test)

---

## Next Steps

1. **Run browser**: `python db_browser.py`
2. **Test API**: Open `http://localhost:9000/docs` (Swagger UI)
3. **Download file**: Copy `.db` file and open in DB Browser for visual inspection
4. **Create custom queries**: Modify the scripts above as needed
