import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noor/exports/components.dart'
    show SettingsTitle, VerticalSpace, SwitcherOption;
import 'package:noor/exports/constants.dart' show NoorIcons;
import 'package:noor/exports/controllers.dart' show SettingsModel;
import 'package:provider/provider.dart';

class SettingsCounter extends StatelessWidget {
  const SettingsCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsModel settings = context.watch<SettingsModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SettingsTitle(text: 'العداد'),
        const Divider(),
        SwitcherOption(
          icon: NoorIcons.jump,
          title: 'الانتقال التلقائي إلى الذكر التالي',
          value: settings.autoJump,
          onChanged: (value) => settings.autoJump = value,
        ),
        const Divider(),
        VerticalSpace(),
        SettingsTitle(text: 'إظهار العداد'),
        const Divider(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          alignment: Alignment.center,
          child: CupertinoSlidingSegmentedControl<int>(
            padding: EdgeInsets.all(3),
            thumbColor: Theme.of(context).primaryColor,
            children: <int, Widget>{
              0: Text(
                'للأذكار ذات تكرار أكثر من مرة',
                style: TextStyle(
                  color: !settings.showCounter ? Colors.white : Colors.grey,
                  fontSize: 11,
                ),
              ),
              1: Text(
                'لكل الأذكار',
                style: TextStyle(
                  color: settings.showCounter ? Colors.white : Colors.grey,
                  fontSize: 11,
                ),
              )
            },
            groupValue: settings.showCounter ? 1 : 0,
            onValueChanged: (dynamic value) =>
                settings.showCounter = value == 1,
          ),
        ),
        const Divider(),
        VerticalSpace(),
      ],
    );
  }
}
