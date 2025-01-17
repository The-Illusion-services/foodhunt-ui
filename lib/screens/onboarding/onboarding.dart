import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_hunt/providers/app_state.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to the App! Let's get started."),
            ElevatedButton(
              onPressed: () {
                ref.read(appStateProvider.notifier).completeOnboarding();
                context.go('/login');
              },
              child: Text("Get Started"),
            ),
          ],
        ),
      ),
    );
  }
}
