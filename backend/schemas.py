# schemas.py

import datetime
from pydantic import BaseModel, EmailStr
from typing import List, Optional

# Basic Register request for User
class RegisterUser(BaseModel):
    name: str
    email: EmailStr
    password: str
    role: str

# Login request incorporating Role validation
class LoginRequest(BaseModel):
    email: EmailStr
    password: str
    role: str  # "Teacher" or "Student"

# Teacher Schemas
class TeacherRegister(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr
    password: str
    employee_id: Optional[str] = None
    phone_number: Optional[str] = None
    gender: Optional[str] = None
    date_of_birth: Optional[datetime.date] = None
    department: Optional[str] = None
    designation: Optional[str] = None
    qualification: Optional[str] = None
    joining_date: Optional[datetime.date] = None
    profile_photo: Optional[str] = None
    address: Optional[str] = None

class TeacherResponse(BaseModel):
    id: int
    first_name: str
    last_name: str
    email: str
    employee_id: Optional[str]
    phone_number: Optional[str]
    gender: Optional[str]
    date_of_birth: Optional[datetime.date]
    department: Optional[str]
    designation: Optional[str]
    qualification: Optional[str]
    joining_date: Optional[datetime.date]
    profile_photo: Optional[str]
    address: Optional[str]
    status: str
    created_at: datetime.datetime
    updated_at: datetime.datetime
    total_classes: int
    total_students: int
    total_homeworks: int
    total_notices: int
    total_notes: int
    ai_enabled: bool
    last_login: Optional[datetime.datetime]

    class Config:
        from_attributes = True

# Student Schemas
class StudentRegister(BaseModel):
    name: str
    email: EmailStr
    password: str
    roll_number: Optional[str] = None
    semester: Optional[str] = None
    section: Optional[str] = None
    department: Optional[str] = None

class StudentResponse(BaseModel):
    id: int
    name: str
    email: str
    roll_number: Optional[str]
    semester: Optional[str]
    section: Optional[str]
    department: Optional[str]
    status: str
    created_at: datetime.datetime

    class Config:
        from_attributes = True

# Class Schemas
class ClassCreate(BaseModel):
    class_name: str
    semester: str
    section: str
    department: str
    subject: str
    academic_year: str
    teacher_id: int

class ClassResponse(BaseModel):
    id: int
    class_name: str
    semester: str
    section: str
    department: str
    subject: str
    academic_year: str
    teacher_id: int
    created_at: datetime.datetime

    class Config:
        from_attributes = True

class AddStudentsRequest(BaseModel):
    student_ids: List[int]