import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/core/common/resource_images.dart';
import 'package:movie_app/core/theme/sizes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> processScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

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
            const Text(
              'Loading...',
              style: TextStyle(
                fontSize: bigTextSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
