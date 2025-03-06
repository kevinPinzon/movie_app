import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/core/common/resource_images.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> processScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      context.go('/movieList');
    }
  }

  @override
  Widget build(BuildContext context) {
    processScreen(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              loader,
              height: 300,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              'Movie App',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
