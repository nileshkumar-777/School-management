import 'package:flutter/material.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  // Phase state: false = Configuration, true = Marking list
  bool _isMarkingPhase = false;

  // Configuration selections
  String _selectedClass = 'CSE 1A';
  String _selectedSubject = 'DBMS';
  DateTime _selectedDate = DateTime(2026, 6, 23);

  // Student list data state
  late List<Map<String, dynamic>> _students;

  // Pre-defined students requested by the user, followed by generated ones to make 62
  final List<String> _initialNames = [
    "Nilesh Kumar",
    "Rahul Sharma",
    "Aman Gupta",
    "Priya Singh",
    "Arjun Das",
    "Riya Patel",
  ];

  final List<String> _additionalFirstNames = [
    "Aarav", "Aditi", "Ananya", "Amit", "Dev", "Divya", "Ishaan", "Kavya", 
    "Kabir", "Meera", "Neha", "Pranav", "Rohan", "Sanjana", "Shreya", 
    "Siddharth", "Tanvi", "Vikram", "Yash", "Sneha", "Karan", "Pooja"
  ];

  final List<String> _additionalLastNames = [
    "Verma", "Mehta", "Sen", "Joshi", "Kapoor", "Reddy", "Nair", "Saxena",
    "Choudhury", "Bose", "Rao", "Malhotra", "Singhal", "Trivedi", "Roy",
    "Bahl", "Mishra", "Pandey", "Yadav", "Dubey", "Gupta", "Sharma"
  ];

  @override
  void initState() {
    super.initState();
    _initializeStudentList();
  }

  void _initializeStudentList() {
    _students = [];
    
    // Add the user's specific students
    for (int i = 0; i < _initialNames.length; i++) {
      _students.add({
        "name": _initialNames[i],
        "isPresent": false,
      });
    }

    // Generate remaining students up to 62
    int firstIndex = 0;
    int lastIndex = 0;
    while (_students.length < 62) {
      final firstName = _additionalFirstNames[firstIndex];
      final lastName = _additionalLastNames[lastIndex];
      final name = "$firstName $lastName";
      
      // Ensure name is unique
      if (!_students.any((s) => s["name"] == name)) {
        _students.add({
          "name": name,
          "isPresent": false,
        });
      }
      
      lastIndex++;
      if (lastIndex >= _additionalLastNames.length) {
        lastIndex = 0;
        firstIndex++;
        if (firstIndex >= _additionalFirstNames.length) {
          break; // Safeguard to prevent infinite loop
        }
      }
    }
  }

  // Count helper
  int get _presentCount => _students.where((s) => s["isPresent"] == true).length;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2026, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0F2C59),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F2C59),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
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
          onPressed: () {
            if (_isMarkingPhase) {
              // Return to config screen
              setState(() {
                _isMarkingPhase = false;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          _isMarkingPhase ? "Mark Attendance" : "Attendance Manager",
          style: const TextStyle(
            color: Color(0xFF0F2C59),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _isMarkingPhase ? _buildMarkingBody() : _buildConfigBody(),
    );
  }

  // --- Phase 1: Configuration Screen ---
  Widget _buildConfigBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Class",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedClass,
                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0F2C59)),
                isExpanded: true,
                items: ['CSE 1A', 'CSE 1B', 'CSE 2A', 'ECE 1A'].map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text(
                      c,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F2C59),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedClass = val;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "Select Subject",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSubject,
                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0F2C59)),
                isExpanded: true,
                items: ['DBMS', 'Data Structures', 'Operating Systems', 'Digital Electronics'].map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(
                      s,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F2C59),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedSubject = val;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "Date",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: Color(0xFF0F2C59), size: 20),
                  const SizedBox(width: 12),
                  Text(
                    _formatDate(_selectedDate),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F2C59),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.edit_outlined, color: Colors.grey, size: 18),
                ],
              ),
            ),
          ),

          const SizedBox(height: 48),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isMarkingPhase = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F2C59),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Start Attendance",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Phase 2: Attendance Marking Board ---
  Widget _buildMarkingBody() {
    return Column(
      children: [
        // Sub-header displaying selected config
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$_selectedClass • $_selectedSubject",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2C59),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(_selectedDate),
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  Text(
                    "Present: $_presentCount / ${_students.length}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F2C59),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const Divider(height: 1, thickness: 1),

        // Scrollable checklist of students
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: _students.length,
            itemBuilder: (context, index) {
              final student = _students[index];
              final String name = student["name"] as String;
              final bool isPresent = student["isPresent"] as bool;

              // Generates initials for the circular avatar
              final initials = name.split(' ').map((n) => n[0]).take(2).join();

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.015),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: CircleAvatar(
                    backgroundColor: isPresent 
                        ? const Color(0xFFE8F5E9) 
                        : const Color(0xFFEEF2F9),
                    child: Text(
                      initials,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isPresent ? Colors.green.shade800 : const Color(0xFF0F2C59),
                      ),
                    ),
                  ),
                  title: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                      color: isPresent ? Colors.green.shade900 : const Color(0xFF0F2C59),
                    ),
                  ),
                  trailing: Checkbox(
                    value: isPresent,
                    activeColor: const Color(0xFF0F2C59),
                    onChanged: (bool? value) {
                      setState(() {
                        _students[index]["isPresent"] = value ?? false;
                      });
                    },
                  ),
                  onTap: () {
                    // Toggle state on row tap for premium UX
                    setState(() {
                      _students[index]["isPresent"] = !isPresent;
                    });
                  },
                ),
              );
            },
          ),
        ),

        const Divider(height: 1, thickness: 1),

        // Action Buttons layout
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      for (var s in _students) {
                        s["isPresent"] = true;
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0F2C59), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Mark All Present",
                    style: TextStyle(
                      color: Color(0xFF0F2C59),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Attendance saved! $_presentCount students marked present."),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F2C59),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Save Attendance",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
