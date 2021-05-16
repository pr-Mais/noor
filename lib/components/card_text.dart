import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:noor/exports/utils.dart' show Tashkeel;
import 'package:noor/exports/controllers.dart' show SettingsModel;

class CardText extends StatelessWidget {
  const CardText({Key? key, required this.text, this.color}) : super(key: key);
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final SettingsModel settings = context.watch();

    return Text(
      settings.tashkeel ? text : Tashkeel.remove(text),
      textScaleFactor: settings.fontSize,
      style: color != null
          ? Theme.of(context).textTheme.bodyText1?.copyWith(color: color)
          : Theme.of(context).textTheme.bodyText1,
    );
  }
}
