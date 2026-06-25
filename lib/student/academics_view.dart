import 'package:flutter/material.dart';

class AcademicsView extends StatelessWidget {
  const AcademicsView({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      {"code": "CS-301", "name": "Data Structures & Algorithms", "attendance": "94%", "grade": "A"},
      {"code": "CS-302", "name": "Database Management Systems", "attendance": "78%", "grade": "B+"},
      {"code": "CS-303", "name": "Operating Systems & Kernels", "attendance": "88%", "grade": "A"},
      {"code": "EC-304", "name": "Digital Electronics", "attendance": "91%", "grade": "B-"},
    ];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "My Academics",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F2C59),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Monitor your attendance records, grades, and course resources.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final c = courses[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            c["code"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Grade: ${c['grade']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color(0xFF0F2C59),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        c["name"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF0F2C59),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle_outline, size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(
                                "Attendance: ${c['attendance']}",
                                style: const TextStyle(fontSize: 13, color: Colors.black87),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("View Syllabus"),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
