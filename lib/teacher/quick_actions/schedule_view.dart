import 'package:flutter/material.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> weeklySchedule = {
      "Monday": [
        {
          "time": "09:00 AM - 10:00 AM",
          "subject": "Data Structures & Algorithms",
          "classId": "CSE 1A",
          "room": "Room 302, Block B",
          "type": "Theory Lecture",
          "color": const Color(0xFFD3E3FD),
          "isActive": false,
        },
        {
          "time": "11:30 AM - 12:30 PM",
          "subject": "Object Oriented Programming",
          "classId": "CSE 1B",
          "room": "Lab 3, Ground Floor",
          "type": "Lab Practical",
          "color": const Color(0xFFE2EDFF),
          "isActive": false,
        },
        {
          "time": "02:00 PM - 03:00 PM",
          "subject": "Database Management Systems",
          "classId": "CSE 1A",
          "room": "Room 304, Block B",
          "type": "Theory Lecture",
          "color": const Color(0xFFFCE9A4),
          "isActive": false,
        },
      ],
      "Tuesday": [
        {
          "time": "10:00 AM - 11:00 AM",
          "subject": "Operating Systems",
          "classId": "CSE 2A",
          "room": "Room 401, Block C",
          "type": "Theory Lecture",
          "color": const Color(0xFFFCE9A4),
          "isActive": false,
        },
        {
          "time": "11:30 AM - 01:30 PM",
          "subject": "Data Structures Lab",
          "classId": "CSE 1A",
          "room": "Lab 1, Ground Floor",
          "type": "Lab Practical",
          "color": const Color(0xFFD3E3FD),
          "isActive": false,
        },
      ],
      "Wednesday": [
        {
          "time": "09:00 AM - 10:00 AM",
          "subject": "Data Structures & Algorithms",
          "classId": "CSE 1A",
          "room": "Room 302, Block B",
          "type": "Theory Lecture",
          "color": const Color(0xFFD3E3FD),
          "isActive": false,
        },
        {
          "time": "02:00 PM - 03:30 PM",
          "subject": "Digital Electronics",
          "classId": "ECE 1A",
          "room": "Lab 4, Block A",
          "type": "Lab Practical",
          "color": const Color(0xFFE8F5E9),
          "isActive": false,
        },
      ],
      "Thursday": [
        {
          "time": "11:30 AM - 12:30 PM",
          "subject": "Object Oriented Programming",
          "classId": "CSE 1B",
          "room": "Room 301, Block B",
          "type": "Theory Lecture",
          "color": const Color(0xFFE2EDFF),
          "isActive": false,
        },
        {
          "time": "03:00 PM - 04:00 PM",
          "subject": "Operating Systems",
          "classId": "CSE 2A",
          "room": "Room 401, Block C",
          "type": "Theory Lecture",
          "color": const Color(0xFFFCE9A4),
          "isActive": false,
        },
      ],
      "Friday": [
        {
          "time": "10:00 AM - 11:00 AM",
          "subject": "Operating Systems",
          "classId": "CSE 2A",
          "room": "Room 401, Block C",
          "type": "Theory Lecture",
          "color": const Color(0xFFFCE9A4),
          "isActive": false,
        },
        {
          "time": "02:00 PM - 03:00 PM",
          "subject": "Digital Electronics",
          "classId": "ECE 1A",
          "room": "Room 205, Block A",
          "type": "Theory Lecture",
          "color": const Color(0xFFE8F5E9),
          "isActive": false,
        },
      ]
    };

    final days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];

    return DefaultTabController(
      length: days.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFEEF2F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF0F2C59)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            "Weekly Schedule",
            style: TextStyle(
              color: Color(0xFF0F2C59),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: const Color(0xFF0F2C59),
            labelColor: const Color(0xFF0F2C59),
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: days.map((day) => Tab(text: day.substring(0, 3))).toList(),
          ),
        ),
        body: TabBarView(
          children: days.map((day) {
            final slots = weeklySchedule[day] ?? [];

            if (slots.isEmpty) {
              return const Center(
                child: Text(
                  "No lectures scheduled for today.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: slots.length,
              itemBuilder: (context, index) {
                final slot = slots[index];

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
                  child: Row(
                    children: [
                      // Time indicator side-strip
                      Container(
                        width: 8,
                        height: 110,
                        decoration: BoxDecoration(
                          color: slot["color"] as Color,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    slot["time"] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF0F2C59),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEF2F9),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      slot["classId"] as String,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F2C59),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                slot["subject"] as String,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                slot["type"] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    slot["room"] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF0F2C59),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Rescheduling request form coming soon..."),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: const Icon(Icons.edit_calendar, color: Colors.white),
        ),
      ),
    );
  }
}
