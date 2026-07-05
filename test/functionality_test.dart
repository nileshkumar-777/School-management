import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/student/ai_view.dart';
import 'package:project/providers.dart';

void main() {
  group('AI Tutor getMockAiResponse Tests', () {
    test('Dynamic Counting Parser: count till 10', () {
      final response = getMockAiResponse("count till 10");
      expect(response, contains("1, 2, 3, 4, 5, 6, 7, 8, 9, 10"));
    });

    test('Dynamic Counting Parser: count to 5', () {
      final response = getMockAiResponse("count to 5");
      expect(response, contains("1, 2, 3, 4, 5"));
    });

    test('Dynamic Counting Parser: count to large number limit', () {
      final response = getMockAiResponse("count to 200");
      expect(response, contains("That is a large number to count!"));
    });

    test('Simple Math Solver: 2 + 2', () {
      final response = getMockAiResponse("what is 2 + 2");
      expect(response, contains("result of 2 + 2 is 4"));
    });

    test('Simple Math Solver: 15 * 6', () {
      final response = getMockAiResponse("15 * 6");
      expect(response, contains("result of 15 * 6 is 90"));
    });

    test('Simple Math Solver: division by zero safety', () {
      final response = getMockAiResponse("20 / 0");
      expect(response, contains("Division by zero is undefined"));
    });

    test('Conversational Keywords: explain deadlock', () {
      final response = getMockAiResponse("explain deadlock");
      expect(response, contains("Mutual Exclusion, Hold & Wait"));
    });

    test('Conversational Keywords: joke', () {
      final response = getMockAiResponse("tell a joke");
      expect(response, contains("C#"));
    });

    test('Document Context matches', () {
      final response = getMockAiResponse(
        "tell me about indexing",
        docName: "DBMS_Lecture_Notes.pdf",
        pageNumber: 3,
        pageTitle: "B-Tree and B+ Tree Indexing",
        pageContent: "Indexing speeds up query execution.",
      );
      expect(response, contains("B+ Trees store data pointers only at the leaf level"));
    });
  });

  group('School Grade Calculation Tests', () {
    test('A+ Grade check', () {
      expect(calculateSchoolGrade(95, 100), equals('A+'));
    });

    test('A Grade check', () {
      expect(calculateSchoolGrade(82, 100), equals('A'));
    });

    test('F Grade check', () {
      expect(calculateSchoolGrade(30, 100), equals('F'));
    });

    test('Divide by zero safety check', () {
      expect(calculateSchoolGrade(10, 0), equals('F'));
    });
  });

  group('Master Weekly Schedule Tests', () {
    test('Verify schedule contains Monday class slots', () {
      final container = ProviderContainer();
      final allSlots = container.read(masterScheduleProvider);
      final mondaySlots = allSlots.where((s) => s.day == 'Monday').toList();
      expect(mondaySlots.length, equals(5));
      expect(mondaySlots.first.instructor, equals('Dr. Sharma'));
      expect(mondaySlots.first.subject, equals('Data Structures & Algorithms'));
    });

    test('Verify schedule contains classes across days', () {
      final container = ProviderContainer();
      final allSlots = container.read(masterScheduleProvider);
      final cse1aSlots = allSlots.where((s) => s.classId == 'CSE 1A').toList();
      expect(cse1aSlots.isNotEmpty, isTrue);
      final daysWithClasses = cse1aSlots.map((s) => s.day).toSet();
      expect(daysWithClasses.contains('Monday'), isTrue);
      expect(daysWithClasses.contains('Wednesday'), isTrue);
      expect(daysWithClasses.contains('Friday'), isTrue);
    });
  });
}
