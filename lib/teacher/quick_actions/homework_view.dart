import 'package:flutter/material.dart';

class HomeworkView extends StatelessWidget {
  const HomeworkView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeworks = [
      {
        "title": "Assignment 3: Relational Algebra & SQL",
        "classId": "CSE 1A",
        "subject": "Database Management Systems",
        "dueDate": "June 28, 2026 • 11:59 PM",
        "submitted": 35,
        "total": 45,
        "status": "Active",
        "statusColor": const Color(0xFF4CAF50),
        "color": const Color(0xFFD3E3FD),
      },
      {
        "title": "Lab Practical 2: Graph Implementations",
        "classId": "CSE 1B",
        "subject": "Data Structures & Algorithms",
        "dueDate": "June 30, 2026 • 2:00 PM",
        "submitted": 20,
        "total": 42,
        "status": "Active",
        "statusColor": const Color(0xFF4CAF50),
        "color": const Color(0xFFE2EDFF),
      },
      {
        "title": "Assignment 2: Process Scheduling Algorithms",
        "classId": "CSE 2A",
        "subject": "Operating Systems",
        "dueDate": "June 24, 2026 • 11:59 PM",
        "submitted": 48,
        "total": 48,
        "status": "Grading",
        "statusColor": const Color(0xFFFF9800),
        "color": const Color(0xFFFCE9A4),
      },
      {
        "title": "Problem Set 1: Combinational Logic",
        "classId": "ECE 1A",
        "subject": "Digital Electronics",
        "dueDate": "June 18, 2026 • 5:00 PM",
        "submitted": 40,
        "total": 40,
        "status": "Closed",
        "statusColor": Colors.grey,
        "color": const Color(0xFFE8F5E9),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F2C59)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Homework Assignments",
          style: TextStyle(
            color: Color(0xFF0F2C59),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF0F2C59)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: homeworks.length,
        itemBuilder: (context, index) {
          final hw = homeworks[index];
          final double progress = (hw["submitted"] as int) / (hw["total"] as int);

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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: hw["color"] as Color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hw["classId"] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: (hw["statusColor"] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          hw["status"] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: hw["statusColor"] as Color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    hw["title"] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F2C59),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hw["subject"] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Submissions: ${hw["submitted"]}/${hw["total"]}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "${(progress * 100).toInt()}% Done",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: progress == 1.0 ? Colors.green : const Color(0xFF0F2C59),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress == 1.0 ? Colors.green : const Color(0xFF0F2C59),
                      ),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        hw["dueDate"] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "View submissions",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F2C59),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right, size: 16, color: Color(0xFF0F2C59)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F2C59),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
