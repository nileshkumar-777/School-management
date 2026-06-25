import 'package:flutter/material.dart';

class NoticeView extends StatelessWidget {
  const NoticeView({super.key});

  @override
  Widget build(BuildContext context) {
    final notices = [
      {
        "title": "Postponement of OS Class Test",
        "category": "Urgent",
        "categoryColor": Colors.red,
        "date": "Today • 10:15 AM",
        "body": "The Operating Systems class test scheduled for June 25th has been postponed to June 29th due to the campus recruitment drive.",
        "target": "CSE 2A",
        "pinned": true,
      },
      {
        "title": "Parent Teacher Review Meeting",
        "category": "Meeting",
        "categoryColor": Colors.blue,
        "date": "Yesterday • 4:30 PM",
        "body": "A virtual parent-teacher review session is scheduled for Saturday, June 27th to discuss the Mid-term performance. Meeting link will be shared via mail.",
        "target": "CSE 1A",
        "pinned": false,
      },
      {
        "title": "Guest Lecture: AI & Large Language Models",
        "category": "Event",
        "categoryColor": const Color(0xFF9E8B2A),
        "date": "June 20, 2026",
        "body": "Dr. Ramesh Sen from IIT Delhi will be delivering a guest lecture on 'Industrial Applications of LLMs' at Seminar Hall 2 at 10:00 AM.",
        "target": "All CS Students",
        "pinned": false,
      },
      {
        "title": "Summer Internship Project Submissions",
        "category": "Academic",
        "categoryColor": Colors.green,
        "date": "June 18, 2026",
        "body": "All students are required to submit their summer internship synopsis and approval letters by the end of this week to the department office.",
        "target": "CSE 2A & 2B",
        "pinned": false,
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
          "Notices & Circulars",
          style: TextStyle(
            color: Color(0xFF0F2C59),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF0F2C59)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: notices.length,
        itemBuilder: (context, index) {
          final notice = notices[index];
          final bool isUrgent = notice["category"] == "Urgent";

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: notice["pinned"] as bool
                  ? Border.all(color: const Color(0xFF0F2C59).withValues(alpha: 0.15), width: 1.5)
                  : null,
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
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: (notice["categoryColor"] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          notice["category"] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: notice["categoryColor"] as Color,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (notice["pinned"] as bool)
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.push_pin, size: 14, color: Color(0xFF0F2C59)),
                        ),
                      Text(
                        notice["date"] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    notice["title"] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isUrgent ? Colors.red.shade900 : const Color(0xFF0F2C59),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notice["body"] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.people_outline, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        "Target: ${notice["target"]}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share_outlined, size: 18, color: Colors.grey),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
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
        child: const Icon(Icons.campaign, color: Colors.white),
      ),
    );
  }
}
