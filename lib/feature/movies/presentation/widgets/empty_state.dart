import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/colors.dart';

class EmptyState extends StatelessWidget {
  final String message;

  const EmptyState({super.key, this.message = 'No results found'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 100,
              color: AppColors.grayLight,
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.grayLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Try adjusting your search or filters.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.grayLight,
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
