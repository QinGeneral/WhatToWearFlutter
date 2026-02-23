import 'package:flutter/material.dart';

/// AppColors defines the semantic color palette for the entire application.
/// It separates colors into Light, Dark, and Shared categories.
class AppColors {
  // ═══════ Shared Colors ═══════
  static const primaryBlue = Color(0xFF3B82F6);
  static const primaryBlueDark = Color(0xFF2563EB);
  static const accentPurple = Color(0xFFA855F7);
  static const accentPink = Color(0xFFEC4899);
  static const successGreen = Color(0xFF22C55E);
  static const errorRed = Color(0xFFEF4444);
  static const warningYellow = Color(0xFFF59E0B);
  static const accentTeal = Color(0xFF14B8A6);

  // ═══════ Weather Colors ═══════
  static const weatherSunnyStart = Color(0xFF87CEEB);
  static const weatherSunnyEnd = Color(0xFF4A90D9);

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
  static const lightBorder = Color(0xFFE2E8F0); // slate-200
  static const lightTextPrimary = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF475569);
  static const lightTextTertiary = Color(0xFF64748B);
  static const lightTextQuaternary = Color(0xFF94A3B8);
}
