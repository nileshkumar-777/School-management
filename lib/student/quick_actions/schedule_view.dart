import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers.dart';

class ScheduleView extends ConsumerWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSlots = ref.watch(masterScheduleProvider);
    final classes = ref.watch(classesProvider);
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    final rawName = user?.displayName ?? "Nilesh Kumar";
    final studentName = rawName.split('|').first.trim();

    // Determine the student's enrolled class, default to "CSE 1A"
    final enrolledClassIds = classes
        .where((c) => c.enrolledStudents.contains(studentName))
        .map((c) => c.id)
        .toList();
    final studentClassId = enrolledClassIds.isNotEmpty ? enrolledClassIds.first : "CSE 1A";

    final days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];

    // Group the slots matching this student's classId by day
    final Map<String, List<ScheduleSlotModel>> studentSchedule = {};
    for (final day in days) {
      studentSchedule[day] = allSlots
          .where((slot) => slot.day == day && slot.classId == studentClassId)
          .toList();
    }

    return DefaultTabController(
      length: days.length,
      child: Scaffold(
        backgroundColor: ThemeColors.scaffoldBg(context),
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ThemeColors.primary(context)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "My Schedule ($studentClassId)",
            style: TextStyle(
              color: ThemeColors.primary(context),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: ThemeColors.primary(context),
            labelColor: ThemeColors.primary(context),
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: days.map((day) => Tab(text: day.substring(0, 3))).toList(),
          ),
        ),
        body: TabBarView(
          children: days.map((day) {
            final slots = studentSchedule[day] ?? [];

            if (slots.isEmpty) {
              return const Center(
                child: Text(
                  "No classes scheduled for today.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: slots.length,
              itemBuilder: (context, index) {
                final slot = slots[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
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
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 110,
                        decoration: BoxDecoration(
                          color: slot.color,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    slot.time,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: ThemeColors.primary(context),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: ThemeColors.accentBg(context),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      slot.type,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: ThemeColors.primary(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                slot.subject,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeColors.textSecondary(context),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Instructor: ${slot.instructor}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    slot.room,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF0F2C59),
          onPressed: () => _showAddSlotDialog(context, ref, studentClassId),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _showAddSlotDialog(BuildContext context, WidgetRef ref, String studentClassId) {
    final titleController = TextEditingController();
    final roomController = TextEditingController();
    String selectedDay = 'Monday';
    String selectedInstructor = 'Dr. Sharma';
    String selectedType = 'Theory Lecture';
    TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 0);
    Color selectedColor = const Color(0xFFD3E3FD);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: ThemeColors.cardBg(context),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                "Add Class Slot",
                style: TextStyle(fontWeight: FontWeight.bold, color: ThemeColors.primary(context)),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Subject Name'),
                      style: TextStyle(color: ThemeColors.textSecondary(context)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: roomController,
                      decoration: const InputDecoration(labelText: 'Room Number'),
                      style: TextStyle(color: ThemeColors.textSecondary(context)),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedDay,
                      decoration: const InputDecoration(labelText: 'Day'),
                      dropdownColor: ThemeColors.cardBg(context),
                      style: TextStyle(color: ThemeColors.textSecondary(context)),
                      items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
                          .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedDay = val!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedInstructor,
                      decoration: const InputDecoration(labelText: 'Instructor'),
                      dropdownColor: ThemeColors.cardBg(context),
                      style: TextStyle(color: ThemeColors.textSecondary(context)),
                      items: ['Dr. Sharma', 'Prof. Verma', 'Prof. Roy', 'Dr. Ananya Sen', 'Dr. Rajesh Patel']
                          .map((inst) => DropdownMenuItem(value: inst, child: Text(inst)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedInstructor = val!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedType,
                      decoration: const InputDecoration(labelText: 'Slot Type'),
                      dropdownColor: ThemeColors.cardBg(context),
                      style: TextStyle(color: ThemeColors.textSecondary(context)),
                      items: ['Theory Lecture', 'Lab Practical', 'Seminar', 'Guest Lecture']
                          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedType = val!),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final picked = await showTimePicker(context: context, initialTime: startTime);
                              if (picked != null) setState(() => startTime = picked);
                            },
                            child: Text(startTime.format(context)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final picked = await showTimePicker(context: context, initialTime: endTime);
                              if (picked != null) setState(() => endTime = picked);
                            },
                            child: Text(endTime.format(context)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Color(0xFFD3E3FD),
                        const Color(0xFFFFD9D9),
                        const Color(0xFFE2EDFF),
                        const Color(0xFFFCE9A4),
                        const Color(0xFFE8F5E9)
                      ].map((color) {
                        final isSelected = selectedColor == color;
                        return GestureDetector(
                          onTap: () => setState(() => selectedColor = color),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: ThemeColors.primary(context), width: 2)
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F2C59)),
                  onPressed: () {
                    if (titleController.text.trim().isEmpty || roomController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill out all fields!")),
                      );
                      return;
                    }

                    final newSlot = ScheduleSlotModel(
                      day: selectedDay,
                      time: "${startTime.format(context)} - ${endTime.format(context)}",
                      subject: titleController.text.trim(),
                      classId: studentClassId,
                      instructor: selectedInstructor,
                      room: roomController.text.trim(),
                      type: selectedType,
                      color: selectedColor,
                    );

                    ref.read(masterScheduleProvider.notifier).addSlot(newSlot);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Slot added successfully for $selectedDay!")),
                    );
                  },
                  child: const Text("Add", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
