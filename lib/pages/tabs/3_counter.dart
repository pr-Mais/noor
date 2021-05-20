import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:noor/exports/components.dart' show NoorIcons;
import 'package:noor/exports/services.dart' show SharedPrefsService;
import 'package:noor/exports/utils.dart' show ToArabicNumbers;
import 'package:noor/exports/controllers.dart' show SettingsModel;

class CounterPage extends StatefulWidget {
  const CounterPage({Key? key}) : super(key: key);
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counter = SharedPrefsService.getInt('counter');

  void incrementCounter() {
    final SettingsModel settings = context.read<SettingsModel>();

    setState(() {
      counter++;
    });

    SharedPrefsService.putInt('counter', counter);

    if (settings.vibrateCounter) {
      if (counter % 100 == 0) {
        switch (settings.vibrationHunderds) {
          case 'strong':
            HapticFeedback.lightImpact();
            break;
          case 'light':
            HapticFeedback.heavyImpact();
            break;
          case 'none':
            break;
          default:
            HapticFeedback.lightImpact();
        }
      } else {
        switch (settings.vibrationClickCounter) {
          case 'strong':
            HapticFeedback.lightImpact();
            break;
          case 'light':
            HapticFeedback.heavyImpact();
            break;
          case 'none':
            break;
          default:
            HapticFeedback.lightImpact();
        }
      }
    }
  }

  void resetCounter() {
    setState(() {
      counter = 0;
    });
    SharedPrefsService.putInt('counter', counter);
  }

  LinearGradient lightModeBG = LinearGradient(
    colors: <Color>[
      Color(0xff5554B0),
      Color(0xff6F86D6),
    ],
    stops: <double>[0.1, 0.9],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  );

  LinearGradient darkModeBG = LinearGradient(
    colors: <Color>[
      Color(0xff161A3A),
      Color(0xff161A3A),
    ],
    stops: <double>[0.7, 0.3],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: incrementCounter,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: Theme.of(context).brightness == Brightness.dark
                  ? darkModeBG
                  : lightModeBG),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: Icon(
                    NoorIcons.erase_counter,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: resetCounter,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(child: child, opacity: animation);
                  },
                  duration: Duration(milliseconds: 250),
                  child: Text(
                    '$counter'.arabicDigit(),
                    key: ValueKey<int>(counter),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
