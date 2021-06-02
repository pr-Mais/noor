import 'package:flutter/material.dart';
import 'package:noor/exports/components.dart' show SubtitleWithIcon;
import 'package:noor/exports/controllers.dart' show SettingsModel;
import 'package:provider/provider.dart';

class RadioBtn extends StatelessWidget {
  const RadioBtn({
    Key? key,
    required this.title,
    required this.icon,
    required this.value,
    this.changeTheme,
  }) : super(key: key);

  final String title;
  final String icon;
  final String value;
  final void Function(String?)? changeTheme;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      contentPadding: EdgeInsets.only(right: 0, left: 20),
      dense: false,
      child: RadioListTile<String>(
        controlAffinity: ListTileControlAffinity.trailing,
        title: SubtitleWithIcon(text: title, icon: icon),
        activeColor: Theme.of(context).primaryColor,
        groupValue: context.watch<SettingsModel>().theme,
        value: value,
        onChanged: changeTheme,
      ),
    );
  }
}
