import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers.dart';

class CreateView extends ConsumerStatefulWidget {
  const CreateView({super.key});

  @override
  ConsumerState<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends ConsumerState<CreateView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'Homework';
  String _selectedClass = '';
  String? _attachedFileName;
  DateTime? _selectedDeleteDateTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDeleteDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ThemeColors.primary(context),
              onPrimary: Colors.white,
              onSurface: ThemeColors.primary(context),
            ),
          ),
          child: child!,
        );
      },
    );
    if (date == null) return;

    if (!context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ThemeColors.primary(context),
              onPrimary: Colors.white,
              onSurface: ThemeColors.primary(context),
            ),
          ),
          child: child!,
        );
      },
    );
    if (time == null) return;

    setState(() {
      _selectedDeleteDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final classes = ref.watch(classesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeClass = classes.any((c) => c.id == _selectedClass)
        ? _selectedClass
        : (classes.isNotEmpty ? classes.first.id : '');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create Post",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ThemeColors.primary(context),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Publish announcements, assign homework, or draft study notes for your students.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          if (classes.isEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD9D9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade200, width: 1),
              ),
              child: Column(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red.shade900, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    "No Classes Available",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red.shade900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "You must create at least one class in the 'Classes' tab before you can publish updates, homework, or study materials.",
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ] else ...[
            // Post Type Selection
            Text(
              "POST TYPE",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white60 : Colors.black54,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: ['Homework', 'Notice', 'Alert'].map((type) {
                final isSelected = _selectedType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ChoiceChip(
                    label: Text(
                      type,
                      style: TextStyle(
                        color: isSelected ? Colors.white : ThemeColors.primary(context),
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
                    backgroundColor: ThemeColors.accentBg(context),
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
            Text(
              "TARGET CLASS",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white60 : Colors.black54,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: ThemeColors.accentBg(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: activeClass.isEmpty ? null : activeClass,
                  dropdownColor: ThemeColors.cardBg(context),
                  style: TextStyle(color: ThemeColors.textSecondary(context)),
                  items: classes.map((c) {
                    return DropdownMenuItem(
                      value: c.id,
                      child: Text(c.id, style: const TextStyle(fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedClass = val;
                      });
                    }
                  },
                  icon: Icon(Icons.arrow_drop_down, color: ThemeColors.primary(context)),
                  isExpanded: true,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              "TITLE",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white60 : Colors.black54,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              style: TextStyle(color: ThemeColors.textSecondary(context)),
              decoration: InputDecoration(
                hintText: "e.g., Assignment 3: Trees & Graphs",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: ThemeColors.accentBg(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Description
            Text(
              "DESCRIPTION / DETAILS",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white60 : Colors.black54,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              style: TextStyle(color: ThemeColors.textSecondary(context)),
              decoration: InputDecoration(
                hintText: "Provide post details, task instructions, or resource links here...",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: ThemeColors.accentBg(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            if (_selectedType == 'Homework') ...[
              const SizedBox(height: 24),
              Text(
                "ATTACHMENTS",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white60 : Colors.black54,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _showAttachmentDialog(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ThemeColors.accentBg(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                      style: BorderStyle.solid,
                      width: 1,
                    ),
                  ),
                  child: _attachedFileName == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.attach_file, color: ThemeColors.primary(context)),
                            const SizedBox(width: 8),
                            Text(
                              "Tap to attach a mock file",
                              style: TextStyle(
                                color: ThemeColors.primary(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            const Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _attachedFileName!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                  color: ThemeColors.primary(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _attachedFileName = null;
                                });
                              },
                            )
                          ],
                        ),
                ),
              ),
            ],

            if (_selectedType == 'Notice' || _selectedType == 'Alert') ...[
              const SizedBox(height: 24),
              Text(
                "DELETE DATE & TIME (OPTIONAL)",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white60 : Colors.black54,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ThemeColors.accentBg(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _selectedDeleteDateTime == null
                            ? "Stay visible forever (No delete date)"
                            : "Delete At: ${_selectedDeleteDateTime!.day}/${_selectedDeleteDateTime!.month}/${_selectedDeleteDateTime!.year} ${_selectedDeleteDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDeleteDateTime!.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: _selectedDeleteDateTime == null
                              ? Colors.grey.shade600
                              : ThemeColors.primary(context),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.calendar_month, color: ThemeColors.primary(context)),
                    onPressed: () => _pickDeleteDateTime(context),
                  ),
                  if (_selectedDeleteDateTime != null)
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _selectedDeleteDateTime = null;
                        });
                      },
                    ),
                ],
              ),
            ],

            const SizedBox(height: 32),

            // Publish button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (_titleController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill out all fields!"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  // Assign category colors/labels
                  Color postColor = const Color(0xFFFFD9D9);
                  String postCategory = "Academic";
                  if (_selectedType == "Notice") {
                    postColor = const Color(0xFFE2EDFF);
                    postCategory = "Urgent";
                  } else if (_selectedType == "Alert") {
                    postColor = const Color(0xFFFFE0B2);
                    postCategory = "Alert";
                  }

                  final newPost = PostModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    type: _selectedType,
                    title: _titleController.text.trim(),
                    description: _descriptionController.text.trim(),
                    targetClass: activeClass,
                    date: DateTime.now(),
                    category: postCategory,
                    color: postColor,
                    attachment: _selectedType == 'Homework' ? _attachedFileName : null,
                    deleteAt: (_selectedType == 'Notice' || _selectedType == 'Alert') ? _selectedDeleteDateTime : null,
                  );

                  ref.read(postsProvider.notifier).addPost(newPost);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Successfully published $_selectedType for $activeClass!"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  _titleController.clear();
                  _descriptionController.clear();
                  setState(() {
                    _attachedFileName = null;
                    _selectedDeleteDateTime = null;
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
                  "Publish Post",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showAttachmentDialog(BuildContext context) {
    final mockFiles = [
      "assignment_guidelines.pdf",
      "lab_instructions_3.pdf",
      "project_requirements.docx",
      "lecture_notes_ref.pdf"
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ThemeColors.cardBg(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "Select Mock File",
            style: TextStyle(fontWeight: FontWeight.bold, color: ThemeColors.primary(context)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: mockFiles.map((fileName) {
              return ListTile(
                leading: Icon(
                  fileName.endsWith('.pdf') ? Icons.picture_as_pdf : Icons.description,
                  color: fileName.endsWith('.pdf') ? Colors.red : Colors.blue,
                ),
                title: Text(fileName, style: TextStyle(fontSize: 14, color: ThemeColors.textSecondary(context))),
                onTap: () {
                  setState(() {
                    _attachedFileName = fileName;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
