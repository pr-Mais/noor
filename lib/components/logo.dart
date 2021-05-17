import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noor/exports/controllers.dart' show ThemeProvider;
import 'package:provider/provider.dart';

class NoorLogo extends StatelessWidget {
  const NoorLogo(this.size);
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(size, size),
      child: SvgPicture.asset(
        context.watch<ThemeProvider>().images.logo,
      ),
    );
  }
}
