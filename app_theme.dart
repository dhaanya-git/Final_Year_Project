import 'package:flutter/material.dart';

class AppTheme {
  // Unified Yellow Theme
  static final ThemeData yellowTheme = ThemeData(
    primaryColor: Colors.amber[700],
    scaffoldBackgroundColor: Colors.amber[50],
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFC107), // Yellow/Amber
      foregroundColor: Colors.white, // White text/icons
      elevation: 4,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.amber[700],
      foregroundColor: Colors.white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.amber[800],
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    fontFamily: 'Roboto',
  );
}
