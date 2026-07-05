import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project/role_choice.dart';
import 'package:project/providers.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final displayName = user?.displayName ?? "Dr. Sharma";
    final avatarUrl = user?.photoURL ?? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(displayName)}&background=random';

    final textPrimaryColor = isDark ? Colors.white : const Color(0xFF0F2C59);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Large Avatar
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 54,
                  backgroundColor: textPrimaryColor,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: textPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            displayName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? "No email linked",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Detail cards
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(context, "Employee ID", "EMP-90214", textPrimaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(context, "Department", "Computer Sci.", textPrimaryColor),
              ),
            ],
          ),

          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "ACCOUNT SETTINGS",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Settings list
          _buildSettingsTile(
            context,
            icon: Icons.security_outlined,
            title: "Security & Credentials",
            subtitle: "Manage passwords and 2FA",
            textPrimaryColor: textPrimaryColor,
          ),
          _buildSettingsTile(
            context,
            icon: Icons.notifications_none_rounded,
            title: "Notification Settings",
            subtitle: "Manage notice and query alerts",
            textPrimaryColor: textPrimaryColor,
          ),
          _buildSettingsTile(
            context,
            icon: Icons.dark_mode_outlined,
            title: "Theme Mode",
            subtitle: "Switch to dark theme",
            textPrimaryColor: textPrimaryColor,
            trailing: Switch(
              value: isDark,
              onChanged: (bool val) {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
              activeThumbColor: const Color(0xFF0F2C59),
            ),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.help_outline_rounded,
            title: "Help & Feedback",
            subtitle: "Contact support or view FAQ",
            textPrimaryColor: textPrimaryColor,
          ),

          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();

                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const RoleChoiceScreen()),
                    (route) => false,
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Logout from Account",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String label, String value, Color textPrimaryColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFEEF2F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color textPrimaryColor,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: textPrimaryColor),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      ),
    );
  }
}
