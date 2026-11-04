import 'package:flutter/material.dart';

abstract final class BitWaveTheme {
  static const background = Color(0xFF090B12);
  static const surface = Color(0xFF121724);
  static const elevated = Color(0xFF1A2233);
  static const border = Color(0xFF283248);
  static const accent = Color(0xFF8B5CF6);
  static const accentBlue = Color(0xFF3B82F6);
  static const text = Color(0xFFF3F4F8);
  static const muted = Color(0xFF929AAF);

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.dark,
      surface: surface,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme.copyWith(
        primary: accent,
        secondary: accentBlue,
        surface: surface,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: elevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: Color(0x338B5CF6),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
