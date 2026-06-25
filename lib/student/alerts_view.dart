import 'package:flutter/material.dart';

class AlertsView extends StatelessWidget {
  const AlertsView({super.key});

  @override
  Widget build(BuildContext context) {
    final notices = [
      {
        "title": "Assignment 3 Published",
        "description": "New Homework Assignment 3 on B-Trees has been added. Submit before tomorrow midnight.",
        "time": "2h ago",
        "icon": Icons.assignment_outlined,
        "color": const Color(0xFFFFD9D9),
        "iconColor": Colors.red,
      },
      {
        "title": "Mid Semester Exam Schedule",
        "description": "Exams begin next Monday. Detailed timetable has been posted on the main board.",
        "time": "4h ago",
        "icon": Icons.campaign_outlined,
        "color": const Color(0xFFE2EDFF),
        "iconColor": Colors.blue,
      },
      {
        "title": "DBMS Lab Submission",
        "description": "Lab file evaluation for DBMS will take place in the computer lab this Thursday.",
        "time": "Yesterday",
        "icon": Icons.warning_amber_rounded,
        "color": const Color(0xFFFFE0B2),
        "iconColor": Colors.orange,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Alerts & Notices",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F2C59),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Check urgent warnings and announcements from your teachers and department.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: ListView.builder(
              itemCount: notices.length,
              itemBuilder: (context, index) {
                final note = notices[index];
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: note['color'] as Color,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            note['icon'] as IconData,
                            color: note['iconColor'] as Color,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          note['title'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                        subtitle: Text(
                          note['time'] as String,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                note['description'] as String,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.grey.shade800,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
