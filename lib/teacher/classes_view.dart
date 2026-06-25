import 'package:flutter/material.dart';

class ClassesView extends StatelessWidget {
  const ClassesView({super.key});

  @override
  Widget build(BuildContext context) {
    final classes = [
      {
        "id": "CSE 1A",
        "name": "Data Structures & Algorithms",
        "students": 45,
        "time": "Monday, Wednesday • 9:00 AM",
        "color": const Color(0xFFD3E3FD),
        "textColor": const Color(0xFF0F2C59),
      },
      {
        "id": "CSE 1B",
        "name": "Object Oriented Programming",
        "students": 42,
        "time": "Monday, Thursday • 11:30 AM",
        "color": const Color(0xFFE2EDFF),
        "textColor": const Color(0xFF0F2C59),
      },
      {
        "id": "CSE 2A",
        "name": "Operating Systems & Kernels",
        "students": 48,
        "time": "Tuesday, Friday • 10:00 AM",
        "color": const Color(0xFFFCE9A4),
        "textColor": const Color(0xFF9E8B2A),
      },
      {
        "id": "ECE 1A",
        "name": "Digital Electronics & Circuits",
        "students": 40,
        "time": "Wednesday, Friday • 2:00 PM",
        "color": const Color(0xFFE8F5E9),
        "textColor": Colors.green.shade800,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "My Classes",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F2C59),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "View schedule, enrollments, and syllabus progress for your assigned courses.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: ListView.builder(
              itemCount: classes.length,
              itemBuilder: (context, index) {
                final c = classes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
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
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: c['color'] as Color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.book_outlined, color: c['textColor'] as Color),
                      ),
                      title: Text(
                        c['id'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF0F2C59),
                        ),
                      ),
                      subtitle: Text(
                        c['name'] as String,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(height: 1),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.people_outline, size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${c['students']} Students Enrolled",
                                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      c['time'] as String,
                                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text("View Roster"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: c['color'] as Color,
                                      foregroundColor: c['textColor'] as Color,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text("Manage Class"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
