import 'package:flutter/material.dart';
import 'dart:ui';

class PdfPageModel {
  final int pageNumber;
  final String title;
  final String content;

  PdfPageModel({
    required this.pageNumber,
    required this.title,
    required this.content,
  });
}

class PdfDocModel {
  final String name;
  final String subject;
  final List<PdfPageModel> pages;

  PdfDocModel({
    required this.name,
    required this.subject,
    required this.pages,
  });
}

final List<PdfDocModel> _preloadedPdfs = [
  PdfDocModel(
    name: "DBMS_Lecture_Notes.pdf",
    subject: "Database Management Systems",
    pages: [
      PdfPageModel(
        pageNumber: 1,
        title: "Introduction to Relational Databases",
        content: "A relational database organizes data into tables (or relations) of columns and rows, with a unique key identifying each row. Relational schema outlines the tables, field types, and integrity constraints.",
      ),
      PdfPageModel(
        pageNumber: 2,
        title: "Primary Keys & Foreign Keys",
        content: "A primary key is a specific column or combination of columns that uniquely identifies a row in a table. A foreign key is a column or group of columns in one table that references the primary key in another table, enforcing referential integrity.",
      ),
      PdfPageModel(
        pageNumber: 3,
        title: "B-Tree and B+ Tree Indexing",
        content: "Indexing speeds up query execution. B-Trees keep keys sorted for binary search, but leaf nodes aren't linked. B+ Trees store data pointers only in leaf nodes, which are linked sequentially to allow quick sequential range scans.",
      ),
      PdfPageModel(
        pageNumber: 4,
        title: "ACID Transaction Properties",
        content: "Transactions must guarantee: Atomicity (all or nothing), Consistency (preserves database rules), Isolation (independent execution), and Durability (survives crashes).",
      ),
    ],
  ),
  PdfDocModel(
    name: "Data_Structures_Guide.pdf",
    subject: "DSA",
    pages: [
      PdfPageModel(
        pageNumber: 1,
        title: "Introduction to Complexity Analysis",
        content: "Big O notation describes the upper bound of execution time or memory space needed by an algorithm. Common complexities: O(1) constant, O(log n) logarithmic, O(n) linear, O(n log n) linearithmic, O(n^2) quadratic.",
      ),
      PdfPageModel(
        pageNumber: 2,
        title: "Singly vs Doubly Linked Lists",
        content: "A singly linked list contains nodes with a value and a single pointer pointing to the next node. A doubly linked list contains nodes with two pointers, pointing to both the next and the previous nodes, allowing bidirectional traversal.",
      ),
      PdfPageModel(
        pageNumber: 3,
        title: "Binary Search Trees (BST)",
        content: "A binary tree node contains at most two children. In a Binary Search Tree (BST), the left child holds keys less than the parent, and the right child holds keys greater than the parent, facilitating O(log n) average search time.",
      ),
      PdfPageModel(
        pageNumber: 4,
        title: "Graph Traversal: BFS vs DFS",
        content: "Breadth-First Search (BFS) uses a queue to explore nodes level-by-level (nearest first). Depth-First Search (DFS) uses a stack (or recursion) to explore as deep as possible along each branch before backtracking.",
      ),
    ],
  ),
  PdfDocModel(
    name: "OS_Concepts.pdf",
    subject: "Operating Systems",
    pages: [
      PdfPageModel(
        pageNumber: 1,
        title: "Processes and Threads",
        content: "A process is a program in execution with its own dedicated memory space. A thread is the smallest unit of execution inside a process. Threads of the same process share code, data, and resources, making thread switching lightweight.",
      ),
      PdfPageModel(
        pageNumber: 2,
        title: "CPU Scheduling Algorithms",
        content: "The CPU scheduler chooses processes from the ready queue for execution. Algorithms include: First-Come First-Served (FCFS), Shortest Job First (SJF), Round Robin (RR - uses time slices), and Priority Scheduling.",
      ),
      PdfPageModel(
        pageNumber: 3,
        title: "Deadlocks and Bankers Algorithm",
        content: "A deadlock occurs when processes are blocked waiting for resources held by each other. Conditions: Mutual Exclusion, Hold & Wait, No Preemption, Circular Wait. Banker's algorithm manages state safety to avoid deadlocks.",
      ),
      PdfPageModel(
        pageNumber: 4,
        title: "Virtual Memory and Paging",
        content: "Virtual memory maps virtual addresses used by programs to physical addresses in RAM. Memory is divided into fixed-size blocks called pages (virtual) and frames (physical). A page table handles translations.",
      ),
    ],
  ),
];

