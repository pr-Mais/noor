import 'package:flutter/material.dart';
import 'package:noor/exports/constants.dart' show Images;
import 'package:noor/exports/services.dart' show SharedPrefsUtil;

class ThemeProvider with ChangeNotifier {
  String _userTheme = SharedPrefsUtil.getString('theme');

  String get userTheme => _userTheme;
  get brightness => MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness;

  set userTheme(String value) {
    _userTheme = value;
    notifyListeners();
  }

  ThemeMode get theme {
    switch (userTheme) {
      case 'dark_theme':
        return ThemeMode.dark;
        break;
      case 'light_theme':
        return ThemeMode.light;
        break;
      default:
        return ThemeMode.system;
    }
  }

  Images get images {
    switch (userTheme) {
      case 'dark_theme':
        return Images.dark;
        break;
      case 'light_theme':
        return Images.light;
        break;
      default:
        {
          switch (brightness) {
            case Brightness.dark:
              return Images.dark;
              break;
            default:
              return Images.light;
          }
        }
    }
  }
}
