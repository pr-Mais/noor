import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noor/utils/to_color_filter.dart';

class AdaptiveIcon extends StatelessWidget {
  const AdaptiveIcon(this.icon, {Key? key}) : super(key: key);
  final String icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: SvgPicture.asset(
        icon,
        colorFilter: Theme.of(context).iconTheme.color.toColorFilter(),
      ),
    );
  }
}
