import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: AppTheme.primaryPurple.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))
                  ],
                ),
                child: const Icon(Icons.all_inclusive, size: 70, color: Colors.white),
              ),
              const SizedBox(height: 32),
              const Text(
                'LifeLoop',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.primaryPurple),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your Life, Connected',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              const Text(
                'Master your tasks, build powerful daily habits, and supercharge your productivity with Gemini AI assistance.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/auth'),
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
