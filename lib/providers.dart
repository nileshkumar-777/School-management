import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:convert';

// Notifier class to manage the active bottom navigation tab index
class NavigationNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

// NotifierProvider to expose the navigation state
final navigationProvider = NotifierProvider<NavigationNotifier, int>(
  NavigationNotifier.new,
);

// StreamProvider to monitor the Firebase Auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// --- Dynamic Academic State Models ---

class ClassModel {
  final String id; // e.g. "CSE 1A"
  final String name; // e.g. "Database Management Systems"
  final String subject;
  final String semester;
  final String section;
  final String department;
  final List<String> enrolledStudents;
  final String time;
  final Color color;
  final Color textColor;

  int get studentsCount => enrolledStudents.length;

  ClassModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.semester,
    required this.section,
    required this.department,
    required this.enrolledStudents,
    required this.time,
    required this.color,
    required this.textColor,
  });
}

class PostModel {
  final String id;
  final String type; // "Homework", "Notice", "Alert"
  final String title;
  final String description;
  final String targetClass;
  final DateTime date;
  final String category; // e.g. "Urgent", "Meeting", "Event", "Academic"
  final Color color;
  final String? attachment;

  PostModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.targetClass,
    required this.date,
    required this.category,
    required this.color,
    this.attachment,
  });
}

class QueryReply {
  final String sender;
  final String senderRole; // "Teacher" or "Student"
  final String message;
  final DateTime time;

  QueryReply({
    required this.sender,
    required this.senderRole,
    required this.message,
    required this.time,
  });
}

class QueryModel {
  final String id;
  final String student;
  final String classId;
  final String subject;
  final String topic;
  final DateTime time;
  final String queryText;
  final String status; // "Pending", "Answered"
  final List<QueryReply> replies;
  final Color color;

  QueryModel({
    required this.id,
    required this.student,
    required this.classId,
    required this.subject,
    required this.topic,
    required this.time,
    required this.queryText,
    required this.status,
    required this.replies,
    required this.color,
  });
}

// --- Dynamic State Notifiers ---

class ClassesNotifier extends Notifier<List<ClassModel>> {
  File get _file => File('${Directory.systemTemp.path}/classes_registry.json');

  @override
  List<ClassModel> build() {
    final defaultClasses = [
      ClassModel(
        id: "CSE 1A",
        name: "Database Management Systems",
        subject: "DBMS",
        semester: "3",
        section: "A",
        department: "CSE",
        enrolledStudents: const [],
        time: "Monday, Wednesday • 9:00 AM",
        color: const Color(0xFFD3E3FD),
        textColor: const Color(0xFF0F2C59),
      ),
    ];

    try {
      if (_file.existsSync()) {
        final content = _file.readAsStringSync();
        final List<dynamic> jsonList = jsonDecode(content);
        return jsonList.map((item) {
          return ClassModel(
            id: item['id'] as String,
            name: item['name'] as String,
            subject: item['subject'] as String,
            semester: item['semester'] as String,
            section: item['section'] as String,
            department: item['department'] as String,
            enrolledStudents: List<String>.from(
              item['enrolledStudents'] as List,
            ),
            time: item['time'] as String,
            color: Color(item['color'] as int),
            textColor: Color(item['textColor'] as int),
          );
        }).toList();
      }
    } catch (e) {
      debugPrint("Error loading classes: $e");
    }

    return defaultClasses;
  }

  void addClass(ClassModel c) {
    state = [...state, c];
    _save();
  }

  void addStudentsToClass(String classId, List<String> studentNames) {
    state = [
      for (final c in state)
        if (c.id == classId)
          ClassModel(
            id: c.id,
            name: c.name,
            subject: c.subject,
            semester: c.semester,
            section: c.section,
            department: c.department,
            enrolledStudents: {...c.enrolledStudents, ...studentNames}.toList(),
            time: c.time,
            color: c.color,
            textColor: c.textColor,
          )
        else
          c,
    ];
    _save();
  }

