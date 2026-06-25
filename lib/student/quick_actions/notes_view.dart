import 'package:flutter/material.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = [
      {
        "title": "Unit 3: Normalization & Functional Dependencies",
        "fileName": "DBMS_Unit_3_Normalization.pdf",
        "fileSize": "4.2 MB",
        "fileType": "PDF",
        "subject": "Database Management Systems",
        "uploader": "Dr. Sharma",
        "date": "June 18, 2026",
        "color": const Color(0xFFD3E3FD),
      },
      {
        "title": "Module 4: Binary Trees & BST Operations",
        "fileName": "DSA_Trees_LectureNotes.pdf",
        "fileSize": "5.8 MB",
        "fileType": "PDF",
        "subject": "Data Structures & Algorithms",
        "uploader": "Dr. Sharma",
        "date": "June 20, 2026",
        "color": const Color(0xFFE2EDFF),
      },
      {
        "title": "CPU Scheduling Algorithms - Visual Slides",
        "fileName": "OS_Scheduling_Slides.pptx",
        "fileSize": "12.4 MB",
        "fileType": "PPTX",
        "subject": "Operating Systems",
        "uploader": "Dr. Sharma",
        "date": "June 22, 2026",
        "color": const Color(0xFFFCE9A4),
      },
      {
        "title": "Logic Gates & Multiplexers Laboratory Guide",
        "fileName": "Digital_Lab_Manual_1.pdf",
        "fileSize": "2.1 MB",
        "fileType": "PDF",
        "subject": "Digital Electronics",
        "uploader": "Dr. Sharma",
        "date": "June 15, 2026",
        "color": const Color(0xFFE8F5E9),
      },
    ];

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
          "Study Material & Notes",
          style: TextStyle(
            color: Color(0xFF0F2C59),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          final isPdf = note["fileType"] == "PDF";

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
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (note["color"] as Color).withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isPdf ? Icons.picture_as_pdf : Icons.slideshow,
                          color: const Color(0xFF0F2C59),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note["title"] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F2C59),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${note["subject"]} • ${note["uploader"]}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file_outlined, size: 16, color: Colors.black54),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            note["fileName"] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          note["fileSize"] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "Shared: ${note["date"]}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.download, size: 20, color: Color(0xFF0F2C59)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Downloading ${note["fileName"]}...'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
