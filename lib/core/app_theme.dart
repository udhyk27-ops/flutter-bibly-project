import 'package:flutter/material.dart';

enum AppThemeType { sage, blueGray, parchment }

class AppTheme {
  static ThemeData getTheme(AppThemeType type) {
    switch (type) {
      case AppThemeType.sage:      return _sageTheme;
      case AppThemeType.blueGray:  return _blueGrayTheme;
      case AppThemeType.parchment: return _parchmentTheme;
    }
  }

  // ── 공통 텍스트 테마 ─────────────────────────────────
  static TextTheme _textTheme(Color primary, Color secondary) {
    return TextTheme(
      headlineLarge: TextStyle(
          fontSize: 26, fontWeight: FontWeight.w700, color: primary),
      headlineMedium: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w600, color: primary),
      headlineSmall: TextStyle(
          fontSize: 19, fontWeight: FontWeight.w600, color: primary),
      titleLarge: TextStyle(
          fontSize: 17, fontWeight: FontWeight.w600, color: primary),
      titleMedium: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w500, color: primary),
      titleSmall: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, color: primary),
      bodyLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: primary,
          height: 1.7),
      bodyMedium: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w400, color: primary,
          height: 1.7),
      bodySmall: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w400, color: secondary,
          height: 1.6),
      labelLarge: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, color: primary),
      labelMedium: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w500, color: secondary),
      labelSmall: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w400, color: secondary),
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
    textTheme: _textTheme(
      const Color(0xFF1A2418),
      const Color(0xFF5A7A52),
    ),
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
    textTheme: _textTheme(
      const Color(0xFF0F1E2E),
      const Color(0xFF4A6A8A),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF4F6F9),
      foregroundColor: Color(0xFF1E3A5F),
      elevation: 0,
    ),
  );

  // ── 양피지 & 세피아 (성경책) ───────────────────────────
  static final ThemeData _parchmentTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary:                 Color(0xFF7B1D1D), // 버건디 — 강조/절 번호
      onPrimary:               Color(0xFFFAF0DC), // 크림 위 텍스트
      secondary:               Color(0xFF7A5C3A), // 갈색 서브텍스트
      onSecondary:             Color(0xFFFAF0DC),
      surface:                 Color(0xFFF5EFE0), // 종이 크림
      onSurface:               Color(0xFF2C1A0E), // 잉크 다크
      surfaceContainerHighest: Color(0xFFEDE4CC), // 카드/선택 배경
      outline:                 Color(0xFFA0804A), // 금빛 테두리
    ),
    scaffoldBackgroundColor: const Color(0xFFF5EFE0),
    textTheme: _textTheme(
      const Color(0xFF2C1A0E), // inkDark
      const Color(0xFF7A5C3A), // dustyBrown
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5EFE0),
      foregroundColor: Color(0xFF7B1D1D),
      elevation: 0,
    ),
  );
}