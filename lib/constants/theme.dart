import 'package:flutter/material.dart';

const double kContentFontSize = 16.0;

ThemeData lightTheme() => ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(brightness: Brightness.light),
    fontFamily: 'SST Arabic',
    primaryColor: Color(0xff6db7e5),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
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
        height: 1.6,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      subtitle1: TextStyle(
        color: Colors.black87,
        fontSize: 13,
      ),
      headline1: TextStyle(
        fontSize: 16,
        height: 1.5,
        color: Color(0xff6f85d5),
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        fontSize: 16,
        height: 1.5,
        color: Colors.white,
      ),
      button: TextStyle(
        fontSize: 14,
        color: Color(0xff6f85d5),
        height: 1,
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

ThemeData darkTheme() => ThemeData(
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(brightness: Brightness.dark),
      fontFamily: 'SST Arabic',
      primaryColor: Color(0xff6db7e5),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
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
          height: 1.6,
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
        subtitle1: TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),
        headline1: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headline2: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.white,
        ),
        button: TextStyle(
          fontSize: 14,
          color: Color(0xff6f85d5),
          height: 1,
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
