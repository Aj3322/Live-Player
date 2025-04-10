import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Colors.blue.shade800,
      secondary: Colors.blue.shade600,
      surface: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue.shade800,
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blue.shade600,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Colors.blue.shade300,
      secondary: Colors.blue.shade200,
      surface: Colors.grey.shade800,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade900,
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blue.shade300,
      foregroundColor: Colors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.grey.shade700,
    ),
    useMaterial3: true,
  );
}