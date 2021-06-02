import 'package:flutter/material.dart';
import 'package:noor/exports/components.dart' show SubtitleWithIcon;

class SwitcherOption extends StatelessWidget {
  const SwitcherOption(
      {Key? key,
      required this.icon,
      required this.title,
      required this.onChanged,
      required this.value,
      this.image})
      : super(key: key);

  final String icon;
  final String title;
  final Function(bool) onChanged;
  final bool value;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SubtitleWithIcon(text: title, icon: icon),
        Container(
          margin: EdgeInsets.only(left: 20.0),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Switch(
              value: value,
              activeColor: Theme.of(context).primaryColor,
              onChanged: onChanged,
            ),
          ),
        )
      ],
    );
  }
}
