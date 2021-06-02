import 'package:flutter/material.dart';
import 'package:noor/exports/components.dart'
    show SettingsTitle, RadioBtn, VerticalSpace;
import 'package:noor/exports/constants.dart' show NoorIcons;

class Appearance extends StatelessWidget {
  const Appearance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SettingsTitle(text: 'المظهر'),
        Divider(),
        RadioBtn(
          icon: NoorIcons.lightMode,
          title: 'الوضع النهاري',
          value: 'light_theme',
        ),
        Divider(),
        RadioBtn(
          icon: NoorIcons.darkMode,
          title: 'الوضع الليلي',
          value: 'dark_theme',
        ),
        Divider(),
        RadioBtn(
          icon: NoorIcons.systemMode,
          title: 'وضع النظام',
          value: 'system_theme',
        ),
        VerticalSpace(),
        const Divider(),
      ],
    );
  }
}
