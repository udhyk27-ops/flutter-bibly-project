import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  AppThemeType _themeType = AppThemeType.sage;

  AppThemeType get themeType => _themeType;
  ThemeData get themeData => AppTheme.getTheme(_themeType);

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> setTheme(AppThemeType type) async {
    _themeType = type;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', type.name);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme');
    if (saved != null) {
      _themeType = AppThemeType.values.firstWhere(
            (e) => e.name == saved,
        orElse: () => AppThemeType.sage,
      );
      notifyListeners();
    }
  }
}