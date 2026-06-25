import 'package:flutter/material.dart';

class HomeworkView extends StatefulWidget {
  const HomeworkView({super.key});

  @override
  State<HomeworkView> createState() => _HomeworkViewState();
}

class _HomeworkViewState extends State<HomeworkView> {
  late List<Map<String, dynamic>> _assignments;
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _assignments = [
      {
        "id": 1,
        "title": "Assignment 3: Relational Algebra & SQL",
        "subject": "Database Management Systems",
        "dueDate": "June 28, 2026 • 11:59 PM",
        "status": "Pending",
        "statusColor": Colors.orange,
        "description": "Solve all schema exercises in Chapter 3. Design functional dependencies and write SQL queries for queries 1 to 8.",
        "score": "",
        "comments": "",
        "color": const Color(0xFFD3E3FD),
      },
      {
        "id": 2,
        "title": "Lab Practical 2: Graph Implementations",
        "subject": "Data Structures & Algorithms",
        "dueDate": "June 30, 2026 • 2:00 PM",
        "status": "Submitted",
        "statusColor": Colors.blue,
        "description": "Write a C++ program implementing BFS and DFS traversals on directed and undirected adjacency lists.",
        "score": "",
        "comments": "Waiting for evaluation",
        "color": const Color(0xFFE2EDFF),
      },
      {
        "id": 3,
        "title": "Assignment 2: Process Scheduling Algorithms",
        "subject": "Operating Systems",
        "dueDate": "June 24, 2026 • 11:59 PM",
        "status": "Graded",
        "statusColor": Colors.green,
        "description": "Calculate average waiting and turnaround times for FIFO, SJF, and Round Robin scheduling algorithms.",
        "score": "9.5 / 10",
        "comments": "Excellent workflow analysis and clear Gantt charts!",
        "color": const Color(0xFFFCE9A4),
      },
      {
        "id": 4,
        "title": "Problem Set 1: Combinational Logic",
        "subject": "Digital Electronics",
        "dueDate": "June 18, 2026 • 5:00 PM",
        "status": "Closed",
        "statusColor": Colors.grey,
        "description": "Design a 4-bit carry lookahead adder using NAND gates only. Sketch the schematic diagram.",
        "score": "0 / 10",
        "comments": "Not submitted on time",
        "color": const Color(0xFFE8F5E9),
      },
    ];

    for (var a in _assignments) {
      if (a["status"] == "Pending") {
        _controllers[a["id"] as int] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submitHomework(int id) {
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

    setState(() {
      final idx = _assignments.indexWhere((a) => a["id"] == id);
      if (idx != -1) {
        _assignments[idx]["status"] = "Submitted";
        _assignments[idx]["statusColor"] = Colors.blue;
        _assignments[idx]["comments"] = "Waiting for evaluation";
        _controllers[id]?.dispose();
        _controllers.remove(id);
      }
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
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: _assignments.length,
        itemBuilder: (context, index) {
          final hw = _assignments[index];
          final int id = hw["id"] as int;
          final bool isPending = hw["status"] == "Pending";
          final bool isGraded = hw["status"] == "Graded";

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
                  color: (hw["color"] as Color).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.assignment_outlined, color: Color(0xFF0F2C59)),
              ),
              title: Text(
                hw["title"] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF0F2C59),
                ),
              ),
              subtitle: Text(
                hw["subject"] as String,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (hw["statusColor"] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  hw["status"] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: hw["statusColor"] as Color,
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
                        hw["description"] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.access_time_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "Due: ${hw["dueDate"]}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      if (isGraded) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.withValues(alpha: 0.15)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Score: ${hw["score"]}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              if ((hw["comments"] as String).isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  "Feedback: ${hw["comments"]}",
                                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ] else if (hw["status"] == "Submitted") ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.withValues(alpha: 0.15)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.hourglass_empty, size: 16, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                hw["comments"] as String,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (isPending) ...[
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
                              onPressed: () => _submitHomework(id),
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
