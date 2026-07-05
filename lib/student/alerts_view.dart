import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers.dart';

class AlertsView extends ConsumerStatefulWidget {
  const AlertsView({super.key});

  @override
  ConsumerState<AlertsView> createState() => _AlertsViewState();
}

class _AlertsViewState extends ConsumerState<AlertsView> {
  String selectedFilter = 'All';
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postsProvider);
    final classes = ref.watch(classesProvider);
    final queries = ref.watch(queriesProvider);
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    final rawName = user?.displayName ?? "Nilesh Kumar";
    final studentName = rawName.split('|').first.trim();

    // Dynamically resolve enrolled class IDs to filter notices/alerts targeting those specific classes or "All".
    final enrolledClassIds = classes
        .where((c) => c.enrolledStudents.contains(studentName))
        .map((c) => c.id)
        .toList();
    if (enrolledClassIds.isEmpty) {
      enrolledClassIds.add("CSE 1A");
    }

    // Filter notices/alerts targeting this student's class or All
    final announcements = posts.where((p) {
      final isAnnouncement = p.type == "Notice" || p.type == "Alert";
      final isTargeted = enrolledClassIds.contains(p.targetClass) || p.targetClass == "All";
      final isNotExpired = p.deleteAt == null || DateTime.now().isBefore(p.deleteAt!);
      return isAnnouncement && isTargeted && isNotExpired;
    }).toList();

    // Apply filter chip choice
    final filteredList = announcements.where((p) {
      if (selectedFilter == 'All') return true;
      if (selectedFilter == 'Notices') return p.type == "Notice";
      if (selectedFilter == 'Alerts') return p.type == "Alert";
      return true;
    }).toList();

    final classQueries = queries.where((q) => enrolledClassIds.contains(q.classId)).toList();

    for (var query in classQueries) {
      if (!_controllers.containsKey(query.id)) {
        _controllers[query.id] = TextEditingController();
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Alerts & Notices",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ThemeColors.primary(context),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Check warnings and circular updates from your school teachers.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Notices', 'Alerts', 'Queries'].map((filter) {
                final isSelected = selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : ThemeColors.primary(context),
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
                    backgroundColor: ThemeColors.accentBg(context),
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

          Expanded(
            child: selectedFilter == 'Queries'
                ? _buildQueriesList(classQueries, studentName)
                : (filteredList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.campaign_outlined, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              "No $selectedFilter found",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ThemeColors.primary(context),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Check back later for circulars or updates from the department.",
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final note = filteredList[index];
                          final bool isAlert = note.type == "Alert";

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
                                      color: note.color.withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isAlert ? Icons.warning_amber_rounded : Icons.campaign_outlined,
                                      color: isAlert ? Colors.orange.shade900 : Colors.red.shade900,
                                      size: 24,
                                    ),
                                  ),
                                  title: Text(
                                    note.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: ThemeColors.primary(context),
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${note.date.day}/${note.date.month}/${note.date.year}",
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          note.description,
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            color: ThemeColors.textSecondary(context),
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
                      )),
          ),
        ],
      ),
    );
  }

  void _submitReply(String queryId, String studentName) {
    final controller = _controllers[queryId];
    if (controller == null || controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please type a reply first!"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final reply = QueryReply(
      sender: studentName,
      senderRole: "Student",
      message: controller.text.trim(),
      time: DateTime.now(),
    );

    ref.read(queriesProvider.notifier).addReply(queryId, reply);
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

  Widget _buildQueriesList(List<QueryModel> queriesList, String studentName) {
    if (queriesList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.question_answer_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              "No Queries Found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColors.primary(context),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Check back later for student queries and discussions.",
              style: TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: queriesList.length,
      itemBuilder: (context, index) {
        final query = queriesList[index];
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
                    color: (isAnswered ? Colors.green : Colors.orange).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isAnswered ? Icons.question_answer_outlined : Icons.help_outline,
                    color: isAnswered ? Colors.green.shade900 : Colors.orange.shade900,
                    size: 24,
                  ),
                ),
                title: Text(
                  query.topic,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: ThemeColors.primary(context),
                  ),
                ),
                subtitle: Text(
                  "Asked by ${query.student} • ${query.subject}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isAnswered ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    query.status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: isAnswered ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Query Details:",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            query.queryText,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: ThemeColors.textSecondary(context),
                              height: 1.4,
                            ),
                          ),
                          if (query.replies.isNotEmpty) ...[
                            const SizedBox(height: 16),
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
                                onPressed: () => _submitReply(id, studentName),
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
