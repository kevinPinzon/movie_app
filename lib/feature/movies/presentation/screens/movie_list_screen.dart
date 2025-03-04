import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/sizes.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Movie List!',
          style: TextStyle(
            fontSize: bigTextSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
