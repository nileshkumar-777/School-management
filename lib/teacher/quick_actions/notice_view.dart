import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers.dart';
import 'package:project/teacher/create_view.dart';

class NoticeView extends ConsumerStatefulWidget {
  const NoticeView({super.key});

  @override
  ConsumerState<NoticeView> createState() => _NoticeViewState();
}

class _NoticeViewState extends ConsumerState<NoticeView> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postsProvider);
    
    // Filter announcements (notices and alerts) created by the teacher
    final announcements = posts.where((p) => p.type == "Notice" || p.type == "Alert").toList();

    // Filter based on selected chip
    final filteredAnnouncements = announcements.where((p) {
      if (selectedFilter == 'All') return true;
      if (selectedFilter == 'Notices') return p.type == "Notice";
      if (selectedFilter == 'Alerts') return p.type == "Alert";
      return true;
    }).toList();

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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Filter chips
            Row(
              children: ['All', 'Notices', 'Alerts'].map((filter) {
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
            const SizedBox(height: 16),

            Expanded(
              child: filteredAnnouncements.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.campaign_outlined, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            "No $selectedFilter yet",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F2C59),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Create a post to send official updates or circulars.",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      itemCount: filteredAnnouncements.length,
                      itemBuilder: (context, index) {
                        final notice = filteredAnnouncements[index];
                        final bool isAlert = notice.type == "Alert";

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
                                        color: notice.color.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        notice.type,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: isAlert ? Colors.orange.shade900 : Colors.red.shade900,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${notice.date.day}/${notice.date.month}/${notice.date.year}",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  notice.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F2C59),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  notice.description,
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
                                      "Target: ${notice.targetClass}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F2C59),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text("Create Post"),
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0F2C59),
                  elevation: 0,
                ),
                body: const CreateView(),
              ),
            ),
          );
        },
        child: const Icon(Icons.campaign, color: Colors.white),
      ),
    );
  }
}
