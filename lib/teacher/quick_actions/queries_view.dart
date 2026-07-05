import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers.dart';

class QueriesView extends ConsumerStatefulWidget {
  const QueriesView({super.key});

  @override
  ConsumerState<QueriesView> createState() => _QueriesViewState();
}

class _QueriesViewState extends ConsumerState<QueriesView> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitReply(String id) {
    final controller = _controllers[id];
    if (controller == null || controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please type a reply first!"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final authState = ref.read(authStateProvider);
    final user = authState.value;
    final String rawName = user?.displayName ?? "Dr. Sharma";
    final String cleanName = rawName.split('|')[0];

    final reply = QueryReply(
      sender: cleanName,
      senderRole: "Teacher",
      message: controller.text.trim(),
      time: DateTime.now(),
    );

    ref.read(queriesProvider.notifier).addReply(id, reply);
    setState(() {
      controller.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Reply posted successfully!"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final queries = ref.watch(queriesProvider);

    // Initialize controllers for queries dynamically
    for (var query in queries) {
      if (!_controllers.containsKey(query.id)) {
        _controllers[query.id] = TextEditingController();
      }
    }

    return Scaffold(
      backgroundColor: ThemeColors.scaffoldBg(context),
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeColors.primary(context)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Student Queries",
          style: TextStyle(
            color: ThemeColors.primary(context),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: queries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline_rounded, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    "No queries yet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.primary(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Queries submitted by your students will show up here.",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: queries.length,
              itemBuilder: (context, index) {
                final query = queries[index];
                final String id = query.id;
                final bool isAnswered = query.status == "Answered";

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: ThemeColors.cardBg(context),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: query.color,
                              child: Text(
                                query.student.split(' ').map((e) => e[0]).take(2).join(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F2C59),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    query.student,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: ThemeColors.primary(context),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "${query.classId} • ${query.subject}",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isAnswered
                                        ? Colors.green.withValues(alpha: 0.1)
                                        : Colors.orange.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    query.status,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isAnswered ? Colors.green : Colors.orange,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "${query.time.hour.toString().padLeft(2, '0')}:${query.time.minute.toString().padLeft(2, '0')}",
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Topic: ${query.topic}",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.textSecondary(context),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          query.queryText,
                          style: TextStyle(
                            fontSize: 13,
                            color: ThemeColors.textSecondary(context),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (query.replies.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 12),
                          Text(
                            "Discussion Thread:",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.primary(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: query.replies.length,
                            itemBuilder: (context, rIdx) {
                              final reply = query.replies[rIdx];
                              final bool isTeacher = reply.senderRole == "Teacher";
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isTeacher
                                      ? Colors.green.withValues(alpha: 0.05)
                                      : Colors.blue.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isTeacher
                                        ? Colors.green.withValues(alpha: 0.1)
                                        : Colors.blue.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          reply.sender,
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.bold,
                                            color: isTeacher ? Colors.green.shade800 : Colors.blue.shade800,
                                          ),
                                        ),
                                        Text(
                                          "${reply.time.hour.toString().padLeft(2, '0')}:${reply.time.minute.toString().padLeft(2, '0')}",
                                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      reply.message,
                                      style: TextStyle(fontSize: 12.5, color: ThemeColors.textSecondary(context)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controllers[id],
                                decoration: InputDecoration(
                                  hintText: "Add to discussion...",
                                  hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  fillColor: ThemeColors.accentBg(context),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: ThemeColors.primary(context), width: 1),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: ThemeColors.textSecondary(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _submitReply(id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F2C59),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Icon(Icons.send, size: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
