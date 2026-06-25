import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/eduflow.dart';
import 'package:project/role_choice.dart';
import 'package:project/teacher/home.dart' as teacher;
import 'package:project/student/home.dart' as student;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for 3 seconds to show off the beautiful loading screen
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final displayName = user.displayName ?? "";
      if (displayName.contains('|')) {
        final role = displayName.split('|').last;
        if (role == "Teacher") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const teacher.HomeScreen()),
          );
          return;
        } else if (role == "Student") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const student.HomeScreen()),
          );
          return;
        }
      }
      // If role is missing or unparseable, sign out and go to role selection
      await FirebaseAuth.instance.signOut();
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RoleChoiceScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Re-use the beautiful EduFlow loading component for the startup screen!
    return const EduFlow();
  }
}
