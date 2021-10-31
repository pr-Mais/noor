import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:noor/exports/pages.dart' show RootHome;
import 'package:noor/exports/components.dart' show NoorLogo;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double logoOpacity = 0.0;
  @override
  void initState() {
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        logoOpacity = 1.0;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    await Future<void>.value(GetIt.I.allReady());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<RootHome>(
        builder: (_) => const RootHome(),
      ),
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: logoOpacity,
          child: const NoorLogo(size: 80),
        ),
      ),
    );
  }
}
