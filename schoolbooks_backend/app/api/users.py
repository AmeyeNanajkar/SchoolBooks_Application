from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.core.security import get_current_user
from app.models.models import User, Address
from app.schemas.schemas import UserResponse, AddressCreate, AddressResponse
import uuid

router = APIRouter()


@router.get("/me", response_model=UserResponse)
async def get_current_user_profile(current_user: User = Depends(get_current_user)):
    return UserResponse.model_validate(current_user)


@router.put("/me", response_model=UserResponse)
async def update_profile(
    name: str = None,
    phone: str = None,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if name:
        current_user.name = name
    if phone:
        current_user.phone = phone
    db.commit()
    db.refresh(current_user)
    return UserResponse.model_validate(current_user)


@router.get("/addresses", response_model=List[AddressResponse])
async def get_addresses(
    current_user: User = Depends(get_current_user), db: Session = Depends(get_db)
):
    addresses = db.query(Address).filter(Address.user_id == current_user.id).all()
    return [AddressResponse.model_validate(a) for a in addresses]


@router.post("/addresses", response_model=AddressResponse)
async def create_address(
    address_data: AddressCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if address_data.is_default:
        db.query(Address).filter(Address.user_id == current_user.id).update(
            {"is_default": False}
        )

    address = Address(
        id=str(uuid.uuid4()),
        user_id=current_user.id,
        name=address_data.name,
        phone=address_data.phone,
        address_line_1=address_data.address_line_1,
        address_line_2=address_data.address_line_2,
        city=address_data.city,
        state=address_data.state,
        pincode=address_data.pincode,
        address_type=address_data.address_type,
        is_default=address_data.is_default,
    )
    db.add(address)
    db.commit()
    db.refresh(address)
    return AddressResponse.model_validate(address)


@router.put("/addresses/{address_id}", response_model=AddressResponse)
async def update_address(
    address_id: str,
    address_data: AddressCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    address = (
        db.query(Address)
        .filter(Address.id == address_id, Address.user_id == current_user.id)
        .first()
    )
    if not address:
        raise HTTPException(status_code=404, detail="Address not found")

    if address_data.is_default:
        db.query(Address).filter(Address.user_id == current_user.id).update(
            {"is_default": False}
        )

    for key, value in address_data.model_dump().items():
        setattr(address, key, value)

    db.commit()
    db.refresh(address)
    return AddressResponse.model_validate(address)


@router.delete("/addresses/{address_id}")
async def delete_address(
    address_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    address = (
        db.query(Address)
        .filter(Address.id == address_id, Address.user_id == current_user.id)
        .first()
    )
    if not address:
        raise HTTPException(status_code=404, detail="Address not found")

    db.delete(address)
    db.commit()
    return {"message": "Address deleted successfully"}
