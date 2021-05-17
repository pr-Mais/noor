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

    return Align(
      alignment: Alignment.centerRight,
      child: DefaultTextStyle.merge(
        textAlign: TextAlign.justify,
        style: color != null
            ? Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: color,
                  fontFamily: settings.fontType,
                )
            : Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontFamily: settings.fontType,
                ),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: Text(
            settings.tashkeel ? text : Tashkeel.remove(text),
            key: ValueKey<bool>(settings.tashkeel),
            textScaleFactor: settings.fontSize,
          ),
        ),
      ),
    );
  }
}
