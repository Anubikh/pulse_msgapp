import 'package:flutter/material.dart';
import 'package:minimsgapp_pantaleta/Themes/light_md.dart';

import 'dark_md.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lghtmode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == drkmode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lghtmode) {
      themeData = drkmode;
    } else {
      themeData = lghtmode;
    }
  }
}
