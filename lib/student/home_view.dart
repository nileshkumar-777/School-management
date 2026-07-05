import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers.dart';
import 'package:project/student/quick_actions/homework_view.dart';
import 'package:project/student/quick_actions/schedule_view.dart';
import 'package:project/student/quick_actions/reader_view.dart';

class StudentHomeView extends ConsumerWidget {
  const StudentHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    final classes = ref.watch(classesProvider);
    final posts = ref.watch(postsProvider);
    final queries = ref.watch(queriesProvider);

    final rawName = user?.displayName ?? "Nilesh Kumar";
    final studentName = rawName.split('|').first.trim();

    // Dynamically find classes the student is enrolled in.
    // If none found, default to "CSE 1A" so that default data is visible if it exists.
    var studentClasses = classes.where((c) => c.enrolledStudents.contains(studentName)).toList();
    if (studentClasses.isEmpty && classes.any((c) => c.id == "CSE 1A")) {
      studentClasses = classes.where((c) => c.id == "CSE 1A").toList();
    }

    final enrolledClassIds = studentClasses.map((c) => c.id).toList();
    if (enrolledClassIds.isEmpty) {
      enrolledClassIds.add("CSE 1A");
    }

    final homeworks = posts.where((p) => p.type == "Homework" && (enrolledClassIds.contains(p.targetClass) || p.targetClass == "All")).toList();
    final noticesAndAlerts = posts.where((p) => (p.type == "Notice" || p.type == "Alert") && (enrolledClassIds.contains(p.targetClass) || p.targetClass == "All")).toList();
    final studentQueries = queries.where((q) => q.student == studentName).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(user),
          const SizedBox(height: 24),
          _buildSectionTitle("TODAY'S SUMMARY"),
          const SizedBox(height: 12),
          _buildSummaryGrid(
            context,
            ref,
            homeworkCount: homeworks.length,
            noticeCount: noticesAndAlerts.length,
            classCount: studentClasses.length,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle("QUICK ACTIONS"),
          const SizedBox(height: 12),
          _buildQuickActions(context, ref),
          const SizedBox(height: 24),
          _buildSectionTitle("TODAY'S CLASSES"),
          const SizedBox(height: 12),
          _buildTodayClasses(studentClasses),
          const SizedBox(height: 24),
          _buildSectionTitle("RECENT ACTIVITY"),
          const SizedBox(height: 12),
          _buildRecentActivityList(noticesAndAlerts, homeworks, studentQueries),
          const SizedBox(height: 24),
          _buildSectionTitle("UPCOMING DEADLINES"),
          const SizedBox(height: 12),
          _buildUpcomingDeadlines(homeworks),
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
  Widget _buildSummaryGrid(
    BuildContext context,
    WidgetRef ref, {
    required int homeworkCount,
    required int noticeCount,
    required int classCount,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                color: const Color(0xFFD3E3FD),
                icon: Icons.calendar_today_outlined,
                value: "100%", // Attendance default placeholder
                label: "Attendance",
                onTap: () {
                  ref.read(navigationProvider.notifier).setIndex(1); // Academics
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                color: const Color(0xFFE2EDFF),
                icon: Icons.assignment_outlined,
                value: "$homeworkCount",
                label: "Homework",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HomeworkView()),
                  );
                },
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
                value: "$noticeCount",
                label: "Notices & Alerts",
                iconColor: Colors.orange.shade800,
                valueColor: Colors.orange.shade800,
                onTap: () {
                  ref.read(navigationProvider.notifier).setIndex(3); // Alerts & Notices
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                color: const Color(0xFFE8F5E9),
                icon: Icons.access_time,
                value: "$classCount",
                label: "Classes",
                iconColor: Colors.green.shade800,
                valueColor: Colors.green.shade800,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ScheduleView()),
                  );
                },
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
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  // --- Quick Actions Wrap Grid ---
  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    final actions = [
      {"icon": Icons.assignment_outlined, "label": "Homework"},
      {"icon": Icons.notification_important_outlined, "label": "Alerts"},
      {"icon": Icons.access_time, "label": "Schedule"},
      {"icon": Icons.campaign_outlined, "label": "Notices"},
      {"icon": Icons.psychology_outlined, "label": "AI Tutor"},
      {"icon": Icons.chrome_reader_mode_outlined, "label": "Reader"},
      {"icon": Icons.question_answer_outlined, "label": "Ask Teacher"},
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
            } else if (label == "Alerts") {
              ref.read(navigationProvider.notifier).setIndex(3);
            } else if (label == "Schedule") {
              destination = const ScheduleView();
            } else if (label == "Reader") {
              destination = const ReaderView();
            } else if (label == "Notices") {
              ref.read(navigationProvider.notifier).setIndex(3);
            } else if (label == "AI Tutor") {
              ref.read(navigationProvider.notifier).setIndex(2);
            } else if (label == "Ask Teacher") {
              _showAskTeacherDialog(context, ref);
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
  Widget _buildTodayClasses(List<ClassModel> studentClasses) {
    if (studentClasses.isEmpty) {
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
            Icon(Icons.class_outlined, color: Colors.grey, size: 36),
            SizedBox(height: 12),
            Text(
              "No classes scheduled today",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF0F2C59),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: studentClasses.map((c) {
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
                color: c.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.class_outlined, color: c.textColor),
            ),
            title: Text(
              c.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            subtitle: Text(
              c.time,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ),
        );
      }).toList(),
    );
  }

  // --- Recent Activity Section ---
  Widget _buildRecentActivityList(
    List<PostModel> notices,
    List<PostModel> homeworks,
    List<QueryModel> studentQueries,
  ) {
    final List<Map<String, dynamic>> activities = [];

    for (final hw in homeworks) {
      activities.add({
        "color": Colors.blue,
        "title": "New Homework Added: ${hw.title}",
        "time": "Just now",
      });
    }

    for (final note in notices) {
      activities.add({
        "color": note.type == "Notice" ? Colors.red : Colors.orange,
        "title": "Notice published: ${note.title}",
        "time": "Just now",
      });
    }

    for (final q in studentQueries) {
      activities.add({
        "color": q.status == "Answered" ? Colors.green : Colors.orange,
        "title": q.status == "Answered" ? "Query answered: ${q.topic}" : "Query submitted: ${q.topic}",
        "time": "Just now",
      });
    }

    if (activities.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF2F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "No recent activity logged.",
            style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    final recent = activities.take(3).toList();

    return Column(
      children: recent.asMap().entries.map((entry) {
        final idx = entry.key;
        final act = entry.value;
        return _buildActivityItem(
          color: act["color"] as Color,
          title: act["title"] as String,
          time: act["time"] as String,
          isFirst: idx == 0,
          isLast: idx == recent.length - 1,
        );
      }).toList(),
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
  Widget _buildUpcomingDeadlines(List<PostModel> homeworks) {
    if (homeworks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: Text(
            "No upcoming homework deadlines.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      );
    }

    return Column(
      children: homeworks.map((d) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange, width: 1.2),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF0F2C59),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Due in 2 Days",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
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

  void _showAskTeacherDialog(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final topicController = TextEditingController();
    final subjectController = TextEditingController();
    final queryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Ask a Query",
            style: TextStyle(color: Color(0xFF0F2C59), fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: topicController,
                  decoration: const InputDecoration(
                    labelText: "Topic / Header",
                    hintText: "SQL Joins confusion",
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: "Subject Name",
                    hintText: "DBMS",
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: queryController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Your Query",
                    hintText: "Explain left joins vs full joins...",
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? "Required" : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F2C59),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  final String rawName = currentUser?.displayName ?? "Nilesh Kumar";
                  final String cleanName = rawName.split('|')[0]; // Extract name if displayName is Name|Role

                  final newQuery = QueryModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    student: cleanName,
                    classId: "CSE 1A",
                    subject: subjectController.text.trim(),
                    topic: topicController.text.trim(),
                    time: DateTime.now(),
                    queryText: queryController.text.trim(),
                    status: "Pending",
                    replies: const [],
                    color: const Color(0xFFD3E3FD),
                  );

                  ref.read(queriesProvider.notifier).addQuery(newQuery);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Query submitted successfully to teacher!"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}
