import 'package:flutter/material.dart';

enum AppThemeType { sage, blueGray, parchment, softDark }

class AppTheme {
  static ThemeData getTheme(AppThemeType type) {
    switch (type) {
      case AppThemeType.sage:      return _sageTheme;
      case AppThemeType.blueGray:  return _blueGrayTheme;
      case AppThemeType.parchment: return _parchmentTheme;
      case AppThemeType.softDark:  return _softDarkTheme;
    }
  }

  // ── 공통 텍스트 테마 ─────────────────────────────────
  static TextTheme _textTheme(Color primary, Color secondary) {
    return TextTheme(
      headlineLarge:  TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: primary),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: primary),
      headlineSmall:  TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: primary),
      titleLarge:     TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: primary),
      titleMedium:    TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: primary),
      titleSmall:     TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: primary),
      bodyLarge:      TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primary, height: 1.7),
      bodyMedium:     TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: primary, height: 1.7),
      bodySmall:      TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: secondary, height: 1.6),
      labelLarge:     TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: primary),
      labelMedium:    TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: secondary),
      labelSmall:     TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: secondary),
    );
  }

  // ── 세이지 & 크림 ─────────────────────────────────────
  static final ThemeData _sageTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary:                 Color(0xFF2E5228),
      onPrimary:               Colors.white,
      secondary:               Color(0xFF5A7A52),
      onSecondary:             Colors.white,
      surface:                 Color(0xFFFAF8F3),
      onSurface:               Color(0xFF1A2418),
      surfaceContainerHighest: Color(0xFFE8F0E4),
      outline:                 Color(0xFFB8D4B0),
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F7F2),
    textTheme: _textTheme(const Color(0xFF1A2418), const Color(0xFF5A7A52)),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5F7F2),
      foregroundColor: Color(0xFF2E5228),
      elevation: 0,
    ),
  );

  // ── 블루그레이 & 오프화이트 ───────────────────────────
  static final ThemeData _blueGrayTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary:                 Color(0xFF1E3A5F),
      onPrimary:               Colors.white,
      secondary:               Color(0xFF4A6A8A),
      onSecondary:             Colors.white,
      surface:                 Color(0xFFFAFAF8),
      onSurface:               Color(0xFF0F1E2E),
      surfaceContainerHighest: Color(0xFFE2E8F2),
      outline:                 Color(0xFFB8C8E0),
    ),
    scaffoldBackgroundColor: const Color(0xFFF4F6F9),
    textTheme: _textTheme(const Color(0xFF0F1E2E), const Color(0xFF4A6A8A)),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF4F6F9),
      foregroundColor: Color(0xFF1E3A5F),
      elevation: 0,
    ),
  );

  // ── 양피지 & 세피아 ───────────────────────────────────
  static final ThemeData _parchmentTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary:                 Color(0xFF7B1D1D),
      onPrimary:               Color(0xFFFAF0DC),
      secondary:               Color(0xFF7A5C3A),
      onSecondary:             Color(0xFFFAF0DC),
      surface:                 Color(0xFFF5EFE0),
      onSurface:               Color(0xFF2C1A0E),
      surfaceContainerHighest: Color(0xFFEDE4CC),
      outline:                 Color(0xFFA0804A),
    ),
    scaffoldBackgroundColor: const Color(0xFFF5EFE0),
    textTheme: _textTheme(const Color(0xFF2C1A0E), const Color(0xFF7A5C3A)),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5EFE0),
      foregroundColor: Color(0xFF7B1D1D),
      elevation: 0,
    ),
  );

  // ── 소프트 다크 ───────────────────────────────────────
  static final ThemeData _softDarkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary:                 Color(0xFFA8C5A0), // 소프트 세이지
      onPrimary:               Color(0xFF1A2818),
      secondary:               Color(0xFF8A9E86),
      onSecondary:             Color(0xFF1A2818),
      surface:                 Color(0xFF272727),
      onSurface:               Color(0xFFE8E8E8),
      surfaceContainerHighest: Color(0xFF313131),
      outline:                 Color(0xFF3E3E3E),
    ),
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    textTheme: _textTheme(const Color(0xFFE8E8E8), const Color(0xFF8A9E86)),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Color(0xFFA8C5A0),
      elevation: 0,
    ),
  );
}