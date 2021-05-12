import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:noor/exports/pages.dart' show RootHome;
import 'package:noor/exports/controllers.dart' show DataController;

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() async {
    await Future<void>.value(GetIt.I.allReady());
    await Future<void>.delayed(Duration(seconds: 1));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<RootHome>(
        builder: (_) => RootHome(),
      ),
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(microseconds: 800),
      child: Material(
        child: Center(
          child: AnimatedSwitcher(
            transitionBuilder: (Widget child, Animation<double> animation) => AnimatedOpacity(
              opacity: animation.value,
              duration: Duration(milliseconds: 100),
              child: child,
            ),
            child: Image.asset(
              'assets/NoorLogo.png',
              width: 150,
              key: ValueKey<String>('logo'),
            ),
            duration: Duration(milliseconds: 100),
          ),
        ),
      ),
    );
  }
}
