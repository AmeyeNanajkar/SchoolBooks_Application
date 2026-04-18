from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.core.security import get_current_user
from app.models import User, Cart, CartItem, Wishlist, Book
import uuid

router = APIRouter()

cart_store = {}
wishlist_store = {}


@router.get("")
async def get_cart(
    current_user: User = Depends(get_current_user), db: Session = Depends(get_db)
):
    if current_user.id not in cart_store:
        cart_store[current_user.id] = {
            "id": str(uuid.uuid4()),
            "user_id": current_user.id,
            "items": [],
            "discount_amount": 0.0,
            "updated_at": "2024-01-01T00:00:00Z",
        }
    return cart_store[current_user.id]


@router.post("/items")
async def add_to_cart(
    book_id: str,
    quantity: int = 1,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if current_user.id not in cart_store:
        cart_store[current_user.id] = {
            "id": str(uuid.uuid4()),
            "user_id": current_user.id,
            "items": [],
            "discount_amount": 0.0,
            "updated_at": "2024-01-01T00:00:00Z",
        }

    cart_store[current_user.id]["items"].append(
        {
            "id": str(uuid.uuid4()),
            "book_id": book_id,
            "quantity": quantity,
            "added_at": "2024-01-01T00:00:00Z",
        }
    )
    return {"message": "Item added to cart"}


@router.put("/items/{item_id}")
async def update_cart_item(
    item_id: str, quantity: int, current_user: User = Depends(get_current_user)
):
    if current_user.id in cart_store:
        for item in cart_store[current_user.id]["items"]:
            if item["id"] == item_id:
                item["quantity"] = quantity
                break
    return {"message": "Item updated"}


@router.delete("/items/{item_id}")
async def remove_from_cart(
    item_id: str, current_user: User = Depends(get_current_user)
):
    if current_user.id in cart_store:
        cart_store[current_user.id]["items"] = [
            item
            for item in cart_store[current_user.id]["items"]
            if item["id"] != item_id
        ]
    return {"message": "Item removed"}


@router.delete("")
async def clear_cart(current_user: User = Depends(get_current_user)):
    if current_user.id in cart_store:
        cart_store[current_user.id]["items"] = []
    return {"message": "Cart cleared"}


@router.get("/wishlist")
async def get_wishlist(current_user: User = Depends(get_current_user)):
    return {"items": wishlist_store.get(current_user.id, [])}


@router.post("/wishlist")
async def add_to_wishlist(book_id: str, current_user: User = Depends(get_current_user)):
    if current_user.id not in wishlist_store:
        wishlist_store[current_user.id] = []
    wishlist_store[current_user.id].append(
        {
            "id": str(uuid.uuid4()),
            "book_id": book_id,
            "added_at": "2024-01-01T00:00:00Z",
        }
    )
    return {"message": "Added to wishlist"}


@router.delete("/wishlist/{item_id}")
async def remove_from_wishlist(
    item_id: str, current_user: User = Depends(get_current_user)
):
    if current_user.id in wishlist_store:
        wishlist_store[current_user.id] = [
            item for item in wishlist_store[current_user.id] if item["id"] != item_id
        ]
    return {"message": "Removed from wishlist"}
