import 'package:flutter/material.dart';

class AppTheme {
  // Cor primária base (amarelo alaranjado)
  static const Color _primaryColor = Color(
    0xFFFFA726,
  ); // Um tom de amarelo alaranjado
  static const Color _primaryLightColor = Color(0xFFFFB74D);
  static const Color _primaryDarkColor = Color(0xFFF57C00);

  // Cor para o fundo "papel" no tema claro
  static const Color _lightScaffoldBackgroundColor = Color(
    0xFFFFF8E1,
  ); // Um off-white amarelado, como papel antigo
  static const Color _lightCardColor = Color(0xFFFFFFFF);

  // Cores para o tema escuro
  static const Color _darkScaffoldBackgroundColor = Color(
    0xFF121212,
  ); // Padrão do Material Design para dark
  static const Color _darkCardColor = Color(
    0xFF1E1E1E,
  ); // Um pouco mais claro que o fundo

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _primaryColor,
    primaryColorLight: _primaryLightColor,
    primaryColorDark: _primaryDarkColor,
    scaffoldBackgroundColor: _lightScaffoldBackgroundColor,
    cardColor: _lightCardColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.black, // Cor do texto e ícones na AppBar
      elevation: 1,
    ),
    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
      secondary: _primaryLightColor, // Pode ser a mesma ou uma variação
      surface: _lightScaffoldBackgroundColor,
      background: _lightScaffoldBackgroundColor,
      error: Colors.red,
      onPrimary: Colors.black, // Texto/ícones sobre a cor primária
      onSecondary: Colors.black,
      onSurface:
          Colors.black, // Texto/ícones sobre a cor de superfície (ex: cards)
      onBackground: Colors.black,
      onError: Colors.white,
    ),
    textTheme: const TextTheme(
      // Para garantir que o texto seja legível
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black),
      // Defina outros estilos de texto conforme necessário
    ),
    // Outras customizações como buttonTheme, inputDecorationTheme, etc.
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _primaryColor, // Usaremos a mesma cor primária vibrante
    primaryColorLight: _primaryLightColor,
    primaryColorDark: _primaryDarkColor,
    scaffoldBackgroundColor: _darkScaffoldBackgroundColor,
    cardColor: _darkCardColor,
    appBarTheme: const AppBarTheme(
      backgroundColor:
          _primaryDarkColor, // Um tom mais escuro para a appbar no dark theme
      foregroundColor: Colors.white,
      elevation: 1,
    ),
    colorScheme: const ColorScheme.dark(
      primary: _primaryColor,
      secondary: _primaryLightColor,
      surface: _darkCardColor, // Cor de superfície para cards, etc.
      background: _darkScaffoldBackgroundColor,
      error: Colors.redAccent,
      // onPrimary, onSecondary, etc., geralmente são bem definidos pelo ColorScheme.dark
    ),
    // Outras customizações
  );
}
