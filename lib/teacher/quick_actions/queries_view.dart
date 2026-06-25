import 'package:flutter/material.dart';

class QueriesView extends StatefulWidget {
  const QueriesView({super.key});

  @override
  State<QueriesView> createState() => _QueriesViewState();
}

class _QueriesViewState extends State<QueriesView> {
  late List<Map<String, dynamic>> _queries;
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _queries = [
      {
        "id": 1,
        "student": "Amit Patel",
        "classId": "CSE 1A",
        "subject": "Database Management Systems",
        "topic": "Left Outer vs Full Outer Join",
        "time": "10m ago",
        "queryText": "I am confused between LEFT OUTER JOIN and FULL OUTER JOIN. When should we prefer outer joins over inner joins? Can you give a practical scenario?",
        "status": "Pending",
        "reply": "",
        "color": const Color(0xFFD3E3FD),
      },
      {
        "id": 2,
        "student": "Priya Sharma",
        "classId": "CSE 1B",
        "subject": "Data Structures & Algorithms",
        "topic": "Binary Tree Reconstruction",
        "time": "2h ago",
        "queryText": "Is it possible to reconstruct a unique binary tree using only Inorder and Postorder traversals? Or do we absolutely need Preorder?",
        "status": "Answered",
        "reply": "Yes, it is absolutely possible. The last element of the Postorder traversal sequence gives the root node. You can find this root node's index in the Inorder sequence to divide the left and right subtrees. Then, recursively reconstruct the subtrees. You only need two traversals, provided one of them is Inorder.",
        "color": const Color(0xFFE2EDFF),
      },
      {
        "id": 3,
        "student": "Nilesh Kumar",
        "classId": "CSE 1A",
        "subject": "Database Management Systems",
        "topic": "Homework 3 Extension Request",
        "time": "4h ago",
        "queryText": "Good morning teacher, is there any extension possible for Assignment 3? I have a mild seasonal fever and couldn't complete the SQL queries on time.",
        "status": "Pending",
        "reply": "",
        "color": const Color(0xFFD3E3FD),
      },
      {
        "id": 4,
        "student": "Rohan Das",
        "classId": "CSE 2A",
        "subject": "Operating Systems",
        "topic": "Semaphores vs Mutexes",
        "time": "1d ago",
        "queryText": "What is the key difference between a binary semaphore and a mutex? Are they interchangeable in multi-threaded application design?",
        "status": "Pending",
        "reply": "",
        "color": const Color(0xFFFCE9A4),
      },
    ];

    for (var query in _queries) {
      if (query["status"] == "Pending") {
        _controllers[query["id"] as int] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitReply(int id) {
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

    setState(() {
      final index = _queries.indexWhere((q) => q["id"] == id);
      if (index != -1) {
        _queries[index]["status"] = "Answered";
        _queries[index]["reply"] = controller.text.trim();
        _controllers[id]?.dispose();
        _controllers.remove(id);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Reply sent successfully!"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          "Student Queries",
          style: TextStyle(
            color: Color(0xFF0F2C59),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_chat_read_outlined, color: Color(0xFF0F2C59)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: _queries.length,
        itemBuilder: (context, index) {
          final query = _queries[index];
          final int id = query["id"] as int;
          final bool isAnswered = query["status"] == "Answered";

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: (query["color"] as Color),
                        child: Text(
                          (query["student"] as String).split(' ').map((e) => e[0]).take(2).join(),
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
                              query["student"] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF0F2C59),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${query["classId"]} • ${query["subject"]}",
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
                              query["status"] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isAnswered ? Colors.green : Colors.orange,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            query["time"] as String,
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Topic: ${query["topic"]}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    query["queryText"] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isAnswered) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.check_circle_outline, size: 14, color: Colors.green),
                              SizedBox(width: 6),
                              Text(
                                "Your Answer",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            query["reply"] as String,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controllers[id],
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Type your reply...",
                              hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              fillColor: const Color(0xFFEEF2F9),
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
                                borderSide: const BorderSide(color: Color(0xFF0F2C59), width: 1),
                              ),
                            ),
                            style: const TextStyle(fontSize: 13),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
