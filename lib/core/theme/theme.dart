import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData themeData() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.blue,
      scaffoldBackgroundColor: AppColors.black,
      appBarTheme: const AppBarTheme(
        color: AppColors.black,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.grayDark,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          color: AppColors.grayLight,
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          color: AppColors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.grayLight,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(AppColors.blue),
          foregroundColor: WidgetStateProperty.all<Color>(AppColors.white),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(AppColors.blue),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.grayLight,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.blue,
            width: 2,
          ),
        ),
        hintStyle: TextStyle(
          color: AppColors.grayLight,
        ),
        labelStyle: TextStyle(
          color: AppColors.white,
        ),
      ),
    );
  }
}
