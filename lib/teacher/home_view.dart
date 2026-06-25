import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/role_choice.dart';
import 'package:project/providers.dart';
import 'package:project/teacher/quick_actions/homework_view.dart';
import 'package:project/teacher/quick_actions/notice_view.dart';
import 'package:project/teacher/quick_actions/notes_view.dart';
import 'package:project/teacher/quick_actions/schedule_view.dart';
import 'package:project/teacher/quick_actions/queries_view.dart';
import 'package:project/teacher/quick_actions/attendance_view.dart';


class TeacherHomeView extends ConsumerWidget {
  const TeacherHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, user),
          const SizedBox(height: 24),
          _buildSectionTitle("TODAY'S SUMMARY"),
          const SizedBox(height: 12),
          _buildSummaryGrid(),
          const SizedBox(height: 24),
          _buildSectionTitle("QUICK ACTIONS"),
          const SizedBox(height: 12),
          _buildQuickActions(context),
          const SizedBox(height: 24),
          _buildMyClassesHeader(),
          const SizedBox(height: 12),
          _buildMyClassesList(),
          const SizedBox(height: 24),
          _buildSectionTitle("RECENT ACTIVITY"),
          const SizedBox(height: 12),
          _buildRecentActivityList(),
          const SizedBox(height: 40), // Bottom padding for scroll clearance
        ],
      ),
    );
  }

  // --- Header Section ---
  Widget _buildHeader(BuildContext context, User? user) {
    final displayName = user?.displayName ?? "Dr. Sharma";
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
              Text(
                user?.email ?? "Computer Science Department",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF0F2C59)),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Color(0xFF0F2C59)),
          tooltip: "Logout",
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();

            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const RoleChoiceScreen()),
                (route) => false,
              );
            }
          },
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

  // --- Summary Grid Section ---
  Widget _buildSummaryGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                color: const Color(0xFFD3E3FD),
                icon: Icons.people_alt_outlined,
                value: "0",
                label: "Students",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                color: const Color(0xFFE2EDFF),
                icon: Icons.school_outlined,
                value: "0",
                label: "Classes",
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                color: const Color(0xFFFCE9A4),
                icon: Icons.chat_bubble_outline,
                value: "0",
                label: "Queries",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                color: const Color(0xFFFFD9D9),
                icon: Icons.notifications_active_outlined,
                value: "0",
                label: "Notices",
                iconColor: Colors.red,
                valueColor: Colors.red,
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

  // --- Quick Actions Section ---
  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {"icon": Icons.assignment_outlined, "label": "Homework"},
      {"icon": Icons.campaign_outlined, "label": "Notice"},
      {"icon": Icons.calendar_month_outlined, "label": "Attendance"},
      {"icon": Icons.note_alt_outlined, "label": "Notes"},
      {"icon": Icons.access_time, "label": "Schedule"},
      {"icon": Icons.question_answer_outlined, "label": "Queries"},
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
            } else if (label == "Notice") {
              destination = const NoticeView();
            } else if (label == "Attendance") {
              destination = const AttendanceView();
            } else if (label == "Notes") {
              destination = const NotesView();
            } else if (label == "Schedule") {
              destination = const ScheduleView();
            } else if (label == "Queries") {
              destination = const QueriesView();
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

  // --- My Classes Section ---
  Widget _buildMyClassesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle("MY CLASSES"),
        const Text(
          "View All",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildMyClassesList() {
    final classes = [];

    if (classes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Column(
          children: [
            Icon(Icons.school_outlined, color: Colors.grey, size: 36),
            SizedBox(height: 12),
            Text(
              "No classes created yet",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF0F2C59),
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Tap the 'Create' tab in the bottom navigation bar to set up your first class.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

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
              child: const Icon(Icons.book_outlined, color: Color(0xFF0F2C59)),
            ),
            title: Text(
              c["id"] as String,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            subtitle: Text(
              c["name"] as String,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        );
      }).toList(),
    );
  }

  // --- Recent Activity Section ---
  Widget _buildRecentActivityList() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 16, color: Colors.grey),
          SizedBox(width: 8),
          Text(
            "No recent activity logged.",
            style: TextStyle(fontSize: 12.5, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required Color color,
    required String title,
    required String target,
    required String time,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline graphic
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
                height: 60, // Adjust height based on content
                color: Colors.grey.shade300,
              )
          ],
        ),
        const SizedBox(width: 16),
        // Content Card
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black87, fontSize: 13),
                    children: [
                      TextSpan(
                        text: "$title to ",
                        style: TextStyle(color: color, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: target,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
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
}
