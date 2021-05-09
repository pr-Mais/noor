import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:noor/components/custom_scroll_bhaviour.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:noor/providers/data_provider.dart';
import 'package:noor/providers/settings_provider.dart';
import 'package:noor/providers/theme_provider.dart';
import 'package:noor/pages/root.dart';
import 'package:noor/pages/splash.dart';

class NoorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: GetIt.I.allReady(),
      builder: (_, snapshot) {
        return AnimatedSwitcher(
          duration: Duration(microseconds: 800),
          child: snapshot.hasData
              ? MultiProvider(
                  providers: <SingleChildWidget>[
                    ChangeNotifierProvider<ThemeProvider>.value(
                      value: ThemeProvider(),
                    ),
                    FutureProvider<DataProvider>(
                      initialData: null,
                      create: (_) => DataProvider.init(),
                    ),
                    ChangeNotifierProvider<DataProvider>(
                      create: (_) => GetIt.I<DataProvider>(),
                    ),
                    ChangeNotifierProvider<SettingsProvider>(
                      create: (_) => SettingsProvider(),
                    ),
                  ],
                  child: MaterialAppWithTheme(),
                )
              : SplashScreen(),
        );
      },
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider providerTheme = context.watch<ThemeProvider>();

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
      themeMode: providerTheme.theme,
      theme: lightTheme,
      darkTheme: darkTheme,
      builder: (BuildContext context, Widget child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaleFactor: 1.0),
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: child,
          ),
        );
      },
      home: RootHome(),
    );
  }
}
