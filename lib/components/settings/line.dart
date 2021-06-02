import 'package:flutter/material.dart';
import 'package:noor/exports/components.dart'
    show
        SettingsTitle,
        VerticalSpace,
        SwitcherOption,
        NoorCard,
        AnimatedSizeText,
        FontTypeButton,
        SubtitleWithIcon;
import 'package:noor/exports/constants.dart' show NoorIcons;
import 'package:noor/exports/controllers.dart' show SettingsModel;
import 'package:provider/provider.dart';

class LineSettings extends StatelessWidget {
  const LineSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsModel settings = context.watch<SettingsModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SettingsTitle(text: 'الخط'),
        const Divider(),
        NoorCard(),
        const Divider(),
        SubtitleWithIcon(
          text: 'حجم الخط',
          icon: NoorIcons.fontSize,
        ),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10.0),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List<Widget>.from(
                      <Widget>[
                        AnimatedSizeText(index: 0, size: 16),
                        AnimatedSizeText(index: 1, size: 18),
                        AnimatedSizeText(index: 2, size: 20),
                        AnimatedSizeText(index: 3, size: 22)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Theme.of(context).primaryColor,
                      thumbColor: Theme.of(context).primaryColor,
                      inactiveTrackColor: Colors.grey[400],
                      trackHeight: 2,
                      inactiveTickMarkColor: Theme.of(context).primaryColor,
                      activeTickMarkColor: Colors.grey[400],
                    ),
                    child: Slider(
                      divisions: 3,
                      onChanged: (double value) => settings.fontSize = value,
                      value: settings.fontSize,
                      min: 1,
                      max: 1.375,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
        SubtitleWithIcon(
          text: 'نوع الخط',
          icon: NoorIcons.fontType,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FontTypeButton(font: 'SST Arabic'),
              FontTypeButton(font: 'Dubai'),
              FontTypeButton(font: 'Geeza'),
            ],
          ),
        ),
        const Divider(),
        SwitcherOption(
          icon: NoorIcons.tashkeel,
          title: 'التشكيل',
          value: settings.tashkeel,
          onChanged: (bool value) => settings.tashkeel = value,
        ),
        const Divider(),
        VerticalSpace(),
      ],
    );
  }
}
