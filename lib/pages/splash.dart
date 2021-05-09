import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Material(
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
      
    );
  }
}
