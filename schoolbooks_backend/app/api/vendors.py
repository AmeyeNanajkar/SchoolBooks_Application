from fastapi import APIRouter, Depends, HTTPException
from app.core.security import get_current_user, require_role
from app.models.models import User
from typing import List
import uuid

router = APIRouter()


@router.post("/register")
async def register_vendor(
    business_name: str,
    contact_person: str,
    email: str,
    phone: str,
    address: str,
    current_user: User = Depends(require_role(["vendor"])),
):
    return {
        "id": str(uuid.uuid4()),
        "user_id": current_user.id,
        "business_name": business_name,
        "contact_person": contact_person,
        "email": email,
        "phone": phone,
        "address": address,
        "status": "pending",
    }


@router.get("/dashboard")
async def get_vendor_dashboard(current_user: User = Depends(require_role(["vendor"]))):
    return {"total_sales": 0.0, "total_orders": 0, "total_products": 0, "rating": 0.0}


@router.get("/inventory")
async def get_inventory(current_user: User = Depends(require_role(["vendor"]))):
    return {"items": []}


@router.post("/inventory")
async def add_inventory_item(
    book_id: str,
    price: float,
    stock_quantity: int,
    current_user: User = Depends(require_role(["vendor"])),
):
    return {
        "id": str(uuid.uuid4()),
        "book_id": book_id,
        "price": price,
        "stock_quantity": stock_quantity,
    }


@router.get("/orders")
async def get_vendor_orders(current_user: User = Depends(require_role(["vendor"]))):
    return {"items": []}
