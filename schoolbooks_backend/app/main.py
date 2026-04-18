from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import auth, users, books, cart, orders, payments, vendors, categories
from app.core.config import settings

app = FastAPI(
    title="SchoolBooks API",
    description="API for SchoolBooks - Online School Book Ordering Platform",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/api/v1/auth", tags=["Authentication"])
app.include_router(users.router, prefix="/api/v1/users", tags=["Users"])
app.include_router(books.router, prefix="/api/v1/books", tags=["Books"])
app.include_router(categories.router, prefix="/api/v1/categories", tags=["Categories"])
app.include_router(cart.router, prefix="/api/v1/cart", tags=["Cart"])
app.include_router(orders.router, prefix="/api/v1/orders", tags=["Orders"])
app.include_router(payments.router, prefix="/api/v1/payments", tags=["Payments"])
app.include_router(vendors.router, prefix="/api/v1/vendors", tags=["Vendors"])


@app.get("/")
async def root():
    return {"message": "Welcome to SchoolBooks API", "version": "1.0.0"}


@app.get("/health")
async def health_check():
    return {"status": "healthy"}
