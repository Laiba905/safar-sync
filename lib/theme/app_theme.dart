import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors constants
  static const Color deepIndigo = Color(0xFF1E1B4B);
  static const Color electricTeal = Color(0xFF0D9488);

  // Light Mode Colors
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF0F172A);

  // Dark Mode Colors
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkText = Color(0xFFF1F5F9);

  // ☀️ LIGHT THEME DATA
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: deepIndigo,
      scaffoldBackgroundColor: lightBg,
      colorScheme: const ColorScheme.light(
        primary: deepIndigo,
        secondary: electricTeal,
        surface: lightBg, // Updated from background
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightText, // Updated from onBackground
      ),
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: lightText),
        titleTextStyle: TextStyle(color: lightText, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      // Card Theme Data Fix
      cardTheme: CardThemeData( // Changed from CardTheme to CardThemeData
        color: lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // 🌙 DARK THEME DATA
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: electricTeal,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: electricTeal,
        secondary: deepIndigo,
        surface: darkBg, // Updated from background
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkText, // Updated from onBackground
      ),
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: darkText),
        titleTextStyle: TextStyle(color: darkText, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      // Card Theme Data Fix
      cardTheme: CardThemeData( // Changed from CardTheme to CardThemeData
        color: darkSurface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}