  void removeStudentFromClass(String classId, String studentName) {
    state = [
      for (final c in state)
        if (c.id == classId)
          ClassModel(
            id: c.id,
            name: c.name,
            subject: c.subject,
            semester: c.semester,
            section: c.section,
            department: c.department,
            enrolledStudents: c.enrolledStudents.where((name) => name != studentName).toList(),
            time: c.time,
            color: c.color,
            textColor: c.textColor,
          )
        else
          c,
    ];
    _save();
  }

  void removeStudentFromAllClasses(String studentName) {
    state = [
      for (final c in state)
        ClassModel(
          id: c.id,
          name: c.name,
          subject: c.subject,
          semester: c.semester,
          section: c.section,
          department: c.department,
          enrolledStudents: c.enrolledStudents.where((name) => name != studentName).toList(),
          time: c.time,
          color: c.color,
          textColor: c.textColor,
        ),
    ];
    _save();
  }

  void _save() {
    try {
      final jsonList = state
          .map(
            (c) => {
              'id': c.id,
              'name': c.name,
              'subject': c.subject,
              'semester': c.semester,
              'section': c.section,
              'department': c.department,
              'enrolledStudents': c.enrolledStudents,
              'time': c.time,
              'color': c.color.toARGB32(),
              'textColor': c.textColor.toARGB32(),
            },
          )
          .toList();
      _file.writeAsStringSync(jsonEncode(jsonList));
    } catch (e) {
      debugPrint("Error saving classes: $e");
    }
  }
}

final classesProvider = NotifierProvider<ClassesNotifier, List<ClassModel>>(
  ClassesNotifier.new,
);

class PostsNotifier extends Notifier<List<PostModel>> {
  @override
  List<PostModel> build() => [];

  void addPost(PostModel p) {
    state = [...state, p];
  }
}

final postsProvider = NotifierProvider<PostsNotifier, List<PostModel>>(
  PostsNotifier.new,
);

class QueriesNotifier extends Notifier<List<QueryModel>> {
  File get _file => File('${Directory.systemTemp.path}/queries.json');

  @override
  List<QueryModel> build() {
    try {
      if (_file.existsSync()) {
        final content = _file.readAsStringSync();
        final List<dynamic> jsonList = jsonDecode(content);
        return jsonList.map((item) {
          final List<dynamic> rawReplies = item['replies'] as List? ?? [];
          final repliesList = rawReplies.map((r) {
            return QueryReply(
              sender: r['sender'] as String,
              senderRole: r['senderRole'] as String,
              message: r['message'] as String,
              time: DateTime.parse(r['time'] as String),
            );
          }).toList();

          return QueryModel(
            id: item['id'] as String,
            student: item['student'] as String,
            classId: item['classId'] as String,
            subject: item['subject'] as String,
            topic: item['topic'] as String,
            time: DateTime.parse(item['time'] as String),
            queryText: item['queryText'] as String,
            status: item['status'] as String,
            replies: repliesList,
            color: Color(item['color'] as int),
          );
        }).toList();
      }
    } catch (e) {
      debugPrint("Error loading queries: $e");
    }
    return [];
  }

  void addQuery(QueryModel q) {
    state = [...state, q];
    _save();
  }

  void addReply(String queryId, QueryReply reply) {
    state = [
      for (final q in state)
        if (q.id == queryId)
          QueryModel(
            id: q.id,
            student: q.student,
            classId: q.classId,
            subject: q.subject,
            topic: q.topic,
            time: q.time,
            queryText: q.queryText,
            status: "Answered",
            replies: [...q.replies, reply],
            color: q.color,
          )
        else
          q,
    ];
    _save();
  }

  void answerQuery(String id, String replyText) {
    addReply(
      id,
      QueryReply(
        sender: "Dr. Sharma",
        senderRole: "Teacher",
        message: replyText,
        time: DateTime.now(),
      ),
    );
  }

  void _save() {
    try {
      final jsonList = state.map((q) => {
        'id': q.id,
        'student': q.student,
        'classId': q.classId,
        'subject': q.subject,
        'topic': q.topic,
        'time': q.time.toIso8601String(),
        'queryText': q.queryText,
        'status': q.status,
        'color': q.color.toARGB32(),
        'replies': q.replies.map((r) => {
          'sender': r.sender,
          'senderRole': r.senderRole,
          'message': r.message,
          'time': r.time.toIso8601String(),
        }).toList(),
      }).toList();
      _file.writeAsStringSync(jsonEncode(jsonList));
    } catch (e) {
      debugPrint("Error saving queries: $e");
    }
  }
}

