import 'package:flutter/material.dart';

import 'package:noor/exports/pages.dart' show RootHome;
import 'package:noor/exports/components.dart' show NoorLogo;
import 'package:noor/models/theme.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double logoOpacity = 0.0;
  @override
  void initState() {
    Future<void>.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        logoOpacity = 1.0;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    final images = Provider.of<ThemeModel>(context, listen: false).images;
    precacheImage(AssetImage(images.homeHeader), context);
    precacheImage(AssetImage(images.athkarCard), context);
    precacheImage(AssetImage(images.ad3yahCard), context);
    precacheImage(AssetImage(images.allahNamesCard), context);

    await Future<void>.delayed(const Duration(milliseconds: 800));
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
          duration: const Duration(milliseconds: 200),
          opacity: logoOpacity,
          child: const NoorLogo(size: 80),
        ),
      ),
    );
  }
}
