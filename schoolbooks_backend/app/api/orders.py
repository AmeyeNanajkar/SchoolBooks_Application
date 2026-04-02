from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from app.core.database import get_db
from app.core.security import get_current_user
from app.models.models import User
import uuid
from datetime import datetime

router = APIRouter()

orders_store = []


@router.get("")
async def get_orders(
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    user_orders = [o for o in orders_store if o["user_id"] == current_user.id]
    start = (page - 1) * limit
    end = start + limit
    return {
        "items": user_orders[start:end],
        "total": len(user_orders),
        "page": page,
        "limit": limit,
    }


@router.post("")
async def create_order(
    address_id: str,
    payment_method: str = "upi",
    coupon_code: Optional[str] = None,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    order_number = f"SB{datetime.now().strftime('%Y%m%d%H%M%S')}"
    order = {
        "id": str(uuid.uuid4()),
        "order_number": order_number,
        "user_id": current_user.id,
        "items": [],
        "shipping_address": {
            "name": "User",
            "phone": "1234567890",
            "address_line_1": "Address",
            "city": "City",
            "state": "State",
            "pincode": "123456",
        },
        "status": "pending",
        "payment_status": "pending",
        "payment_method": payment_method,
        "subtotal": 0.0,
        "discount_amount": 0.0,
        "shipping_cost": 0.0,
        "tax_amount": 0.0,
        "total_amount": 0.0,
        "created_at": datetime.now().isoformat(),
    }
    orders_store.append(order)
    return order


@router.get("/{order_id}")
async def get_order(order_id: str, current_user: User = Depends(get_current_user)):
    for order in orders_store:
        if order["id"] == order_id and order["user_id"] == current_user.id:
            return order
    return {"error": "Order not found"}


@router.put("/{order_id}/cancel")
async def cancel_order(
    order_id: str,
    reason: Optional[str] = None,
    current_user: User = Depends(get_current_user),
):
    for order in orders_store:
        if order["id"] == order_id and order["user_id"] == current_user.id:
            order["status"] = "cancelled"
            return {"message": "Order cancelled"}
    return {"error": "Order not found"}


@router.get("/{order_id}/track")
async def track_order(order_id: str, current_user: User = Depends(get_current_user)):
    for order in orders_store:
        if order["id"] == order_id and order["user_id"] == current_user.id:
            return order
    return {"error": "Order not found"}
