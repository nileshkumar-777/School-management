from fastapi import FastAPI, HTTPException, Depends, Query
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List, Optional
import datetime

from database import SessionLocal, engine, Base
from models import Teacher, Student, Class, class_students, User
from schemas import (
    LoginRequest,
    TeacherRegister,
    TeacherResponse,
    StudentRegister,
    StudentResponse,
    ClassCreate,
    ClassResponse,
    AddStudentsRequest,
    LoginResponse
)
from passlib.context import CryptContext

app = FastAPI()

# Make sure all tables are created
Base.metadata.create_all(bind=engine)

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Enable CORS for frontend clients
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# DB Session Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ---------------------------
# AUTH / REGISTRATION API
# ---------------------------

@app.post("/register/teacher", response_model=TeacherResponse)
def register_teacher(data: TeacherRegister, db: Session = Depends(get_db)):
    # Check if email is already taken in teachers
    existing = db.query(Teacher).filter(Teacher.email == data.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered as a Teacher")

    hashed_pw = pwd_context.hash(data.password)
    
    teacher = Teacher(
        first_name=data.first_name,
        last_name=data.last_name,
        email=data.email,
        password_hash=hashed_pw,
        employee_id=data.employee_id,
        phone_number=data.phone_number,
        gender=data.gender,
        date_of_birth=data.date_of_birth,
        department=data.department,
        designation=data.designation,
        qualification=data.qualification,
        joining_date=data.joining_date,
        profile_photo=data.profile_photo,
        address=data.address,
        status="Active"
    )

    db.add(teacher)
    db.commit()
    db.refresh(teacher)
    return teacher

@app.post("/register/student", response_model=StudentResponse)
def register_student(data: StudentRegister, db: Session = Depends(get_db)):
    # Check if email is already taken in students
    existing = db.query(Student).filter(Student.email == data.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered as a Student")

    # For students, we also record credentials. Here we store in User table for base validation
    hashed_pw = pwd_context.hash(data.password)

    student = Student(
        name=data.name,
        email=data.email,
        roll_number=data.roll_number,
        semester=data.semester,
        section=data.section,
        department=data.department,
        status="Active"
    )
    db.add(student)
    
    # Also save credentials in baseline User table for credentials validation
    legacy_user = User(
        name=data.name,
        email=data.email,
        password=hashed_pw,
        role="Student"
    )
    db.add(legacy_user)

    db.commit()
    db.refresh(student)
    return student

# Unified register endpoint
@app.post("/register")
def register(name: str, email: str, role: str, db: Session = Depends(get_db)):
    # Legacy fallback register helper
    return {"message": f"Register via specific /register/teacher or /register/student endpoints instead."}

# JWT configurations
from jose import jwt, JWTError

SECRET_KEY = "super_secret_signing_key_for_eduflow_app"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 1440  # 24 hours

def create_access_token(data: dict, expires_delta: Optional[datetime.timedelta] = None) -> str:
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.datetime.utcnow() + expires_delta
    else:
        expire = datetime.datetime.utcnow() + datetime.timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

# Unified login endpoint with strict role verification and JWT generation
@app.post("/login", response_model=LoginResponse)
def login(data: LoginRequest, db: Session = Depends(get_db)):
    if data.role == "Teacher":
        teacher = db.query(Teacher).filter(Teacher.email == data.email).first()
        if not teacher:
            # Check if they are registered as student instead to output correct error
            student_exists = db.query(Student).filter(Student.email == data.email).first()
            if student_exists:
                raise HTTPException(
                    status_code=403,
                    detail="Access Denied: This email is registered as a Student. Please log in from the Student portal."
                )
            raise HTTPException(status_code=401, detail="Invalid email")

        if not pwd_context.verify(data.password, teacher.password_hash):
            raise HTTPException(status_code=401, detail="Invalid password")

        # Update last login time
        teacher.last_login = datetime.datetime.utcnow()
        db.commit()

        # Generate JWT access token
        token_data = {"sub": teacher.email, "role": "Teacher", "user_id": teacher.id}
        access_token = create_access_token(data=token_data)
        
        return {
            "message": "Login successful",
            "access_token": access_token,
            "token_type": "bearer",
            "role": "Teacher",
            "user": {
                "id": teacher.id,
                "first_name": teacher.first_name,
                "last_name": teacher.last_name,
                "email": teacher.email,
                "department": teacher.department
            }
        }

    elif data.role == "Student":
        student = db.query(Student).filter(Student.email == data.email).first()
        if not student:
            # Check if they are registered as teacher instead to output correct error
            teacher_exists = db.query(Teacher).filter(Teacher.email == data.email).first()
            if teacher_exists:
                raise HTTPException(
                    status_code=403,
                    detail="Access Denied: This email is registered as a Teacher. Please log in from the Teacher portal."
                )
            raise HTTPException(status_code=401, detail="Invalid email")

        # Query user credentials table
        credentials = db.query(User).filter(User.email == data.email).first()
        if not credentials or not pwd_context.verify(data.password, credentials.password):
            raise HTTPException(status_code=401, detail="Invalid password")

        # Generate JWT access token
        token_data = {"sub": student.email, "role": "Student", "user_id": student.id}
        access_token = create_access_token(data=token_data)

        return {
            "message": "Login successful",
            "access_token": access_token,
            "token_type": "bearer",
            "role": "Student",
            "user": {
                "id": student.id,
                "name": student.name,
                "email": student.email,
                "roll_number": student.roll_number,
                "semester": student.semester,
                "section": student.section,
                "department": student.department
            }
        }
    else:
        raise HTTPException(status_code=400, detail="Invalid role specified")

# ---------------------------
# CLASS CREATION FLOW APIs
# ---------------------------

@app.post("/classes", response_model=ClassResponse)
def create_class(data: ClassCreate, db: Session = Depends(get_db)):
    # Verify teacher exists
    teacher = db.query(Teacher).filter(Teacher.id == data.teacher_id).first()
    if not teacher:
        raise HTTPException(status_code=404, detail="Teacher not found")

    new_class = Class(
        class_name=data.class_name,
        semester=data.semester,
        section=data.section,
        department=data.department,
        subject=data.subject,
        academic_year=data.academic_year,
        teacher_id=data.teacher_id
    )

    db.add(new_class)
    
    # Increment teacher's total class count analytics field
    teacher.total_classes += 1

    db.commit()
    db.refresh(new_class)
    return new_class

@app.get("/students/search", response_model=List[StudentResponse])
def search_students(
    query: Optional[str] = Query(None, description="Search by name, email, or roll number"),
    department: Optional[str] = Query(None, description="Filter by department"),
    semester: Optional[str] = Query(None, description="Filter by semester"),
    db: Session = Depends(get_db)
):
    stmt = db.query(Student).filter(Student.status == "Active")

    if department:
        stmt = stmt.filter(Student.department == department)
    if semester:
        stmt = stmt.filter(Student.semester == semester)
    
    if query:
        search_filter = f"%{query}%"
        stmt = stmt.filter(
            (Student.name.ilike(search_filter)) |
            (Student.email.ilike(search_filter)) |
            (Student.roll_number.ilike(search_filter))
        )

    return stmt.all()

@app.post("/classes/{class_id}/students")
def add_students_to_class(class_id: int, payload: AddStudentsRequest, db: Session = Depends(get_db)):
    cls = db.query(Class).filter(Class.id == class_id).first()
    if not cls:
        raise HTTPException(status_code=404, detail="Class not found")

    # Fetch teacher to update analytics later
    teacher = db.query(Teacher).filter(Teacher.id == cls.teacher_id).first()

    added_count = 0
    for sid in payload.student_ids:
        student = db.query(Student).filter(Student.id == sid).first()
        if student and student not in cls.students:
            cls.students.append(student)
            added_count += 1

    if added_count > 0:
        # Update teacher analytics cache of total students taught
        # Count all unique students across all classes taught by this teacher
        total_unique_students = db.query(Student).join(
            class_students
        ).join(
            Class
        ).filter(
            Class.teacher_id == cls.teacher_id
        ).distinct().count()

        if teacher:
            teacher.total_students = total_unique_students

        db.commit()

    return {"message": f"Successfully associated {added_count} students with the class."}

@app.get("/classes/{class_id}/attendance", response_model=List[StudentResponse])
def get_class_attendance_list(class_id: int, db: Session = Depends(get_db)):
    cls = db.query(Class).filter(Class.id == class_id).first()
    if not cls:
        raise HTTPException(status_code=404, detail="Class not found")

    # Returns the associated students list which acts as the attendance register
    return cls.students