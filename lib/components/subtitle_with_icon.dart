import 'package:flutter/material.dart';
import 'package:noor/exports/components.dart' show AdaptiveIcon;

class SubtitleWithIcon extends StatelessWidget {
  const SubtitleWithIcon({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);
  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AdaptiveIcon(icon),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  height: 1,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }
}
