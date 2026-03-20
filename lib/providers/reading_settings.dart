import 'package:flutter/foundation.dart';

class ReadingSettings extends ChangeNotifier {
  // ── 폰트 / 레이아웃 ───────────────────────────────
  double _fontSize   = 17.0;
  double _lineHeight = 1.9;

  // ── 표시 옵션 ────────────────────────────────────
  bool _showVerseNum = true;
  bool _showHighlight = true;

  // ── 번역본 / 언어 ────────────────────────────────
  String _translation = '개역개정';
  String _language    = '한국어';

  // getters
  double get fontSize      => _fontSize;
  double get lineHeight    => _lineHeight;
  bool   get showVerseNum  => _showVerseNum;
  bool   get showHighlight => _showHighlight;
  String get translation   => _translation;
  String get language      => _language;

  void setFontSize(double v) {
    if (_fontSize == v) return;
    _fontSize = v;
    notifyListeners();
  }

  void setLineHeight(double v) {
    if (_lineHeight == v) return;
    _lineHeight = v;
    notifyListeners();
  }

  void setShowVerseNum(bool v) {
    if (_showVerseNum == v) return;
    _showVerseNum = v;
    notifyListeners();
  }

  void setShowHighlight(bool v) {
    if (_showHighlight == v) return;
    _showHighlight = v;
    notifyListeners();
  }

  void setTranslation(String v) {
    if (_translation == v) return;
    _translation = v;
    notifyListeners();
  }

  void setLanguage(String v) {
    if (_language == v) return;
    _language = v;
    notifyListeners();
  }
}