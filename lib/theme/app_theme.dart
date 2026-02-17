import 'package:flutter/material.dart';

class AppTheme {
  // ═══════ Dark Theme Colors ═══════
  static const darkBackground = Color(0xFF0F172A);
  static const darkBackgroundAlt = Color(0xFF0A0F18);
  static const darkCard = Color(0xFF1A212C);
  static const darkCardAlt = Color(0xFF161D27);
  static const darkSurface = Color(0xFF1E293B);
  static const darkBorder = Color(0x0DFFFFFF); // white/5
  static const darkTextPrimary = Colors.white;
  static const darkTextSecondary = Color(0xFF94A3B8); // slate-400
  static const darkTextTertiary = Color(0xFF64748B); // slate-500
  static const darkTextQuaternary = Color(0xFF475569); // slate-600

  // ═══════ Light Theme Colors ═══════
  static const lightBackground = Color(0xFFFFFFFF);
  static const lightBackgroundAlt = Color(0xFFF8FAFC);
  static const lightCard = Color(0xFFF1F5F9);
  static const lightCardAlt = Color(0xFFE2E8F0);
  static const lightSurface = Color(0xFFE2E8F0);
  static const lightBorder = Color(0x1A000000); // black/10
  static const lightTextPrimary = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF475569);
  static const lightTextTertiary = Color(0xFF64748B);
  static const lightTextQuaternary = Color(0xFF94A3B8);

  // ═══════ Shared Colors ═══════
  static const primaryBlue = Color(0xFF3B82F6);
  static const primaryBlueDark = Color(0xFF2563EB);
  static const accentPurple = Color(0xFFA855F7);
  static const accentPink = Color(0xFFEC4899);
  static const successGreen = Color(0xFF22C55E);
  static const errorRed = Color(0xFFEF4444);
  static const warningYellow = Color(0xFFF59E0B);

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryBlue,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: Color(0xFF334155),
        surface: darkCard,
        error: errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkBackgroundAlt,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Color(0xFF6B7280),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: Color(0xFFD1D5DB), fontSize: 16),
        bodyMedium: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        bodySmall: TextStyle(color: Color(0xFF64748B), fontSize: 12),
        labelSmall: TextStyle(
          color: Color(0xFF64748B),
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCardAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Color(0xFF4B5563)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
      ),
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: primaryBlueDark,
      colorScheme: const ColorScheme.light(
        primary: primaryBlueDark,
        secondary: Color(0xFFE2E8F0),
        surface: lightCard,
        error: errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Color(0xFF0F172A)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightBackgroundAlt,
        selectedItemColor: primaryBlueDark,
        unselectedItemColor: Color(0xFF94A3B8),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: Color(0xFF334155), fontSize: 16),
        bodyMedium: TextStyle(color: Color(0xFF475569), fontSize: 14),
        bodySmall: TextStyle(color: Color(0xFF64748B), fontSize: 12),
        labelSmall: TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlueDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      cardTheme: CardThemeData(
        color: lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
      ),
    );
  }
}

/// Extension for theme-aware custom colors
extension ThemeColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get bgPrimary =>
      isDark ? AppTheme.darkBackground : AppTheme.lightBackground;
  Color get bgAlt =>
      isDark ? AppTheme.darkBackgroundAlt : AppTheme.lightBackgroundAlt;
  Color get cardColor => isDark ? AppTheme.darkCard : AppTheme.lightCard;
  Color get cardAlt => isDark ? AppTheme.darkCardAlt : AppTheme.lightCardAlt;
  Color get surfaceColor =>
      isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
  Color get borderColor => isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
  Color get textPrimary =>
      isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
  Color get textSecondary =>
      isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
  Color get textTertiary =>
      isDark ? AppTheme.darkTextTertiary : AppTheme.lightTextTertiary;
}
