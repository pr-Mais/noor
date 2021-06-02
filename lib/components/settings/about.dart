import 'package:flutter/material.dart';
import 'package:noor/exports/components.dart'
    show SettingsTitle, SubtitleWithIcon;
import 'package:noor/exports/constants.dart' show Links, NoorIcons, Images;
import 'package:noor/exports/controllers.dart' show ThemeModel;
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  void launchURL(String url) async {
    await launch(url);
  }

  void share() {
    Share.share(
        'يضمُّ تطبيق نُور العديد من الأذكار والأدعية الواردة في كتاب حصن المسلم. كما يحتوي التطبيق على أدعية من القرآن الكريم والسنة النبوية. والعديد من المميزات. \n https://play.google.com/store/apps/details?id=com.noor.sa',
        subject: 'تطبيق نُور');
  }

  @override
  Widget build(BuildContext context) {
    final Images images = Provider.of<ThemeModel>(context).images;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SettingsTitle(text: 'عن التطبيق'),
        const Divider(),
        InkWell(
          onTap: () => launchURL(Links.appURL),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: MediaQuery.of(context).size.width,
            child: SubtitleWithIcon(
              text: 'قيِّم التطبيق',
              icon: NoorIcons.star,
            ),
          ),
        ),
        const Divider(),
        InkWell(
          onTap: share,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: MediaQuery.of(context).size.width,
            child: SubtitleWithIcon(
              text: 'نشر التطبيق',
              icon: NoorIcons.share,
            ),
          ),
        ),
        const Divider(),
        InkWell(
          onTap: () => launchURL(Links.contactEmailURL),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: MediaQuery.of(context).size.width,
            child: SubtitleWithIcon(
              text: 'تواصل معنا',
              icon: NoorIcons.mail,
            ),
          ),
        ),
        const Divider(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SubtitleWithIcon(
                text: 'شبكات التواصل',
                icon: NoorIcons.follow,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => launchURL(Links.twitter),
                    child: Image.asset(images.twitterButton, width: 65),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => launchURL(Links.ig),
                    child: Image.asset(images.igButton, width: 65),
                  ),
                  SizedBox(width: 20)
                ],
              )
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