final queriesProvider = NotifierProvider<QueriesNotifier, List<QueryModel>>(
  QueriesNotifier.new,
);

class StudentRegistryModel {
  final String name;
  final String email;

  StudentRegistryModel({required this.name, required this.email});
}

class RegisteredStudentsNotifier extends Notifier<List<StudentRegistryModel>> {
  File get _file =>
      File('${Directory.systemTemp.path}/registered_students.json');

  @override
  List<StudentRegistryModel> build() {
    final defaultStudents = [
      StudentRegistryModel(name: "Aman Gupta", email: "aman@student.com"),
      StudentRegistryModel(name: "Priya Singh", email: "priya@student.com"),
      StudentRegistryModel(name: "Rahul Sharma", email: "rahul@student.com"),
      StudentRegistryModel(name: "Abhishek Das", email: "abhishek@student.com"),
      StudentRegistryModel(name: "Riya Sen", email: "riya@student.com"),
      StudentRegistryModel(name: "Arjun Nair", email: "arjun@student.com"),
      StudentRegistryModel(name: "Sneha Reddy", email: "sneha@student.com"),
      StudentRegistryModel(
        name: "Vikram Malhotra",
        email: "vikram@student.com",
      ),
      StudentRegistryModel(name: "Neha Patel", email: "neha@student.com"),
      StudentRegistryModel(name: "Kabir Mehta", email: "kabir@student.com"),
      StudentRegistryModel(name: "Ishita Joshi", email: "ishita@student.com"),
    ];

    try {
      if (_file.existsSync()) {
        final content = _file.readAsStringSync();
        final List<dynamic> jsonList = jsonDecode(content);
        final persisted = jsonList.map((item) {
          return StudentRegistryModel(
            name: item['name'] as String,
            email: item['email'] as String,
          );
        }).toList();

        // Combine default students and persisted ones, ensuring uniqueness by email
        final all = [...defaultStudents, ...persisted];
        final unique = <String, StudentRegistryModel>{};
        for (final s in all) {
          unique[s.email] = s;
        }
        return unique.values.toList();
      }
    } catch (e) {
      debugPrint("Error loading registered students: $e");
    }

    return defaultStudents;
  }

  void registerStudent(StudentRegistryModel student) {
    state = [...state, student];
    _save();
  }

  void deleteStudent(String email) {
    state = state.where((s) => s.email != email).toList();
    _save();
  }

  void _save() {
    try {
      final jsonList = state
          .map((s) => {'name': s.name, 'email': s.email})
          .toList();
      _file.writeAsStringSync(jsonEncode(jsonList));
    } catch (e) {
      debugPrint("Error saving registered students: $e");
    }
  }
}

final registeredStudentsProvider =
    NotifierProvider<RegisteredStudentsNotifier, List<StudentRegistryModel>>(
      RegisteredStudentsNotifier.new,
    );

class AcademicPerformanceModel {
  final String id;
  final String studentEmail;
  final String studentName;
  final String subject;
  final String examName;
  final double marksObtained;
  final double maxMarks;
  final String grade;
  final String remarks;
  final DateTime date;

  AcademicPerformanceModel({
    required this.id,
    required this.studentEmail,
    required this.studentName,
    required this.subject,
    required this.examName,
    required this.marksObtained,
    required this.maxMarks,
    required this.grade,
    required this.remarks,
    required this.date,
  });
}

class AcademicsNotifier extends Notifier<List<AcademicPerformanceModel>> {
  File get _file => File('${Directory.systemTemp.path}/academics.json');

  @override
  List<AcademicPerformanceModel> build() {
    try {
      if (_file.existsSync()) {
        final content = _file.readAsStringSync();
        final List<dynamic> jsonList = jsonDecode(content);
        return jsonList.map((item) {
          return AcademicPerformanceModel(
            id: item['id'] as String,
            studentEmail: item['studentEmail'] as String,
            studentName: item['studentName'] as String,
            subject: item['subject'] as String,
            examName: item['examName'] as String,
            marksObtained: (item['marksObtained'] as num).toDouble(),
            maxMarks: (item['maxMarks'] as num).toDouble(),
            grade: item['grade'] as String,
            remarks: item['remarks'] as String,
            date: DateTime.parse(item['date'] as String),
          );
        }).toList();
      }
    } catch (e) {
      debugPrint("Error loading academics: $e");
    }
    return [];
  }

