import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers.dart';
import 'package:project/student/quick_actions/homework_view.dart';
import 'package:project/student/quick_actions/notes_view.dart';
import 'package:project/student/quick_actions/schedule_view.dart';
import 'package:project/student/quick_actions/reader_view.dart';


class StudentHomeView extends ConsumerWidget {
  const StudentHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(user),
          const SizedBox(height: 24),
          _buildSectionTitle("TODAY'S SUMMARY"),
          const SizedBox(height: 12),
          _buildSummaryGrid(),
          const SizedBox(height: 24),
          _buildSectionTitle("QUICK ACTIONS"),
          const SizedBox(height: 12),
          _buildQuickActions(context, ref),
          const SizedBox(height: 24),
          _buildSectionTitle("TODAY'S CLASSES"),
          const SizedBox(height: 12),
          _buildTodayClasses(),
          const SizedBox(height: 24),
          _buildSectionTitle("RECENT ACTIVITY"),
          const SizedBox(height: 12),
          _buildRecentActivityList(),
          const SizedBox(height: 24),
          _buildSectionTitle("UPCOMING DEADLINES"),
          const SizedBox(height: 12),
          _buildUpcomingDeadlines(),
          const SizedBox(height: 40), // Bottom padding for scroll clearance
        ],
      ),
    );
  }

  // --- Header Section ---
  Widget _buildHeader(User? user) {
    final displayName = user?.displayName ?? "Nilesh Kumar";
    final avatarUrl = user?.photoURL ?? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(displayName)}&background=random';

    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            )
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Morning,\n$displayName",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2C59),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "CSE 1A • Semester 3",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Reusable Section Title ---
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: Colors.black54,
      ),
    );
  }

  // --- Today's Summary Grid Section ---
  Widget _buildSummaryGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                color: const Color(0xFFD3E3FD),
                icon: Icons.calendar_today_outlined,
                value: "82%",
                label: "Attendance",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                color: const Color(0xFFE2EDFF),
                icon: Icons.assignment_outlined,
                value: "4",
                label: "Homework",
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                color: const Color(0xFFFFE0B2),
                icon: Icons.campaign_outlined,
                value: "3",
                label: "Notices",
                iconColor: Colors.orange.shade800,
                valueColor: Colors.orange.shade800,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                color: const Color(0xFFE8F5E9),
                icon: Icons.access_time,
                value: "5",
                label: "Classes",
                iconColor: Colors.green.shade800,
                valueColor: Colors.green.shade800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required Color color,
    required IconData icon,
    required String value,
    required String label,
    Color iconColor = const Color(0xFF0F2C59),
    Color valueColor = const Color(0xFF0F2C59),
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // --- Quick Actions Wrap Grid ---
  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    final actions = [
      {"icon": Icons.assignment_outlined, "label": "Homework"},
      {"icon": Icons.note_alt_outlined, "label": "Notes"},
      {"icon": Icons.access_time, "label": "Schedule"},
      {"icon": Icons.campaign_outlined, "label": "Notices"},
      {"icon": Icons.psychology_outlined, "label": "AI Tutor"},
      {"icon": Icons.chrome_reader_mode_outlined, "label": "Reader"},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 3.2,
      children: actions.map((action) {
        final label = action["label"] as String;
        return GestureDetector(
          onTap: () {
            Widget? destination;
            if (label == "Homework") {
              destination = const HomeworkView();
            } else if (label == "Notes") {
              destination = const NotesView();
            } else if (label == "Schedule") {
              destination = const ScheduleView();
            } else if (label == "Reader") {
              destination = const ReaderView();
            } else if (label == "Notices") {
              // Switch tab to index 3 (Alerts)
              ref.read(navigationProvider.notifier).setIndex(3);
            } else if (label == "AI Tutor") {
              // Switch tab to index 2 (AI Tutor)
              ref.read(navigationProvider.notifier).setIndex(2);
            }

            if (destination != null) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => destination!),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(action["icon"] as IconData, size: 20, color: const Color(0xFF0F2C59)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- Today's Classes List ---
  Widget _buildTodayClasses() {
    final classes = [
      {"time": "9:00 AM", "name": "Data Structures", "color": const Color(0xFFD3E3FD)},
      {"time": "11:00 AM", "name": "DBMS", "color": const Color(0xFFE2EDFF)},
      {"time": "2:00 PM", "name": "Operating Systems", "color": const Color(0xFFFCE9A4)},
    ];

    return Column(
      children: classes.map((c) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: c["color"] as Color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.class_outlined, color: Color(0xFF0F2C59)),
            ),
            title: Text(
              c["name"] as String,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            subtitle: Text(
              c["time"] as String,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ),
        );
      }).toList(),
    );
  }

  // --- Recent Activity Section ---
  Widget _buildRecentActivityList() {
    return Column(
      children: [
        _buildActivityItem(
          color: const Color(0xFF0F2C59),
          title: "New Homework Added",
          time: "2h ago",
          isFirst: true,
        ),
        _buildActivityItem(
          color: Colors.blue,
          title: "Mid Semester Notice published",
          time: "4h ago",
        ),
        _buildActivityItem(
          color: const Color(0xFF9E8B2A),
          title: "DBMS Notes Uploaded",
          time: "Yesterday",
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required Color color,
    required String title,
    required String time,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: Colors.grey.shade300,
              )
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Upcoming Deadlines ---
  Widget _buildUpcomingDeadlines() {
    final deadlines = [
      {"name": "Assignment 3", "info": "Due Tomorrow", "color": Colors.red},
      {"name": "DBMS Lab", "info": "Due in 2 Days", "color": Colors.orange},
    ];

    return Column(
      children: deadlines.map((d) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: d["color"] as Color, width: 1.2),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: d["color"] as Color, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d["name"] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF0F2C59),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      d["info"] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: d["color"] as Color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
