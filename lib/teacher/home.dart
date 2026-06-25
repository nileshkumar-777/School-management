import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_view.dart';
import 'classes_view.dart';
import 'create_view.dart';
import 'alerts_view.dart';
import 'profile_view.dart';
import 'package:project/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    return Scaffold(
      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(ref, 0, Icons.home_outlined, "Home"),
            _buildNavItem(ref, 1, Icons.book_outlined, "Classes"),
            _buildNavItem(ref, 2, Icons.add_circle_outline, "Create"),
            _buildNavItem(ref, 3, Icons.notifications_none, "Alerts"),
            _buildNavItem(ref, 4, Icons.person_outline, "Profile"),
          ],
        ),
      ),
      
      // Main Scrollable Content
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: const [
            TeacherHomeView(),
            ClassesView(),
            CreateView(),
            AlertsView(),
            ProfileView(),
          ],
        ),
      ),
    );
  }

  // --- Bottom Navigation Item Helper ---
  Widget _buildNavItem(WidgetRef ref, int index, IconData icon, String label) {
    final currentIndex = ref.watch(navigationProvider);
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () {
        ref.read(navigationProvider.notifier).setIndex(index);
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.blue : Colors.grey.shade600,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? Colors.blue : Colors.grey.shade600,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
