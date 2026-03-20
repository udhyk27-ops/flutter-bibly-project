import 'package:flutter/foundation.dart';

class ReadingSettings extends ChangeNotifier {
  double _fontSize   = 17.0;
  double _lineHeight = 1.9;

  double get fontSize   => _fontSize;
  double get lineHeight => _lineHeight;

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
}