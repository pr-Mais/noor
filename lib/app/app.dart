import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:noor/exports/pages.dart' show SplashScreen;
import 'package:noor/exports/models.dart'
    show DataModel, AppSettings, CounterViewModel;
import 'package:noor/exports/components.dart' show CustomScrollBehavior;
import 'package:noor/exports/controllers.dart' show ThemeModel;
import 'package:noor/exports/constants.dart' show lightTheme, darkTheme;

class NoorApp extends StatelessWidget {
  const NoorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<ThemeModel>.value(
          value: ThemeModel(),
        ),
        ChangeNotifierProvider<DataModel>.value(
          value: GetIt.I<DataModel>(),
        ),
        ChangeNotifierProvider<AppSettings>(
          create: (_) => GetIt.I<AppSettings>(),
        ),
        ChangeNotifierProvider<CounterViewModel>(
          create: (_) => GetIt.I<CounterViewModel>(),
        ),
      ],
      child: const MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeModel themeProvider = context.watch<ThemeModel>();

    return MaterialApp(
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('ar'), // Arabic
      ],
      locale: const Locale('ar'),
      debugShowCheckedModeBanner: false,
      title: 'نُور',
      themeMode: themeProvider.theme,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaleFactor: 1.0),
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: child!,
          ),
        );
      },
      home: const SplashScreen(),
    );
  }
}
