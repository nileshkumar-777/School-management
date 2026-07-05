import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers.dart';

class ClassesView extends ConsumerWidget {
  const ClassesView({super.key});





  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classes = ref.watch(classesProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFEEF2F9),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Classes",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F2C59),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "View schedule, enrollments, and syllabus progress for your assigned courses.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: classes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school_outlined, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            "No classes created yet",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F2C59),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Tap the '+' button below to set up your first academic class.",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: classes.length,
                      itemBuilder: (context, index) {
                        final c = classes[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: c.color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.book_outlined, color: c.textColor),
                              ),
                              title: Text(
                                c.id,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDark ? Colors.white : const Color(0xFF0F2C59),
                                ),
                              ),
                              subtitle: Text(
                                c.name,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Divider(height: 1),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          const Icon(Icons.people_outline, size: 16, color: Colors.grey),
                                          const SizedBox(width: 8),
                                          Text(
                                            "${c.studentsCount} Students Enrolled",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: isDark ? Colors.white70 : Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              c.time,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: isDark ? Colors.white70 : Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () => _showRosterDialog(context, c),
                                            child: const Text("View Roster"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => _showAddStudentsDialog(context, ref, c),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: c.color,
                                              foregroundColor: c.textColor,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text("Add Students"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
        onPressed: () => _showCreateClassDialog(context, ref),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showRosterDialog(BuildContext context, ClassModel c) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "Class Roster - ${c.id}",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F2C59)),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Consumer(
              builder: (context, ref, child) {
                final classes = ref.watch(classesProvider);
                final currentClass = classes.firstWhere((cl) => cl.id == c.id, orElse: () => c);

                if (currentClass.enrolledStudents.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      "No students enrolled in this class yet.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: currentClass.enrolledStudents.length,
                  itemBuilder: (context, index) {
                    final studentName = currentClass.enrolledStudents[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: currentClass.color,
                        child: Text(
                          studentName.split(' ').map((e) => e[0]).take(2).join(),
                          style: TextStyle(color: currentClass.textColor, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(studentName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () {
                          ref.read(classesProvider.notifier).removeStudentFromClass(currentClass.id, studentName);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Removed '$studentName' from '${currentClass.id}'."),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      dense: true,
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showAddStudentsDialog(BuildContext context, WidgetRef ref, ClassModel c) {
    final registeredStudents = ref.read(registeredStudentsProvider);
    // Filter candidates: exclude those whose name is already in the class roster
    final candidates = registeredStudents.where((student) {
      return !c.enrolledStudents.contains(student.name);
    }).toList();

    final selectedStudents = <StudentRegistryModel>[];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                "Enroll Students to ${c.id}",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F2C59)),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: candidates.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          "No new registered students available to enroll.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: candidates.length,
                        itemBuilder: (context, index) {
                          final student = candidates[index];
                          final isSelected = selectedStudents.contains(student);
                          return CheckboxListTile(
                            activeColor: const Color(0xFF0F2C59),
                            title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(student.email, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            value: isSelected,
                            onChanged: (bool? checked) {
                              setState(() {
                                if (checked == true) {
                                  selectedStudents.add(student);
                                } else {
                                  selectedStudents.remove(student);
                                }
                              });
                            },
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                if (candidates.isNotEmpty)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F2C59),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: selectedStudents.isEmpty
                        ? null
                        : () {
                            final namesToEnroll = selectedStudents.map((s) => s.name).toList();
                            ref.read(classesProvider.notifier).addStudentsToClass(c.id, namesToEnroll);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Enrolled ${namesToEnroll.length} student(s) in '${c.id}'!"),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                    child: const Text("Enroll"),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCreateClassDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const CreateClassDialog(),
    );
  }
}

class CreateClassDialog extends ConsumerStatefulWidget {
  const CreateClassDialog({super.key});

  @override
  ConsumerState<CreateClassDialog> createState() => _CreateClassDialogState();
}

class _CreateClassDialogState extends ConsumerState<CreateClassDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _subjectController;
  late final TextEditingController _timeController;

  String _selectedDept = 'CSE';
  String _selectedSem = '3';
  String _selectedSec = 'A';

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _nameController = TextEditingController();
    _subjectController = TextEditingController();
    _timeController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _subjectController.dispose();
    _timeController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "Create New Class",
        style: TextStyle(color: Color(0xFF0F2C59), fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Class Code (e.g. CSE 1A)",
                  hintText: "CSE 1A",
                ),
                validator: (value) => value == null || value.trim().isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Class Name (e.g. Database Management)",
                  hintText: "Database Management Systems",
                ),
                validator: (value) => value == null || value.trim().isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: "Subject Code / Abbreviation",
                  hintText: "DBMS",
                ),
                validator: (value) => value == null || value.trim().isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: "Schedule Time",
                  hintText: "Monday, Wednesday • 9:00 AM",
                ),
                validator: (value) => value == null || value.trim().isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedDept,
                      decoration: const InputDecoration(labelText: "Dept"),
                      items: ['CSE', 'ECE', 'ME', 'CE'].map((d) {
                        return DropdownMenuItem(value: d, child: Text(d));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedDept = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedSem,
                      decoration: const InputDecoration(labelText: "Sem"),
                      items: ['1', '2', '3', '4', '5', '6', '7', '8'].map((s) {
                        return DropdownMenuItem(value: s, child: Text(s));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedSem = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedSec,
                      decoration: const InputDecoration(labelText: "Sec"),
                      items: ['A', 'B', 'C'].map((s) {
                        return DropdownMenuItem(value: s, child: Text(s));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedSec = val);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F2C59),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              final List<Color> colors = [
                const Color(0xFFD3E3FD),
                const Color(0xFFE2EDFF),
                const Color(0xFFFCE9A4),
                const Color(0xFFE8F5E9),
                const Color(0xFFF3E5F5)
              ];
              final List<Color> textColors = [
                const Color(0xFF0F2C59),
                const Color(0xFF0F2C59),
                const Color(0xFF9E8B2A),
                Colors.green.shade800,
                Colors.purple.shade800,
              ];
              final index = ref.read(classesProvider).length % colors.length;

              final newClass = ClassModel(
                id: _codeController.text.trim(),
                name: _nameController.text.trim(),
                subject: _subjectController.text.trim(),
                semester: _selectedSem,
                section: _selectedSec,
                department: _selectedDept,
                enrolledStudents: const [],
                time: _timeController.text.trim(),
                color: colors[index],
                textColor: textColors[index],
              );

              ref.read(classesProvider.notifier).addClass(newClass);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Class '${newClass.id}' created successfully!"),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: const Text("Create"),
        ),
      ],
    );
  }
}
