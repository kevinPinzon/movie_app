import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData themeData() {
    return ThemeData(
      primaryColor: Colors.grey[700],
      scaffoldBackgroundColor: Colors.grey[100],
      appBarTheme: AppBarTheme(
        color: Colors.grey[700],
      ),
      cardTheme: CardTheme(
        color: Colors.grey[200],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
      ),
    );
  }
}

const inputDecorationTheme = InputDecorationTheme(
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: onBackgroundColor,
      width: 1,
    ),
  ),
);