String getMockAiResponse(String query, {String docName = "", int pageNumber = 0, String pageTitle = "", String pageContent = ""}) {
  final cleanQuery = query.trim();
  final q = cleanQuery.toLowerCase();

  // 1. Dynamic Counting Detection (e.g. "count till 10", "count to 10")
  final countRegex = RegExp(r'\b(count|enumerate)\s+(?:to|till|up\s+to)?\s*(\d+)', caseSensitive: false);
  final countMatch = countRegex.firstMatch(q);
  if (countMatch != null) {
    final numberStr = countMatch.group(2);
    if (numberStr != null) {
      final n = int.tryParse(numberStr);
      if (n != null && n > 0) {
        if (n > 100) {
          return "That is a large number to count! Here are the first 20 numbers:\n"
              "${List.generate(20, (i) => i + 1).join(', ')} ... and so on up to $n!";
        } else {
          return "Sure! Here is the count from 1 to $n:\n"
              "${List.generate(n, (i) => i + 1).join(', ')}.";
        }
      }
    }
  }

  // 2. Simple Math Solver (e.g. "what is 5 + 7")
  final mathRegex = RegExp(r'(\d+)\s*([\+\-\*\/])\s*(\d+)');
  final mathMatch = mathRegex.firstMatch(q);
  if (mathMatch != null) {
    final num1 = double.tryParse(mathMatch.group(1) ?? "");
    final op = mathMatch.group(2);
    final num2 = double.tryParse(mathMatch.group(3) ?? "");
    if (num1 != null && num2 != null && op != null) {
      double result = 0;
      switch (op) {
        case "+":
          result = num1 + num2;
          break;
        case "-":
          result = num1 - num2;
          break;
        case "*":
          result = num1 * num2;
          break;
        case "/":
          if (num2 != 0) {
            result = num1 / num2;
          } else {
            return "Division by zero is undefined!";
          }
          break;
      }
      final resultStr = (result % 1 == 0) ? result.toInt().toString() : result.toStringAsFixed(2);
      return "The result of ${num1.toInt()} $op ${num2.toInt()} is $resultStr.";
    }
  }

  // 3. Document-Specific Logic (PDF Study mode)
  if (docName.isNotEmpty) {
    if (docName == "DBMS_Lecture_Notes.pdf" && pageNumber == 3) {
      return "Great question regarding indexing on Page 3! B+ Trees store data pointers only at the leaf level, and keep all leaves linked sequentially. This means range searches (e.g. finding values between 10 and 50) only need to find the start node and then scan the list, avoiding vertical tree traversals.";
    } else if (docName == "Data_Structures_Guide.pdf" && pageNumber == 3) {
      return "About BSTs on Page 3: If you insert elements in sorted order (e.g., 1, 2, 3, 4), the BST behaves like a linked list, bringing search time complexity down to O(n). To maintain O(log n) efficiency, self-balancing trees like AVL or Red-Black Trees are used.";
    } else if (docName == "OS_Concepts.pdf" && pageNumber == 3) {
      return "Banker's Algorithm on Page 3 checks resource requests dynamically. It uses vectors for Available, Max, Allocation, and Need resources. It only grants a resource request if a safe path exists where all processes can run to completion.";
    } else {
      return "Regarding Page $pageNumber ('$pageTitle'):\n\nBased on the content: '$pageContent',\n\nHere is an explanation: This topic forms a core foundation in your computer science curriculum. Feel free to ask for specific code exercises or diagrams related to it!";
    }
  }

  // 4. Conversational Keywords (General Doubts)
  if (q.contains("hello") || q.contains("hi") || q == "hey") {
    return "Hello! I am your AI study companion. Ask me any doubts about concepts like B-Trees, CPU scheduling, virtual memory, or algorithms! You can also ask me to count to a number (e.g., 'count till 10') or solve simple math.";
  } else if (q.contains("what is ai") || q == "ai" || q.contains("artificial intelligence")) {
    return "Artificial Intelligence (AI) refers to the simulation of human intelligence in machines that are programmed to think and learn. In education, AI can help summarize study guides and explain complex concepts.";
  } else if (q.contains("b-tree") || q.contains("b+ tree")) {
    return "A B-Tree is a self-balancing search tree data structure that allows logarithmic searches. B+ Trees are a variation where keys are only stored in the leaves, which are sequentially linked—making range queries very efficient for databases.";
  } else if (q.contains("deadlock")) {
    return "A deadlock is a situation where a set of processes are blocked because each process holds a resource and waits for another resource held by some other process. The four conditions are: Mutual Exclusion, Hold & Wait, No Preemption, and Circular Wait.";
  } else if (q.contains("joke")) {
    return "Why do programmers wear glasses? Because they can't C#! 😂";
  } else if (q.contains("help") || q.contains("what can you do")) {
    return "I am your AI study companion! I can:\n"
        "• Count up to any number (try 'count till 10')\n"
        "• Perform basic math (try 'what is 25 * 4')\n"
        "• Explain topics like B-Trees, CPU scheduling, virtual memory, or deadlocks\n"
        "• Answer custom questions and study preloaded academic PDFs page-by-page!";
  } else if (q.contains("code") || q.contains("program")) {
    return "Here is a simple Hello World program in Dart:\n\n```dart\nvoid main() {\n  print('Hello, World!');\n}\n```\nLet me know if you need code for a specific data structure or algorithm!";
  }

  return "Interesting query! I am parsing the database and syllabus documents to formulate a detailed response. Let me know if you want specific examples, code, or a structured count.";
}

