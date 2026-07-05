import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers.dart';

class TeacherAcademicsView extends ConsumerStatefulWidget {
  const TeacherAcademicsView({super.key});

  @override
  ConsumerState<TeacherAcademicsView> createState() => _TeacherAcademicsViewState();
}

class _TeacherAcademicsViewState extends ConsumerState<TeacherAcademicsView> {
  @override
  Widget build(BuildContext context) {
    final academics = ref.watch(academicsProvider);

    return Scaffold(
      backgroundColor: ThemeColors.scaffoldBg(context),
      appBar: AppBar(
        title: Text(
          "Academic Performance",
          style: TextStyle(color: ThemeColors.primary(context), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: ThemeColors.primary(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Student Progress Records",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ThemeColors.primary(context),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Add, view, and manage school exam results and remarks for registered students.",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: academics.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.analytics_outlined, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            "No academic records yet",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.primary(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Tap the '+' button below to record student marks.",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: academics.length,
                      itemBuilder: (context, index) {
                        final record = academics[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: ThemeColors.accentBg(context),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      record.examName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: ThemeColors.primary(context),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getGradeColor(record.grade).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Grade: ${record.grade}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: _getGradeColor(record.grade),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                record.studentName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: ThemeColors.primary(context),
                                ),
                              ),
                              Text(
                                record.studentEmail,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    record.subject,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blue),
                                  ),
                                  Text(
                                    "Score: ${record.marksObtained.toStringAsFixed(0)} / ${record.maxMarks.toStringAsFixed(0)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: ThemeColors.textSecondary(context),
                                    ),
                                  ),
                                ],
                              ),
                              if (record.remarks.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                const Divider(height: 1),
                                const SizedBox(height: 8),
                                Text(
                                  "Remarks: ${record.remarks}",
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: ThemeColors.textSecondary(context),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ],
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
        onPressed: () => _showAddPerformanceDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Color _getGradeColor(String grade) {
    if (grade.startsWith('A')) return Colors.green.shade700;
    if (grade.startsWith('B')) return Colors.blue.shade700;
    if (grade.startsWith('C')) return Colors.orange.shade700;
    if (grade.startsWith('D')) return Colors.deepOrange.shade700;
    return Colors.red.shade700;
  }

  void _showAddPerformanceDialog(BuildContext context) {
    final registeredStudents = ref.read(registeredStudentsProvider);
    if (registeredStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No students registered in the system yet. Please wait for students to sign up."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const AddPerformanceDialog(),
    );
  }
}

class AddPerformanceDialog extends ConsumerStatefulWidget {
  const AddPerformanceDialog({super.key});

  @override
  ConsumerState<AddPerformanceDialog> createState() => _AddPerformanceDialogState();
}

class _AddPerformanceDialogState extends ConsumerState<AddPerformanceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _marksController = TextEditingController();
  final _maxMarksController = TextEditingController(text: "100");
  final _remarksController = TextEditingController();

  StudentRegistryModel? _selectedStudent;
  
  final List<String> _subjects = [
    'Mathematics',
    'Science',
    'English',
    'Social Studies',
    'Hindi',
    'Computer Science'
  ];
  late String _selectedSubject;

  final List<String> _exams = [
    'Unit Test 1',
    'Unit Test 2',
    'Mid-Term Examination',
    'Final Examination'
  ];
  late String _selectedExam;

  @override
  void initState() {
    super.initState();
    _selectedSubject = _subjects.first;
    _selectedExam = _exams.first;
    
    // Auto-select first student if available
    final students = ref.read(registeredStudentsProvider);
    if (students.isNotEmpty) {
      _selectedStudent = students.first;
    }
  }

  @override
  void dispose() {
    _marksController.dispose();
    _maxMarksController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final students = ref.watch(registeredStudentsProvider);

    return AlertDialog(
      backgroundColor: ThemeColors.cardBg(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Add Academic Record",
        style: TextStyle(color: ThemeColors.primary(context), fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Student Selection Dropdown
              DropdownButtonFormField<StudentRegistryModel>(
                initialValue: _selectedStudent,
                dropdownColor: ThemeColors.cardBg(context),
                style: TextStyle(color: ThemeColors.textSecondary(context)),
                decoration: const InputDecoration(labelText: "Select Student"),
                items: students.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text("${s.name} (${s.email})", style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => _selectedStudent = val);
                },
                validator: (val) => val == null ? "Required" : null,
              ),
              const SizedBox(height: 12),

              // Subject Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedSubject,
                dropdownColor: ThemeColors.cardBg(context),
                style: TextStyle(color: ThemeColors.textSecondary(context)),
                decoration: const InputDecoration(labelText: "Subject"),
                items: _subjects.map((sub) {
                  return DropdownMenuItem(value: sub, child: Text(sub));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSubject = val);
                },
              ),
              const SizedBox(height: 12),

              // Exam Type Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedExam,
                dropdownColor: ThemeColors.cardBg(context),
                style: TextStyle(color: ThemeColors.textSecondary(context)),
                decoration: const InputDecoration(labelText: "Exam / Test Type"),
                items: _exams.map((ex) {
                  return DropdownMenuItem(value: ex, child: Text(ex));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedExam = val);
                },
              ),
              const SizedBox(height: 12),

              // Marks obtained and Max marks row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _marksController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(color: ThemeColors.textSecondary(context)),
                      decoration: const InputDecoration(
                        labelText: "Marks Obtained",
                        hintText: "e.g. 85",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return "Required";
                        final score = double.tryParse(value.trim());
                        if (score == null) return "Invalid number";
                        if (score < 0) return "Must be positive";
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _maxMarksController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(color: ThemeColors.textSecondary(context)),
                      decoration: const InputDecoration(
                        labelText: "Max Marks",
                        hintText: "e.g. 100",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return "Required";
                        final maxM = double.tryParse(value.trim());
                        if (maxM == null) return "Invalid number";
                        if (maxM <= 0) return "Must be > 0";
                        
                        // Check if marks obtained is higher than max
                        final score = double.tryParse(_marksController.text.trim());
                        if (score != null && score > maxM) {
                          return "Cannot be < Marks";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Remarks
              TextFormField(
                controller: _remarksController,
                style: TextStyle(color: ThemeColors.textSecondary(context)),
                decoration: const InputDecoration(
                  labelText: "Teacher Remarks",
                  hintText: "e.g. Excellent logic, keep it up",
                ),
                maxLines: 2,
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
            if ((_formKey.currentState?.validate() ?? false) && _selectedStudent != null) {
              final marks = double.parse(_marksController.text.trim());
              final maxMarks = double.parse(_maxMarksController.text.trim());
              final calculatedGrade = calculateSchoolGrade(marks, maxMarks);

              final record = AcademicPerformanceModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                studentEmail: _selectedStudent!.email,
                studentName: _selectedStudent!.name,
                subject: _selectedSubject,
                examName: _selectedExam,
                marksObtained: marks,
                maxMarks: maxMarks,
                grade: calculatedGrade,
                remarks: _remarksController.text.trim(),
                date: DateTime.now(),
              );

              ref.read(academicsProvider.notifier).addPerformance(record);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Academic performance recorded for ${_selectedStudent!.name}!"),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
