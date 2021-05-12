import 'package:flutter/material.dart';
import 'package:noor/exports/constants.dart' show Images;
import 'package:noor/exports/services.dart' show SharedPrefsUtil;

class ThemeProvider with ChangeNotifier {
  String _userTheme = SharedPrefsUtil.getString('theme');

  get userTheme => _userTheme;
  set userTheme(value) {
    _userTheme = value;
    notifyListeners();
  }

  get theme {
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

  get brightness => MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness;

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

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'SST Roman',
    primaryColor: Color(0xff6db7e5),
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    }),
    unselectedWidgetColor: Colors.grey[300],
    canvasColor: Colors.white,
    dividerColor: Colors.grey[300],
    accentColor: Color(0xff6f85d5),
    dialogTheme: DialogTheme(backgroundColor: Colors.white),
    highlightColor: Colors.black.withOpacity(0.1),
    splashColor: Colors.black.withOpacity(0.1),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        fontSize: 16,
        height: 1.8,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      subtitle1: TextStyle(
        color: Colors.black87,
        fontSize: 13,
      ),
      headline1: TextStyle(
        fontSize: 16,
        height: 1.8,
        color: Color(0xff6f85d5),
        fontWeight: FontWeight.bold,
      ),
    ),
    scrollbarTheme: ScrollbarThemeData(radius: Radius.circular(5)),
    iconTheme: IconThemeData(color: Colors.grey[400], size: 30),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey[300],
      filled: true,
      hintStyle: TextStyle(color: Colors.grey),
    ),
    buttonColor: Color(0xff6f85d5),
    cardColor: Colors.grey[200]);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SST',
  primaryColor: Color(0xff6db7e5),
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
  }),
  canvasColor: Color(0xff10122C),
  dividerColor: Color(0xff3C387B),
  iconTheme: IconThemeData(color: Color(0xff3C387B), size: 30),
  unselectedWidgetColor: Colors.grey[300],
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.white24,
    filled: true,
    hintStyle: TextStyle(color: Colors.white38),
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
      fontSize: 16,
      height: 1.8,
      color: Colors.white,
      fontWeight: FontWeight.normal,
    ),
    subtitle1: TextStyle(
      color: Colors.white,
      fontSize: 13,
    ),
    headline1: TextStyle(
      fontSize: 16,
      height: 1.8,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  accentColor: Colors.white,
  buttonColor: Color(0xff6f85d5),
  splashColor: Colors.black.withOpacity(0.1),
  highlightColor: Color(0xff3C387B).withOpacity(0.5),
  dialogTheme: DialogTheme(backgroundColor: Color(0xff1B2349)),
  cardColor: Color(0xff10122C),
  scrollbarTheme: ScrollbarThemeData(radius: Radius.circular(5)),
);
