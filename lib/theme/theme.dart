import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noor/constants/colors.dart';
import 'package:noor/theme/custom_colors.dart';

const kContentFontSize = 16.0;
const viewPadding = 20.0;

ThemeData lightTheme() => ThemeData(
      brightness: Brightness.light,
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
      fontFamily: 'SST Arabic',
      primaryColor: Color(NoorColors.light.primary),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      unselectedWidgetColor: Colors.grey[300],
      canvasColor: Colors.white,
      dividerColor: Colors.grey[300],
      dialogTheme: const DialogTheme(backgroundColor: Colors.white),
      highlightColor: Colors.black.withOpacity(0.1),
      splashColor: Colors.black.withOpacity(0.1),
      textTheme: TextTheme(
        bodyLarge: const TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        titleMedium: const TextStyle(
          color: Color(0xff6f85d5),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.lightBlue[100],
          fontWeight: FontWeight.bold,
        ),
        displayLarge: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Color(0xff6f85d5),
          fontWeight: FontWeight.bold,
        ),
        displayMedium: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.white,
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          color: Color(0xff6f85d5),
          height: 1,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all<double>(0.0),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return const Color(0xff6f85d5).withOpacity(0.7);
              }
              return const Color(0xff6f85d5);
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              return (states.contains(WidgetState.disabled))
                  ? Colors.white30
                  : Colors.lightBlue[100];
            },
          ),
          textStyle: WidgetStateProperty.all<TextStyle>(
            const TextStyle(
              fontFamily: 'SST Arabic',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1,
            ),
          ),
          overlayColor: WidgetStateProperty.all<Color>(Colors.white24),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        radius: const Radius.circular(5),
        thumbColor: WidgetStateProperty.all(Colors.grey[300]),
      ),
      iconTheme: IconThemeData(color: Colors.grey[400], size: 30),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey[300],
        filled: true,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      cardColor: Colors.grey[200],
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color(0xff6f85d5),
        brightness: Brightness.light,
        outline: const Color(0xff6f85d5),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        CustomColors(
          selectedRowColor: Color(0xffB3B3FF),
        ),
      ],
    );

ThemeData darkTheme() => ThemeData(
      brightness: Brightness.dark,
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
      fontFamily: 'SST Arabic',
      primaryColor: Color(NoorColors.dark.primary),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      canvasColor: const Color(0xff10122C),
      dividerColor: const Color(0xff3C387B),
      iconTheme: const IconThemeData(color: Color(0xff3C387B), size: 30),
      unselectedWidgetColor: Colors.grey[300],
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Colors.white24,
        filled: true,
        hintStyle: TextStyle(color: Colors.white38),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
        titleMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Color(0xff6f85d5),
          fontWeight: FontWeight.bold,
        ),
        displayLarge: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.white,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          color: Color(0xff6f85d5),
          height: 1,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all<double>(0.0),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return const Color(0xff6f85d5).withOpacity(0.6);
              }
              return const Color(0xff6f85d5);
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              return (states.contains(WidgetState.disabled))
                  ? Colors.white30
                  : Colors.lightBlue[100];
            },
          ),
          textStyle: WidgetStateProperty.all<TextStyle>(
            const TextStyle(
              fontFamily: 'SST Arabic',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1,
            ),
          ),
          overlayColor: WidgetStateProperty.all<Color>(Colors.white10),
        ),
      ),
      splashColor: Colors.black.withOpacity(0.1),
      highlightColor: const Color(0xff3C387B).withOpacity(0.5),
      dialogTheme: const DialogTheme(backgroundColor: Color(0xff1B2349)),
      cardColor: const Color(0xff10122C),
      scrollbarTheme: ScrollbarThemeData(
        radius: const Radius.circular(5),
        thumbColor: WidgetStateProperty.all(
          const Color(0xff3C387B).withOpacity(0.5),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.white,
        brightness: Brightness.dark,
        outline: const Color(0xff6f85d5),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        CustomColors(
          selectedRowColor: Color(0xff33477F),
        ),
      ],
    );
