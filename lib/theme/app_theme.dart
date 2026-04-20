import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: const Color(0xFFFF6B35),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFF6B35),
      secondary: Color(0xFF4ECDC4),
      background: Color(0xFFFFFFFF),
      surface: Color(0xFFF8F9FA),
      error: Color(0xFFFF4757),
    ),
    fontFamily: 'NotoSansSC',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
      displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
      displaySmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF34495E)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF7F8C8D)),
      bodySmall: TextStyle(fontSize: 12, color: Color(0xFF95A5A6)),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFFFF6B35),
      textTheme: ButtonTextTheme.primary,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
    ),
    cardTheme: const CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      margin: EdgeInsets.all(8),
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: const Color(0xFFFF6B35),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFF6B35),
      secondary: Color(0xFF4ECDC4),
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
      error: Color(0xFFFF4757),
    ),
    fontFamily: 'NotoSansSC',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
      displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
      displaySmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFE0E0E0)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFB0B0B0)),
      bodySmall: TextStyle(fontSize: 12, color: Color(0xFF808080)),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFFFF6B35),
      textTheme: ButtonTextTheme.primary,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
    ),
    cardTheme: const CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      margin: EdgeInsets.all(8),
    ),
  );
}