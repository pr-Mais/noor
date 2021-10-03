import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:noor/pages/tabs/3_counter/counter_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:noor/exports/pages.dart' show SplashScreen;
import 'package:noor/exports/models.dart' show DataModel, SettingsModel;
import 'package:noor/exports/components.dart' show CustomScrollBehavior;
import 'package:noor/exports/controllers.dart' show ThemeModel;
import 'package:noor/exports/constants.dart' show lightTheme, darkTheme;

class NoorApp extends StatelessWidget {
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
        ChangeNotifierProvider<SettingsModel>(
          create: (_) => GetIt.I<SettingsModel>(),
        ),
        ChangeNotifierProvider<CounterModel>.value(
          value: CounterModel.init(),
        ),
      ],
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeModel themeProvider = context.watch<ThemeModel>();

    return MaterialApp(
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: <Locale>[
        const Locale('ar'), // Arabic
      ],
      locale: Locale('ar'),
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
      home: SplashScreen(),
    );
  }
}
