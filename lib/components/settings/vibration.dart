import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noor/exports/components.dart'
    show
        SettingsTitle,
        SettingsSubtitle,
        SwitcherOption,
        SegmentedControlOption,
        VerticalSpace;
import 'package:noor/exports/constants.dart' show NoorIcons;
import 'package:noor/exports/controllers.dart' show SettingsModel;
import 'package:provider/provider.dart';

class Vibration extends StatelessWidget {
  const Vibration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsModel settings = context.watch<SettingsModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SettingsTitle(text: 'الهزاز'),
        const Divider(),
        SwitcherOption(
          icon: NoorIcons.vibrate,
          title: 'الهزاز لعداد صفحة الأذكار',
          value: settings.vibrate,
          onChanged: (bool value) => settings.vibrate = value,
        ),
        const Divider(),
        AnimatedCrossFade(
          firstChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SettingsSubtitle(
                  text: 'نوع الهزاز لصفحة الأذكار',
                ),
              ),
              VerticalSpace(),
              SegmentedControlOption(
                icon: NoorIcons.click,
                title: 'لكل ضغطة',
                value: settings.vibrationClick,
                onChanged: (String? value) {
                  settings.vibrationClick = value!;
                  if (value == 'strong') {
                    HapticFeedback.lightImpact();
                  }
                  if (value == 'light') {
                    HapticFeedback.heavyImpact();
                  }
                },
              ),
              VerticalSpace(),
              SegmentedControlOption(
                icon: NoorIcons.done,
                title: 'عند اكتمال العد',
                value: settings.vibrationDone,
                onChanged: (String? value) {
                  settings.vibrationDone = value!;
                  if (value == 'strong') {
                    HapticFeedback.lightImpact();
                  }
                  if (value == 'light') {
                    HapticFeedback.heavyImpact();
                  }
                },
              ),
              VerticalSpace(),
              Divider(),
            ],
          ),
          secondChild: Container(),
          crossFadeState: settings.vibrate
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 300),
        ),
        SwitcherOption(
          icon: NoorIcons.vibrate,
          title: 'الهزاز لصفحة السبحة',
          value: settings.vibrateCounter,
          onChanged: (bool value) => settings.vibrateCounter = value,
        ),
        Divider(),
        AnimatedCrossFade(
          firstChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SettingsSubtitle(
                  text: 'نوع الهزاز لصفحة السبحة',
                ),
              ),
              VerticalSpace(),
              SegmentedControlOption(
                  icon: NoorIcons.click,
                  title: 'لكل ضغطة',
                  value: settings.vibrationClickCounter,
                  onChanged: (String? value) {
                    settings.vibrationClickCounter = value!;
                    if (value == 'strong') {
                      HapticFeedback.lightImpact();
                    }
                    if (value == 'light') {
                      HapticFeedback.heavyImpact();
                    }
                  }),
              VerticalSpace(),
              SegmentedControlOption(
                icon: NoorIcons.done,
                title: 'عند مضاعفات المئة',
                value: settings.vibrationHunderds,
                onChanged: (String? value) {
                  settings.vibrationHunderds = value!;
                  if (value == 'strong') {
                    HapticFeedback.lightImpact();
                  }
                  if (value == 'light') {
                    HapticFeedback.heavyImpact();
                  }
                },
              ),
              VerticalSpace(),
              Divider(),
              VerticalSpace(),
            ],
          ),
          secondChild: Container(),
          crossFadeState: settings.vibrateCounter
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
