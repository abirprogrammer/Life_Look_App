import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/app_models.dart';

class SocialTab extends StatelessWidget {
  const SocialTab({super.key});

  @override
  Widget build(BuildContext context) {
    final challenges = [
      ChallengeModel(id: 'c1', title: '30-Day Morning Workout Challenge', description: 'Join 1,420 members waking up early and exercising daily.', participantsCount: 1420),
      ChallengeModel(id: 'c2', title: 'Zero Sugar 2 Weeks', description: 'Eliminate added sugars for better energy and focus.', participantsCount: 890),
      ChallengeModel(id: 'c3', title: 'Read 10 Pages Daily', description: 'Build a consistent reading habit with peers.', participantsCount: 650),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community & Challenges', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final c = challenges[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(c.description, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.people_outline, size: 18, color: AppTheme.primaryPurple),
                          const SizedBox(width: 4),
                          Text('${c.participantsCount} participants', style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joined ${c.title}! 🚀')));
                        },
                        style: ElevatedButton.styleFrom(minimumSize: const Size(100, 36)),
                        child: const Text('Join'),
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
