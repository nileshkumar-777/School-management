import 'package:flutter/material.dart';

class ReaderView extends StatefulWidget {
  const ReaderView({super.key});

  @override
  State<ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<ReaderView> {
  // Books list
  final List<Map<String, dynamic>> _books = [
    {
      "title": "Database System Concepts (7th Edition)",
      "author": "Silberschatz, Korth, Sudarshan",
      "pages": [
        "Chapter 3: Introduction to SQL\n\nSQL (Structured Query Language) is the most influential database query language in use today. In this chapter, we study the fundamental structure of SQL queries, data definitions, and basic operations.\n\nA database schema is defined using Data Definition Language (DDL) which allows specifying table names, attribute names, types, and constraints.",
        "Section 3.2: Basic Query Structure\n\nThe basic structure of an SQL query consists of three clauses: select, from, and where.\n\n* The SELECT clause corresponds to the projection operation of relational algebra.\n* The FROM clause lists the relations to be scanned.\n* The WHERE clause is a predicate filtering the tuple results.",
        "Section 3.3: Join Expressions\n\nJoins combine tuples from two or more relations based on a common matching attribute.\n\nTypes of joins:\n1. Inner Join: retains only matching tuples.\n2. Left Outer Join: retains all tuples of the left table even if no match is found on the right table.",
      ],
    },
    {
      "title": "Introduction to Algorithms (4th Edition)",
      "author": "Cormen, Leiserson, Rivest, Stein",
      "pages": [
        "Chapter 12: Binary Search Trees\n\nSearch trees are data structures that support many dynamic-set operations, including SEARCH, MINIMUM, MAXIMUM, PREDECESSOR, SUCCESSOR, INSERT, and DELETE.\n\nThus, a search tree can be used both as a dictionary and as a priority queue.",
        "Section 12.1: What is a Binary Search Tree?\n\nA binary search tree is organized as a binary tree. We represent such a tree by a linked data structure in which each node is an object.\n\nIn addition to a key and satellite data, each node contains attributes left, right, and parent, pointing to its children and parent.",
        "Section 12.2: Querying a Binary Search Tree\n\nWe often need to search for a key stored in a binary search tree. Besides the SEARCH operation, binary search trees can support queries such as MINIMUM and MAXIMUM.\n\nAn inorder tree traversal visits all nodes in sorted order in O(n) time.",
      ],
    },
  ];

  int _selectedBookIndex = 0;
  int _currentPage = 0;
  double _fontSize = 14.0;

  @override
  Widget build(BuildContext context) {
    final book = _books[_selectedBookIndex];
    final List<String> pages = book["pages"] as List<String>;
    final String pageText = pages[_currentPage];

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
          "Class Reader",
          style: TextStyle(
            color: Color(0xFF0F2C59),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Color(0xFF0F2C59)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Bookmark saved!"),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Book Selection Dropdown
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.library_books, color: Color(0xFF0F2C59), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedBookIndex,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0F2C59)),
                      items: List.generate(_books.length, (index) {
                        return DropdownMenuItem(
                          value: index,
                          child: Text(
                            _books[index]["title"] as String,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F2C59),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedBookIndex = val;
                            _currentPage = 0;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Top Controls (Font size selector)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.format_size, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                const Text("Font Size", style: TextStyle(fontSize: 12, color: Colors.grey)),
                Expanded(
                  child: Slider(
                    value: _fontSize,
                    min: 12.0,
                    max: 24.0,
                    activeColor: const Color(0xFF0F2C59),
                    inactiveColor: const Color(0xFFEEF2F9),
                    onChanged: (val) {
                      setState(() {
                        _fontSize = val;
                      });
                    },
                  ),
                ),
                Text(
                  "${_fontSize.toInt()}pt",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F2C59)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main Reading Area
          Expanded(
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.01),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book["author"] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      pageText,
                      style: TextStyle(
                        fontSize: _fontSize,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Navigation Page Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF0F2C59)),
                  onPressed: _currentPage > 0
                      ? () {
                          setState(() {
                            _currentPage--;
                          });
                        }
                      : null,
                ),
                Text(
                  "Page ${_currentPage + 1} of ${pages.length}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2C59),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 20, color: Color(0xFF0F2C59)),
                  onPressed: _currentPage < pages.length - 1
                      ? () {
                          setState(() {
                            _currentPage++;
                          });
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
