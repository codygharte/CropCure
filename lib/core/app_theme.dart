import 'package:flutter/material.dart';

class AppTheme {
  // Define static text styles for easy access throughout the app
  static const TextStyle poltawskiNowy = TextStyle(fontFamily: 'PoltawskiNowy');
  static const TextStyle poppins = TextStyle(fontFamily: 'Poppins');

  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF2DBE62),
    scaffoldBackgroundColor: Colors.white,
    // Setting Poppins as the default font for the entire application
    fontFamily: 'Poppins',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2DBE62),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      prefixIconColor: Colors.grey[600],
    ),
  );
}


