import 'package:flutter/material.dart';

class AlertsView extends StatefulWidget {
  const AlertsView({super.key});

  @override
  State<AlertsView> createState() => _AlertsViewState();
}

class _AlertsViewState extends State<AlertsView> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> alerts = [
    {
      "title": "12 New Homework Submissions",
      "description": "DBMS Assignment 3",
      "time": "10 min ago",
      "type": "Urgent",
      "icon": Icons.assignment_outlined,
      "color": const Color(0xFFFFD9D9),
      "iconColor": Colors.red,
    },
    {
      "title": "5 New Student Queries",
      "description": "Need your response",
      "time": "30 min ago",
      "type": "Queries",
      "icon": Icons.chat_bubble_outline,
      "color": const Color(0xFFFFE0B2),
      "iconColor": Colors.orange,
    },
    {
      "title": "Attendance Not Marked",
      "description": "CSE 1A - DBMS",
      "time": "Today",
      "type": "Urgent",
      "icon": Icons.calendar_month_outlined,
      "color": const Color(0xFFE2EDFF),
      "iconColor": Colors.blue,
    },
    {
      "title": "New Class Assigned",
      "description": "CSE 2B added to your classes",
      "time": "Today",
      "type": "System",
      "icon": Icons.school_outlined,
      "color": const Color(0xFFE8F5E9),
      "iconColor": Colors.green,
    },
    {
      "title": "Timetable Updated",
      "description": "Room changed from 301 → 205",
      "time": "Yesterday",
      "type": "System",
      "icon": Icons.access_time_filled_outlined,
      "color": const Color(0xFFF3E5F5),
      "iconColor": Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredAlerts = selectedFilter == 'All'
        ? alerts
        : alerts.where((alert) => alert['type'] == selectedFilter).toList();

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
            "Stay updated with recent school announcements, warnings, and student queries.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Urgent', 'System', 'Queries'].map((filter) {
                final isSelected = selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF0F2C59),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    selectedColor: const Color(0xFF0F2C59),
                    checkmarkColor: Colors.white,
                    backgroundColor: const Color(0xFFEEF2F9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Alerts list
          Expanded(
            child: filteredAlerts.isEmpty
                ? const Center(
                    child: Text(
                      "No notices found under this filter.",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredAlerts.length,
                    itemBuilder: (context, index) {
                      final alert = filteredAlerts[index];
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
                                  color: alert['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  alert['icon'] as IconData,
                                  color: alert['iconColor'] as Color,
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                alert['title'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF0F2C59),
                                ),
                              ),
                              subtitle: Text(
                                alert['time'] as String,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      alert['description'] as String,
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
