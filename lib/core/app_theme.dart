import 'package:flutter/material.dart';

enum AppThemeType { sage, blueGray }

class AppTheme {
  static ThemeData getTheme(AppThemeType type) {
    switch (type) {
      case AppThemeType.sage:
        return _sageTheme;
      case AppThemeType.blueGray:
        return _blueGrayTheme;
    }
  }

  // 세이지 & 크림
  static final ThemeData _sageTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary:       Color(0xFF4A7A42), // 세이지그린 — 버튼, 포인트
      onPrimary:     Colors.white,
      secondary:     Color(0xFFC8A97A), // 골드베이지 — 서브 포인트
      onSecondary:   Colors.white,
      surface:       Color(0xFFFAF8F3), // 카드 배경
      onSurface:     Color(0xFF1E3018), // 본문 텍스트
      surfaceContainerHighest: Color(0xFFE8F0E4), // 메뉴 카드 배경
      outline:       Color(0xFFB8D4B0), // 구분선
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F7F2),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5F7F2),
      foregroundColor: Color(0xFF2E5228),
      elevation: 0,
    ),
    fontFamily: 'NanumGothic',
  );

  // 블루그레이 & 오프화이트
  static final ThemeData _blueGrayTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary:       Color(0xFF4A6E96), // 스틸블루 — 버튼, 포인트
      onPrimary:     Colors.white,
      secondary:     Color(0xFFB8A890), // 워밍그레이 — 서브 포인트
      onSecondary:   Colors.white,
      surface:       Color(0xFFFAFAF8), // 카드 배경
      onSurface:     Color(0xFF1A2A3A), // 본문 텍스트
      surfaceContainerHighest: Color(0xFFE2E8F2), // 메뉴 카드 배경
      outline:       Color(0xFFB8C8E0), // 구분선
    ),
    scaffoldBackgroundColor: const Color(0xFFF4F6F9),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF4F6F9),
      foregroundColor: Color(0xFF2E4A6E),
      elevation: 0,
    ),
    fontFamily: 'NanumGothic',
  );
}