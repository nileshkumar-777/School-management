import 'package:flutter/material.dart';

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Academic Stats",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F2C59),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Review student attendance, grades, and task completion metrics.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Total Overview Cards
          _buildPerformanceCard(
            title: "Average Attendance",
            percentage: 0.92,
            icon: Icons.check_circle_outline_rounded,
            accentColor: Colors.blue,
            backgroundColor: const Color(0xFFE2EDFF),
          ),
          const SizedBox(height: 16),
          _buildPerformanceCard(
            title: "Homework Submission Rate",
            percentage: 0.86,
            icon: Icons.task_outlined,
            accentColor: const Color(0xFF9E8B2A),
            backgroundColor: const Color(0xFFFCE9A4),
          ),
          const SizedBox(height: 16),
          _buildPerformanceCard(
            title: "Exam Completion Rate",
            percentage: 0.98,
            icon: Icons.grade_outlined,
            accentColor: Colors.green,
            backgroundColor: const Color(0xFFE8F5E9),
          ),

          const SizedBox(height: 32),
          const Text(
            "CLASS WISE PERFORMANCE",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),

          // Class-wise detail list
          _buildClassStatItem("CSE 1A - Data Structures", "Avg Grade: 84% (A)", 0.84, Colors.blue),
          _buildClassStatItem("CSE 1B - OOP", "Avg Grade: 78% (B+)", 0.78, Colors.blue),
          _buildClassStatItem("CSE 2A - Operating Systems", "Avg Grade: 91% (A+)", 0.91, Colors.green),
          _buildClassStatItem("ECE 1A - Digital Electronics", "Avg Grade: 71% (B-)", 0.71, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard({
    required String title,
    required double percentage,
    required IconData icon,
    required Color accentColor,
    required Color backgroundColor,
  }) {
    final displayPercent = (percentage * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Circular Progress Indicator
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 8,
                  backgroundColor: backgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
                Center(
                  child: Text(
                    "$displayPercent%",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 18, color: accentColor),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F2C59),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Great work! This is well above the school-wide average.",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassStatItem(String className, String gradeText, double ratio, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                className,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2C59),
                ),
              ),
              Text(
                gradeText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
