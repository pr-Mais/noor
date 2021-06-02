import 'package:flutter/material.dart';
import 'package:noor/exports/controllers.dart' show SettingsModel;
import 'package:provider/provider.dart';

class FontTypeButton extends StatelessWidget {
  const FontTypeButton({Key? key, required this.font}) : super(key: key);

  final String font;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => context.read<SettingsModel>().fontType = font,
      child: AnimatedDefaultTextStyle(
        child: Text('الحمدلله'),
        duration: Duration(milliseconds: 200),
        style: TextStyle(
          fontFamily: font,
          color: context.read<SettingsModel>().fontType == font
              ? Theme.of(context).primaryColor
              : Colors.grey[400],
          height: 1,
          fontSize: context.read<SettingsModel>().fontType == font ? 20 : 16,
        ),
      ),
    );
  }
}