class AiView extends StatefulWidget {
  const AiView({super.key});

  @override
  State<AiView> createState() => _AiViewState();
}

class _AiViewState extends State<AiView> {
  final List<Map<String, dynamic>> _messages = [];

  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isPdfMode = false;

  void _sendMessage() {
    final userQuery = _textController.text.trim();
    if (userQuery.isEmpty) return;

    setState(() {
      _messages.add({
        "text": userQuery,
        "isMe": true,
        "time": "Now",
      });
      _textController.clear();
    });

    // Mock response generation using global helper
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        final replyText = getMockAiResponse(userQuery);

        setState(() {
          _messages.add({
            "text": replyText,
            "isMe": false,
            "time": "Now",
          });
        });
        _scrollToBottom();
      }
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildModeButton({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0F2C59) : const Color(0xFFEEF2F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.white : const Color(0xFF0F2C59),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : const Color(0xFF0F2C59),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfBrowserSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select a study document to open in PDF Reader:",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F2C59)),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _preloadedPdfs.length,
              itemBuilder: (context, idx) {
                final pdf = _preloadedPdfs[idx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                    title: Text(
                      pdf.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF0F2C59)),
                    ),
                    subtitle: Text(
                      pdf.subject,
                      style: const TextStyle(fontSize: 11.5, color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF0F2C59)),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PdfStudyScreen(pdf: pdf),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF0F2C59),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.psychology, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "AI Tutor",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F2C59),
                      ),
                    ),
                    Text(
                      "Ask me queries or study page-by-page from loaded PDFs.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          Row(
            children: [
              _buildModeButton(
                label: "Normal Doubts",
                icon: Icons.chat_bubble_outline,
                isActive: !_isPdfMode,
                onTap: () {
                  setState(() {
                    _isPdfMode = false;
                  });
                },
              ),
              const SizedBox(width: 12),
              _buildModeButton(
                label: "PDF Study Mode",
                icon: Icons.picture_as_pdf_outlined,
                isActive: _isPdfMode,
                onTap: () {
                  setState(() {
                    _isPdfMode = true;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_isPdfMode)
            Expanded(
              child: _buildPdfBrowserSelector(),
            )
          else ...[
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isMe = msg["isMe"] as bool;

                  final text = msg["text"] as String;
                  final bool hasContext = text.startsWith("[📄");
                  final String displayDocTag;
                  final String displayContent;

                  if (hasContext) {
                    final closeBracketIdx = text.indexOf("]");
                    if (closeBracketIdx != -1) {
                      displayDocTag = text.substring(2, closeBracketIdx);
                      displayContent = text.substring(closeBracketIdx + 1).trim();
                    } else {
                      displayDocTag = "";
                      displayContent = text;
                    }
                  } else {
                    displayDocTag = "";
                    displayContent = text;
                  }

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isMe ? const Color(0xFF0F2C59) : const Color(0xFFEEF2F9),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                          bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                        ),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (displayDocTag.isNotEmpty) ...[
                            Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? Colors.white.withValues(alpha: 0.15)
                                    : Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.picture_as_pdf, color: Colors.red, size: 12),
                                  const SizedBox(width: 4),
                                  Text(
                                    displayDocTag,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isMe ? Colors.white70 : Colors.blue.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          Text(
                            displayContent,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black87,
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              msg["time"] as String,
                              style: TextStyle(
                                fontSize: 10,
                                color: isMe ? Colors.white54 : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: "Type your query here...",
                      filled: true,
                      fillColor: const Color(0xFFEEF2F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F2C59),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class PdfStudyScreen extends StatefulWidget {
  final PdfDocModel pdf;

  const PdfStudyScreen({super.key, required this.pdf});

  @override
  State<PdfStudyScreen> createState() => _PdfStudyScreenState();
}

class _PdfStudyScreenState extends State<PdfStudyScreen> {
  int _currentPageIndex = 0;
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<GlobalKey> _pageKeys = [];

  bool _isAiResponseOpen = false;
  bool _isAiThinking = false;
  String _aiResponseText = "";
  String _aiResponseSourceContext = "";

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.pdf.pages.length; i++) {
      _pageKeys.add(GlobalKey());
    }
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  int _findActivePageIndex() {
    double minDiff = double.infinity;
    int activeIdx = 0;
    for (int i = 0; i < widget.pdf.pages.length; i++) {
      if (i >= _pageKeys.length) continue;
      final key = _pageKeys[i];
      final context = key.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          final double y = position.dy;
          // The page closest to the top of the viewport (app bar height is around 140px dy)
          final diff = (y - 140.0).abs();
          if (diff < minDiff) {
            minDiff = diff;
            activeIdx = i;
          }
        }
      }
    }
    return activeIdx;
  }

  void _scrollListener() {
    if (!mounted) return;
    final activeIdx = _findActivePageIndex();
    if (activeIdx != _currentPageIndex) {
      setState(() {
        _currentPageIndex = activeIdx;
      });
    }
  }

  void _sendMessage() {
    final userQuery = _textController.text.trim();
    if (userQuery.isEmpty) return;

    final page = widget.pdf.pages[_currentPageIndex];
    final docName = widget.pdf.name;
    final pageNumber = page.pageNumber;
    final pageTitle = page.title;
    final pageContent = page.content;

    setState(() {
      _isAiResponseOpen = true;
      _isAiThinking = true;
      _aiResponseText = "";
      _aiResponseSourceContext = "$docName • Page $pageNumber";
      _textController.clear();
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        final replyText = getMockAiResponse(
          userQuery,
          docName: docName,
          pageNumber: pageNumber,
          pageTitle: pageTitle,
          pageContent: pageContent,
        );

        setState(() {
          _isAiThinking = false;
          _aiResponseText = replyText;
        });
      }
    });
  }

  Widget _buildGlassmorphicInputBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: TextField(
                        controller: _textController,
                        onSubmitted: (_) => _sendMessage(),
                        style: const TextStyle(
                          color: Color(0xFF0F2C59),
                          fontWeight: FontWeight.w500,
                          fontSize: 14.5,
                        ),
                        decoration: InputDecoration(
                          hintText: "Ask a doubt about Page ${widget.pdf.pages[_currentPageIndex].pageNumber}...",
                          hintStyle: TextStyle(
                            color: const Color(0xFF0F2C59).withValues(alpha: 0.6),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F2C59),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicPopup() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 320,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD).withValues(alpha: 0.85),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF90CAF9).withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.psychology, color: Color(0xFF0F2C59), size: 22),
                        SizedBox(width: 8),
                        Text(
                          "AI Explanation",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _isAiResponseOpen = false;
                        });
                      },
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _aiResponseSourceContext,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: _isAiThinking
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 32),
                              const CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF0F2C59)),
                              const SizedBox(height: 16),
                              Text(
                                "Analyzing page content...",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            _aiResponseText,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.45,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E8F0),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: const Color(0xFF0F2C59),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.pdf.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Page ${_currentPageIndex + 1} of ${widget.pdf.pages.length}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: widget.pdf.pages.length,
                    padding: const EdgeInsets.only(bottom: 160),
                    itemBuilder: (context, index) {
                      final page = widget.pdf.pages[index];
                      return Container(
                        key: _pageKeys[index],
                        margin: EdgeInsets.only(bottom: index == widget.pdf.pages.length - 1 ? 0 : 12),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.pdf.subject.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 1.5,
                                    color: Colors.blue.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F2C59).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "Page ${page.pageNumber}",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F2C59),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              page.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F2C59),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 20),
                            Text(
                              page.content,
                              style: const TextStyle(
                                fontSize: 14.5,
                                color: Colors.black87,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 40),
                            const Divider(),
                            const SizedBox(height: 12),
                            Text(
                              "Additional Notes & Exercises:\n"
                              "• Highlight any terms you are unfamiliar with.\n"
                              "• Make sure to review the core formulas or constraints referenced in this section.\n"
                              "• Ask the AI Companion below to explain or provide sample problems.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                height: 1.5,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            _buildGlassmorphicInputBar(),
            if (_isAiResponseOpen) _buildGlassmorphicPopup(),
          ],
        ),
      ),
    );
  }
}
