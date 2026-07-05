import 'package:flutter/material.dart';
import 'package:project/login.dart';

class RoleChoiceScreen extends StatelessWidget {
  const RoleChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/fblackboard.png", fit: BoxFit.cover),
          ),

          Column(
            children: [
              const SizedBox(height: 200),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ------------------------------
                  // TEACHER BUTTON (SWINGING)
                  // ------------------------------
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen(role: "Teacher"),
                        ),
                      );
                    },
                    child: _SwingAnimation(
                      child: Image.asset(
                        "assets/teacher.png",
                        height: 400,
                        width: 200,
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // ------------------------------
                  // STUDENT BUTTON (SWINGING)
                  // ------------------------------
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen(role: "Student"),
                        ),
                      );
                    },
                    child: _SwingAnimation(
                      child: Image.asset(
                        "assets/student1.png",
                        height: 300,
                        width: 190,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SwingAnimation extends StatefulWidget {
  final Widget child;

  const _SwingAnimation({required this.child});

  @override
  State<_SwingAnimation> createState() => _SwingAnimationState();
}

class _SwingAnimationState extends State<_SwingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotation = Tween<double>(
      begin: -0.03,
      end: 0.03,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotation.value,
          alignment: Alignment.topCenter,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
