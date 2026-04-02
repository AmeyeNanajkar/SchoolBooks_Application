from sqlalchemy import (
    Column,
    String,
    Boolean,
    DateTime,
    Enum,
    Integer,
    Float,
    Text,
    ForeignKey,
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum
from app.core.database import Base


class UserRole(str, enum.Enum):
    FAMILY = "family"
    SCHOOL = "school"
    VENDOR = "vendor"
    ADMIN = "admin"


class User(Base):
    __tablename__ = "users"

    id = Column(String(36), primary_key=True, index=True)
    email = Column(String(255), unique=True, index=True, nullable=False)
    phone = Column(String(15), unique=True, index=True, nullable=True)
    name = Column(String(255), nullable=False)
    password_hash = Column(String(255), nullable=False)
    role = Column(String(20), default=UserRole.FAMILY.value)
    avatar = Column(String(500), nullable=True)
    is_verified = Column(Boolean, default=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    addresses = relationship("Address", back_populates="user")
    cart = relationship("Cart", back_populates="user")
    wishlist = relationship("Wishlist", back_populates="user")
    orders = relationship("Order", back_populates="user")


class Address(Base):
    __tablename__ = "addresses"

    id = Column(String(36), primary_key=True, index=True)
    user_id = Column(String(36), ForeignKey("users.id"), nullable=False)
    name = Column(String(255), nullable=False)
    phone = Column(String(15), nullable=False)
    address_line_1 = Column(String(500), nullable=False)
    address_line_2 = Column(String(500), nullable=True)
    city = Column(String(100), nullable=False)
    state = Column(String(100), nullable=False)
    pincode = Column(String(10), nullable=False)
    address_type = Column(String(20), default="home")
    is_default = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    user = relationship("User", back_populates="addresses")


class Category(Base):
    __tablename__ = "categories"

    id = Column(String(36), primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    type = Column(String(50), nullable=False)
    parent_id = Column(String(36), ForeignKey("categories.id"), nullable=True)
    icon = Column(String(100), nullable=True)
    order = Column(Integer, default=0)
    created_at = Column(DateTime(timezone=True), server_default=func.now())


class Book(Base):
    __tablename__ = "books"

    id = Column(String(36), primary_key=True, index=True)
    title = Column(String(500), nullable=False)
    author = Column(String(255), nullable=False)
    publisher = Column(String(255), nullable=True)
    board = Column(String(50), nullable=False)
    grade = Column(String(20), nullable=False)
    subject = Column(String(100), nullable=False)
    state_board = Column(String(100), nullable=True)
    isbn = Column(String(20), unique=True, nullable=False)
    price = Column(Float, nullable=False)
    discounted_price = Column(Float, nullable=True)
    image_url = Column(String(500), nullable=True)
    description = Column(Text, nullable=True)
    stock_quantity = Column(Integer, default=0)
    rating = Column(Float, default=0.0)
    review_count = Column(Integer, default=0)
    is_available = Column(Boolean, default=True)
    vendor_id = Column(String(36), ForeignKey("vendors.id"), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    vendor = relationship("Vendor", back_populates="books")
    reviews = relationship("Review", back_populates="book")


class Vendor(Base):
    __tablename__ = "vendors"

    id = Column(String(36), primary_key=True, index=True)
    user_id = Column(String(36), ForeignKey("users.id"), nullable=False)
    business_name = Column(String(255), nullable=False)
    business_logo = Column(String(500), nullable=True)
    contact_person = Column(String(255), nullable=False)
    email = Column(String(255), nullable=False)
    phone = Column(String(15), nullable=False)
    gstin = Column(String(15), nullable=True)
    pan = Column(String(10), nullable=True)
    bank_name = Column(String(255), nullable=True)
    account_number = Column(String(30), nullable=True)
    ifsc_code = Column(String(15), nullable=True)
    address = Column(String(500), nullable=False)
    status = Column(String(20), default="pending")
    rating = Column(Float, default=0.0)
    total_orders = Column(Integer, default=0)
    total_sales = Column(Float, default=0.0)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    user = relationship("User", back_populates="vendor")
    books = relationship("Book", back_populates="vendor")


class Cart(Base):
    __tablename__ = "carts"

    id = Column(String(36), primary_key=True, index=True)
    user_id = Column(String(36), ForeignKey("users.id"), unique=True, nullable=False)
    applied_coupon_code = Column(String(50), nullable=True)
    discount_amount = Column(Float, default=0.0)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    user = relationship("User", back_populates="cart")
    items = relationship(
        "CartItem", back_populates="cart", cascade="all, delete-orphan"
    )


class CartItem(Base):
    __tablename__ = "cart_items"

    id = Column(String(36), primary_key=True, index=True)
    cart_id = Column(String(36), ForeignKey("carts.id"), nullable=False)
    book_id = Column(String(36), ForeignKey("books.id"), nullable=False)
    quantity = Column(Integer, default=1)
    added_at = Column(DateTime(timezone=True), server_default=func.now())

    cart = relationship("Cart", back_populates="items")
    book = relationship("Book")


class Wishlist(Base):
    __tablename__ = "wishlists"

    id = Column(String(36), primary_key=True, index=True)
    user_id = Column(String(36), ForeignKey("users.id"), nullable=False)
    book_id = Column(String(36), ForeignKey("books.id"), nullable=False)
    added_at = Column(DateTime(timezone=True), server_default=func.now())

    user = relationship("User", back_populates="wishlist")
    book = relationship("Book")


class Review(Base):
    __tablename__ = "reviews"

    id = Column(String(36), primary_key=True, index=True)
    book_id = Column(String(36), ForeignKey("books.id"), nullable=False)
    user_id = Column(String(36), ForeignKey("users.id"), nullable=False)
    rating = Column(Integer, nullable=False)
    comment = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    book = relationship("Book", back_populates="reviews")
    user = relationship("User")


class Order(Base):
    __tablename__ = "orders"

    id = Column(String(36), primary_key=True, index=True)
    order_number = Column(String(20), unique=True, nullable=False)
    user_id = Column(String(36), ForeignKey("users.id"), nullable=False)
    status = Column(String(20), default="pending")
    payment_status = Column(String(20), default="pending")
    payment_method = Column(String(20), default="upi")
    subtotal = Column(Float, nullable=False)
    discount_amount = Column(Float, default=0.0)
    shipping_cost = Column(Float, default=0.0)
    tax_amount = Column(Float, default=0.0)
    total_amount = Column(Float, nullable=False)
    coupon_code = Column(String(50), nullable=True)
    tracking_number = Column(String(100), nullable=True)
    tracking_url = Column(String(500), nullable=True)
    invoice_url = Column(String(500), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    delivered_at = Column(DateTime(timezone=True), nullable=True)

    user = relationship("User", back_populates="orders")
    items = relationship(
        "OrderItem", back_populates="order", cascade="all, delete-orphan"
    )
    address = relationship("OrderAddress", back_populates="order", uselist=False)


class OrderItem(Base):
    __tablename__ = "order_items"

    id = Column(String(36), primary_key=True, index=True)
    order_id = Column(String(36), ForeignKey("orders.id"), nullable=False)
    book_id = Column(String(36), ForeignKey("books.id"), nullable=False)
    book_title = Column(String(500), nullable=False)
    book_image = Column(String(500), nullable=True)
    quantity = Column(Integer, nullable=False)
    price = Column(Float, nullable=False)
    discounted_price = Column(Float, nullable=True)
    vendor_id = Column(String(36), ForeignKey("vendors.id"), nullable=True)

    order = relationship("Order", back_populates="items")
    book = relationship("Book")
    vendor = relationship("Vendor")


class OrderAddress(Base):
    __tablename__ = "order_addresses"

    id = Column(String(36), primary_key=True, index=True)
    order_id = Column(String(36), ForeignKey("orders.id"), nullable=False)
    name = Column(String(255), nullable=False)
    phone = Column(String(15), nullable=False)
    address_line_1 = Column(String(500), nullable=False)
    address_line_2 = Column(String(500), nullable=True)
    city = Column(String(100), nullable=False)
    state = Column(String(100), nullable=False)
    pincode = Column(String(10), nullable=False)

    order = relationship("Order", back_populates="address")


class Coupon(Base):
    __tablename__ = "coupons"

    id = Column(String(36), primary_key=True, index=True)
    code = Column(String(50), unique=True, nullable=False)
    description = Column(String(255), nullable=True)
    discount_type = Column(String(20), nullable=False)
    discount_value = Column(Float, nullable=False)
    min_order_amount = Column(Float, nullable=True)
    max_discount_amount = Column(Float, nullable=True)
    valid_from = Column(DateTime(timezone=True), nullable=False)
    valid_until = Column(DateTime(timezone=True), nullable=False)
    is_active = Column(Boolean, default=True)
    usage_limit = Column(Integer, nullable=True)
    used_count = Column(Integer, default=0)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
