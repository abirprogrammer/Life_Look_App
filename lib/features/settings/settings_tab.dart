import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Pro Profile', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Pro Profile Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryPurple, AppTheme.secondaryPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: AppTheme.primaryPurple),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LifeLoop Pro User', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('user@lifeloop.app', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      SizedBox(height: 8),
                      Chip(
                        label: Text('PRO MEMBER', style: TextStyle(color: AppTheme.primaryPurple, fontSize: 10, fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('Preferences', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Toggle dark aesthetic mode'),
                  secondary: const Icon(Icons.dark_mode_outlined, color: AppTheme.primaryPurple),
                  value: isDark,
                  onChanged: (val) {
                    ref.read(themeModeProvider.notifier).state = val;
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_active_outlined, color: AppTheme.primaryPurple),
                  title: const Text('Notification Reminders', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Daily push alerts for tasks & habits'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notification schedule updated')));
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.psychology_outlined, color: AppTheme.primaryPurple),
                  title: const Text('Abir AI Language & Persona', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Bilingual (Bangla & English) enabled'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Abir AI is active in Bilingual mode')));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Data & Security', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cloud_sync_outlined, color: AppTheme.primaryPurple),
                  title: const Text('Cloud Backup & Sync', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Synced with Firebase Cloud Firestore'),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: AppTheme.primaryPurple),
                  title: const Text('Privacy Policy & Terms', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'LifeLoop — Your Life, Connected',
                      applicationVersion: '1.0.0+1 (Pro Release)',
                      applicationLegalese: '© 2026 LifeLoop Inc. All rights reserved.',
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('LifeLoop secures all your personal goals, habits, and tasks with end-to-end cloud encryption and Abir AI intelligence.'),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          ElevatedButton.icon(
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
              if (context.mounted) context.go('/auth');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
