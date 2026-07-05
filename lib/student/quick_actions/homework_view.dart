import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers.dart';

class HomeworkView extends ConsumerStatefulWidget {
  const HomeworkView({super.key});

  @override
  ConsumerState<HomeworkView> createState() => _HomeworkViewState();
}

class _HomeworkViewState extends ConsumerState<HomeworkView> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submitHomework(String id, String userEmail, String userName) {
    final text = _controllers[id]?.text.trim() ?? "";
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please type your answer or paste a link first!"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final newSubmission = HomeworkSubmissionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      homeworkId: id,
      studentEmail: userEmail,
      studentName: userName,
      submissionText: text,
      submittedAt: DateTime.now(),
    );

    ref.read(homeworkSubmissionsProvider.notifier).addSubmission(newSubmission);

    setState(() {
      _controllers[id]?.dispose();
      _controllers.remove(id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Assignment submitted successfully!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postsProvider);
    final classes = ref.watch(classesProvider);
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final userEmail = user?.email ?? "";
    final displayName = user?.displayName ?? "";
    final userName = displayName.split('|').first.trim();

    final submissions = ref.watch(homeworkSubmissionsProvider);

    // Dynamically resolve enrolled class IDs to filter homework assignments targeting those specific classes or "All".
    final enrolledClassIds = classes
        .where((c) => c.enrolledStudents.contains(userName))
        .map((c) => c.id)
        .toList();
    if (enrolledClassIds.isEmpty) {
      enrolledClassIds.add("CSE 1A");
    }

    final homeworks = posts.where((p) => p.type == "Homework" && (enrolledClassIds.contains(p.targetClass) || p.targetClass == "All")).toList();

    for (var hw in homeworks) {
      final isSubmitted = submissions.any((s) => s.homeworkId == hw.id && s.studentEmail == userEmail);
      if (!isSubmitted && !_controllers.containsKey(hw.id)) {
        _controllers[hw.id] = TextEditingController();
      }
    }

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
          "My Homework",
          style: TextStyle(
            color: Color(0xFF0F2C59),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: homeworks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    "No homework assignments",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F2C59),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "You are all caught up! No homework posted for your class yet.",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: homeworks.length,
              itemBuilder: (context, index) {
                final hw = homeworks[index];
                final String id = hw.id;
                final bool isSubmitted = submissions.any((s) => s.homeworkId == id && s.studentEmail == userEmail);

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
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: hw.color.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.assignment_outlined, color: Color(0xFF0F2C59)),
                    ),
                    title: Text(
                      hw.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF0F2C59),
                      ),
                    ),
                    subtitle: const Text(
                      "Status: Active",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (isSubmitted ? Colors.blue : Colors.orange).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isSubmitted ? "Submitted" : "Pending",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: isSubmitted ? Colors.blue : Colors.orange,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(height: 1),
                            const SizedBox(height: 12),
                            const Text(
                              "Task Description",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hw.description,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                            if (hw.attachment != null) ...[
                              const SizedBox(height: 12),
                              const Text(
                                "Attached File",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF2F9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        hw.attachment!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF0F2C59),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.download, size: 18, color: Color(0xFF0F2C59)),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Downloading ${hw.attachment}..."),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.access_time_outlined, size: 14, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  "Published: ${hw.date.day}/${hw.date.month}/${hw.date.year}",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            if (isSubmitted) ...[
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.blue.withValues(alpha: 0.15)),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.hourglass_empty, size: 16, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text(
                                      "Waiting for evaluation",
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              const SizedBox(height: 16),
                              const Text(
                                "Submit Answer / Paste Link",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _controllers[id],
                                      decoration: InputDecoration(
                                        hintText: "Type answer or GitHub/Drive link...",
                                        hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                        fillColor: const Color(0xFFEEF2F9),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => _submitHomework(id, userEmail, userName),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0F2C59),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Icon(Icons.send, size: 18),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