  void addPerformance(AcademicPerformanceModel record) {
    state = [...state, record];
    _save();
  }

  void _save() {
    try {
      final jsonList = state
          .map(
            (item) => {
              'id': item.id,
              'studentEmail': item.studentEmail,
              'studentName': item.studentName,
              'subject': item.subject,
              'examName': item.examName,
              'marksObtained': item.marksObtained,
              'maxMarks': item.maxMarks,
              'grade': item.grade,
              'remarks': item.remarks,
              'date': item.date.toIso8601String(),
            },
          )
          .toList();
      _file.writeAsStringSync(jsonEncode(jsonList));
    } catch (e) {
      debugPrint("Error saving academics: $e");
    }
  }
}

final academicsProvider =
    NotifierProvider<AcademicsNotifier, List<AcademicPerformanceModel>>(
      AcademicsNotifier.new,
    );

String calculateSchoolGrade(double marks, double maxMarks) {
  if (maxMarks <= 0) return "F";
  final percentage = (marks / maxMarks) * 100;
  if (percentage >= 90) return "A+";
  if (percentage >= 80) return "A";
  if (percentage >= 70) return "B";
  if (percentage >= 60) return "C";
  if (percentage >= 50) return "D";
  if (percentage >= 40) return "E";
  return "F";
}

class HomeworkSubmissionModel {
  final String id;
  final String homeworkId;
  final String studentEmail;
  final String studentName;
  final String submissionText;
  final DateTime submittedAt;

  HomeworkSubmissionModel({
    required this.id,
    required this.homeworkId,
    required this.studentEmail,
    required this.studentName,
    required this.submissionText,
    required this.submittedAt,
  });
}

class HomeworkSubmissionsNotifier extends Notifier<List<HomeworkSubmissionModel>> {
  File get _file => File('${Directory.systemTemp.path}/homework_submissions.json');

  @override
  List<HomeworkSubmissionModel> build() {
    try {
      if (_file.existsSync()) {
        final content = _file.readAsStringSync();
        final List<dynamic> jsonList = jsonDecode(content);
        return jsonList.map((item) {
          return HomeworkSubmissionModel(
            id: item['id'] as String,
            homeworkId: item['homeworkId'] as String,
            studentEmail: item['studentEmail'] as String,
            studentName: item['studentName'] as String,
            submissionText: item['submissionText'] as String,
            submittedAt: DateTime.parse(item['submittedAt'] as String),
          );
        }).toList();
      }
    } catch (e) {
      debugPrint("Error loading homework submissions: $e");
    }
    return [];
  }

  void addSubmission(HomeworkSubmissionModel submission) {
    // Check if the student has already submitted for this homework. If yes, replace it; if not, add it.
    final existingIndex = state.indexWhere(
      (s) => s.homeworkId == submission.homeworkId && s.studentEmail == submission.studentEmail,
    );

    if (existingIndex != -1) {
      final updatedList = List<HomeworkSubmissionModel>.from(state);
      updatedList[existingIndex] = submission;
      state = updatedList;
    } else {
      state = [...state, submission];
    }
    _save();
  }

  void _save() {
    try {
      final jsonList = state.map((item) => {
        'id': item.id,
        'homeworkId': item.homeworkId,
        'studentEmail': item.studentEmail,
        'studentName': item.studentName,
        'submissionText': item.submissionText,
        'submittedAt': item.submittedAt.toIso8601String(),
      }).toList();
      _file.writeAsStringSync(jsonEncode(jsonList));
    } catch (e) {
      debugPrint("Error saving homework submissions: $e");
    }
  }
}

final homeworkSubmissionsProvider = NotifierProvider<HomeworkSubmissionsNotifier, List<HomeworkSubmissionModel>>(
  HomeworkSubmissionsNotifier.new,
);
