#!/usr/bin/env python
"""
Simple database browser for SchoolBooks
Run: python db_browser.py
"""
from app.core.database import SessionLocal
from app.models.models import Book, User, Vendor, Order
from sqlalchemy import func

db = SessionLocal()

while True:
    print("\n" + "="*50)
    print("SchoolBooks Database Browser")
    print("="*50)
    print("1. View Books")
    print("2. Search Books")
    print("3. View Users")
    print("4. View Vendors")
    print("5. View Orders")
    print("6. Database Stats")
    print("0. Exit")

    choice = input("\nEnter choice: ").strip()

    if choice == "1":
        print("\n--- ALL BOOKS ---")
        books = db.query(Book).all()
        for i, b in enumerate(books, 1):
            print(f"\n{i}. {b.title}")
            print(f"   Author: {b.author}")
            print(f"   Grade: {b.grade} | Subject: {b.subject}")
            print(f"   Price: Rs {b.price}")
            if b.discounted_price:
                print(f"   Discount: Rs {b.discounted_price}")

    elif choice == "2":
        search = input("Search term: ").strip()
        results = db.query(Book).filter(
            (Book.title.ilike(f"%{search}%")) |
            (Book.author.ilike(f"%{search}%"))
        ).all()

        if results:
            print(f"\n--- SEARCH RESULTS ({len(results)}) ---")
            for b in results:
                print(f"\n{b.title}")
                print(f"  Author: {b.author} | ISBN: {b.isbn}")
                print(f"  Price: Rs {b.price}")
        else:
            print(f"\nNo results found for '{search}'")

    elif choice == "3":
        print("\n--- ALL USERS ---")
        users = db.query(User).all()
        for i, u in enumerate(users, 1):
            print(f"\n{i}. {u.name} ({u.email})")
            print(f"   Role: {u.role} | Phone: {u.phone}")
            print(f"   Verified: {u.is_verified}")

    elif choice == "4":
        print("\n--- ALL VENDORS ---")
        vendors = db.query(Vendor).all()
        for i, v in enumerate(vendors, 1):
            print(f"\n{i}. {v.business_name}")
            print(f"   Contact: {v.contact_person}")
            print(f"   Email: {v.email} | Phone: {v.phone}")
            print(f"   Status: {v.status}")

    elif choice == "5":
        print("\n--- ALL ORDERS ---")
        orders = db.query(Order).all()
        if not orders:
            print("No orders found")
        else:
            for i, o in enumerate(orders, 1):
                print(f"\n{i}. Order #{o.order_number}")
                print(f"   Status: {o.status} | Total: Rs {o.total_amount}")

    elif choice == "6":
        print("\n--- DATABASE STATISTICS ---")
        print(f"Books: {db.query(func.count(Book.id)).scalar()}")
        print(f"Users: {db.query(func.count(User.id)).scalar()}")
        print(f"Vendors: {db.query(func.count(Vendor.id)).scalar()}")
        print(f"Orders: {db.query(func.count(Order.id)).scalar()}")

    elif choice == "0":
        print("\nGoodbye!")
        break
    else:
        print("Invalid choice!")

db.close()
