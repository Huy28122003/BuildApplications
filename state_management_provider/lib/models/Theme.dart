
import 'package:flutter/material.dart';
class ThemeProvider extends ChangeNotifier {
  bool _isDark = true;

  bool get isDark => _isDark;

  setBrightness(bool value){
    _isDark = value;
    notifyListeners();
  }
}