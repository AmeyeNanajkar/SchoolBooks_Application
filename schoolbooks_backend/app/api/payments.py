from fastapi import APIRouter, Depends
from app.core.security import get_current_user
from app.models.models import User
import uuid

router = APIRouter()


@router.post("/create-order")
async def create_payment_order(
    amount: float, currency: str = "INR", current_user: User = Depends(get_current_user)
):
    return {
        "id": f"order_{uuid.uuid4().hex[:16]}",
        "amount": int(amount * 100),
        "currency": currency,
        "status": "created",
    }


@router.post("/verify")
async def verify_payment(
    razorpay_order_id: str,
    razorpay_payment_id: str,
    razorpay_signature: str,
    current_user: User = Depends(get_current_user),
):
    return {"status": "success", "message": "Payment verified"}


@router.get("/{payment_id}")
async def get_payment(payment_id: str, current_user: User = Depends(get_current_user)):
    return {"id": payment_id, "status": "captured", "amount": 0}


@router.post("/{payment_id}/refund")
async def refund_payment(
    payment_id: str, current_user: User = Depends(get_current_user)
):
    return {"status": "success", "refund_id": f"refund_{uuid.uuid4().hex[:16]}"}
