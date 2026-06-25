import 'package:flutter/material.dart';

class CreateView extends StatefulWidget {
  const CreateView({super.key});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'Homework';
  String _selectedClass = 'CSE 1A';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Create Post",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F2C59),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Publish announcements, assign homework, or draft study notes for your students.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Post Type Selection
          const Text(
            "POST TYPE",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: ['Homework', 'Notice', 'Notes'].map((type) {
              final isSelected = _selectedType == type;
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: ChoiceChip(
                  label: Text(
                    type,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF0F2C59),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        _selectedType = type;
                      });
                    }
                  },
                  selectedColor: const Color(0xFF0F2C59),
                  backgroundColor: const Color(0xFFEEF2F9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide.none,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Target Class Selection
          const Text(
            "TARGET CLASS",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedClass,
                items: ['CSE 1A', 'CSE 1B', 'CSE 2A', 'ECE 1A'].map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text(c, style: const TextStyle(fontWeight: FontWeight.bold)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedClass = val;
                    });
                  }
                },
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0F2C59)),
                isExpanded: true,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Title
          const Text(
            "TITLE",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: "e.g., Assignment 3: Trees & Graphs",
              filled: true,
              fillColor: const Color(0xFFEEF2F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Description
          const Text(
            "DESCRIPTION / DETAILS",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Provide post details, task instructions, or resource links here...",
              filled: true,
              fillColor: const Color(0xFFEEF2F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Publish button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Successfully published $_selectedType for $_selectedClass!"),
                    backgroundColor: Colors.green,
                  ),
                );
                _titleController.clear();
                _descriptionController.clear();
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
                "Publish Post",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
