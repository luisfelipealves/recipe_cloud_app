import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryColor = Color(0xFFFFA726);
  static const Color _primaryLightColor = Color(0xFFFFB74D);
  static const Color _primaryDarkColor = Color(0xFFF57C00);

  static const Color _lightScaffoldBackgroundColor = Color(0xFFFFF8E1);
  static const Color _lightCardColor = Color(0xFFFFFFFF);

  static const Color _darkScaffoldBackgroundColor = Color(0xFF121212);
  static const Color _darkCardColor = Color(0xFF1E1E1E);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _primaryColor,
    primaryColorLight: _primaryLightColor,
    primaryColorDark: _primaryDarkColor,
    scaffoldBackgroundColor: _lightScaffoldBackgroundColor,
    cardColor: _lightCardColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.black,
      elevation: 1,
    ),
    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
      secondary: _primaryLightColor,
      surface: _lightScaffoldBackgroundColor,
      background: _lightScaffoldBackgroundColor,
      error: Colors.red,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _primaryColor,
    primaryColorLight: _primaryLightColor,
    primaryColorDark: _primaryDarkColor,
    scaffoldBackgroundColor: _darkScaffoldBackgroundColor,
    cardColor: _darkCardColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryDarkColor,
      foregroundColor: Colors.white,
      elevation: 1,
    ),
    colorScheme: const ColorScheme.dark(
      primary: _primaryColor,
      secondary: _primaryLightColor,
      surface: _darkCardColor,
      background: _darkScaffoldBackgroundColor,
      error: Colors.redAccent,
    ),
  );
}
