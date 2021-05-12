import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:noor/exports/pages.dart' show RootHome;

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double logoOpacity = 0.0;
  @override
  void initState() {
    Future<void>.delayed(Duration(milliseconds: 300), () {
      setState(() {
        logoOpacity = 1.0;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    await Future<void>.value(GetIt.I.allReady());
    await Future<void>.delayed(Duration(milliseconds: 500));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<RootHome>(
        builder: (_) => RootHome(),
      ),
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: logoOpacity,
          child: Image.asset(
            'assets/NoorLogo.png',
            width: 150,
          ),
        ),
      ),
    );
  }
}
