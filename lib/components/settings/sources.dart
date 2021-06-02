import 'package:flutter/material.dart';
import 'package:noor/exports/components.dart'
    show SettingsTitle, SubtitleWithIcon, VerticalSpace;
import 'package:noor/exports/constants.dart' show Links, NoorIcons;
import 'package:url_launcher/url_launcher.dart';

class Sources extends StatelessWidget {
  const Sources({Key? key}) : super(key: key);

  void launchURL(String url) async {
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        VerticalSpace(),
        SettingsTitle(text: 'المصادر'),
        const Divider(),
        InkWell(
          onTap: () => launchURL(Links.allahNamesResource),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: MediaQuery.of(context).size.width,
            child: SubtitleWithIcon(
              text: 'قسم أسماء الله الحُسنى',
              icon: NoorIcons.allahNames,
            ),
          ),
        ),
        const Divider(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          width: MediaQuery.of(context).size.width,
          child: SubtitleWithIcon(
            text: 'قسم الرقية الشرعية، كُتيب أَوراد',
            icon: NoorIcons.ruqiya,
          ),
        ),
        const Divider(),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
