# models.py

import datetime
from sqlalchemy import Column, Integer, String, Boolean, DateTime, Date, ForeignKey, Table, Text
from sqlalchemy.orm import relationship
from database import Base

# Association table for Many-to-Many relationship between Class and Student
class_students = Table(
    "class_students",
    Base.metadata,
    Column("class_id", Integer, ForeignKey("classes.id", ondelete="CASCADE"), primary_key=True),
    Column("student_id", Integer, ForeignKey("students.id", ondelete="CASCADE"), primary_key=True),
)

# User table for legacy / general accounts
class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False, index=True)
    password = Column(String, nullable=False)
    role = Column(String, nullable=False)  # "Teacher" or "Student"

# Teacher table
class Teacher(Base):
    __tablename__ = "teachers"

    id = Column(Integer, primary_key=True, index=True)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False, index=True)
    password_hash = Column(String, nullable=False)
    employee_id = Column(String, nullable=True)
    phone_number = Column(String, nullable=True)
    gender = Column(String, nullable=True)  # Male / Female / Other
    date_of_birth = Column(Date, nullable=True)
    department = Column(String, nullable=True)  # CSE, ECE, etc.
    designation = Column(String, nullable=True)  # Professor, Assistant Professor, HOD, etc.
    qualification = Column(String, nullable=True)  # M.Tech, PhD, etc.
    joining_date = Column(Date, nullable=True)
    profile_photo = Column(String, nullable=True)
    address = Column(Text, nullable=True)
    status = Column(String, default="Active")  # Active / Inactive
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.datetime.utcnow, onupdate=datetime.datetime.utcnow)

    # AI / Analytics Fields
    total_classes = Column(Integer, default=0)
    total_students = Column(Integer, default=0)
    total_homeworks = Column(Integer, default=0)
    total_notices = Column(Integer, default=0)
    total_notes = Column(Integer, default=0)
    ai_enabled = Column(Boolean, default=True)
    last_login = Column(DateTime, nullable=True)

    # Relationships
    classes = relationship("Class", back_populates="teacher", cascade="all, delete-orphan")

# Student table
class Student(Base):
    __tablename__ = "students"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False, index=True)
    roll_number = Column(String, unique=True, nullable=True)
    semester = Column(String, nullable=True)
    section = Column(String, nullable=True)
    department = Column(String, nullable=True)
    status = Column(String, default="Active")  # Active / Inactive
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

    # Relationships
    classes = relationship("Class", secondary=class_students, back_populates="students")

# Class table
class Class(Base):
    __tablename__ = "classes"

    id = Column(Integer, primary_key=True, index=True)
    class_name = Column(String, nullable=False)
    semester = Column(String, nullable=False)
    section = Column(String, nullable=False)
    department = Column(String, nullable=False)
    subject = Column(String, nullable=False)
    academic_year = Column(String, nullable=False)
    teacher_id = Column(Integer, ForeignKey("teachers.id", ondelete="CASCADE"), nullable=False)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

    # Relationships
    teacher = relationship("Teacher", back_populates="classes")
    students = relationship("Student", secondary=class_students, back_populates="classes")