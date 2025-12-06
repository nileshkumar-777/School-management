import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const EduFlow(), // splash screen widget
    );
  }
}

class EduFlow extends StatefulWidget {
  const EduFlow({super.key});

  @override
  State<EduFlow> createState() => _EduFlowState();
}

class _EduFlowState extends State<EduFlow> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 226, 220, 231),
              Color.fromARGB(255, 196, 170, 188),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "EduFlow",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1E22),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Unlocking potential, one lesson at a time.",
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(137, 0, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
