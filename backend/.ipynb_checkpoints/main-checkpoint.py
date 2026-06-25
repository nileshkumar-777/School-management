from fastapi import FastAPI, Form, HTTPException
from database import SessionLocal
from models import User
from passlib.context import CryptContext

app = FastAPI()

pwd_context = CryptContext(schemes=["bcrypt"])

@app.get("/test-db")
def test_db():
    db = SessionLocal()
    user = db.query(User).first()
    return {"email": user.email}

@app.post("/login")
def login(
    email: str = Form(...),
    password: str = Form(...)
):
    db = SessionLocal()
    user = db.query(User).filter(User.email == email).first()

    if user is None:
        raise HTTPException(status_code=401, detail="Invalid email")

    if not pwd_context.verify(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid password")

    return {"message": "Login successful"}
