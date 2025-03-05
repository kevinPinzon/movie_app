import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/colors.dart';
import 'package:movie_app/core/theme/sizes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.grayDark,
      elevation: 4,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: bigTextSize,
          fontWeight: FontWeight.bold,
          color: AppColors.grayLight,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
