import 'package:flutter/material.dart';
import 'package:noor/components/abstract_card.dart';
import 'package:noor/constants/ribbons.dart';
import 'package:noor/models/thekr.dart';
import 'package:noor/pages/tabs/1_home/athkar_expanded.dart';
import 'package:noor/providers/data_provider.dart';
import 'package:noor/providers/settings_provider.dart';
import 'package:noor/utils/copy.dart';
import 'package:noor/utils/remove_tashkeel.dart';
import 'package:noor/utils/to_arabic.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AthkarCard extends StatelessWidget {
  const AthkarCard({
    Key key,
    @required this.thekr,
    this.onTap,
  }) : super(key: key);
  final Thekr thekr;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final Counter counter = context.watch<Counter>();
    final DataProvider provider = context.watch<DataProvider>();
    final SettingsProvider settings = context.watch<SettingsProvider>();

    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: onTap,
          child: CardTemplate(
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  thekr.isFav == 1 ? provider.removeFromFav(thekr) : provider.addToFav(thekr);
                },
                child: AnimatedCrossFade(
                  firstChild: Image.asset('assets/icons/outline_heart.png'),
                  secondChild: Image.asset('assets/icons/filled_heart.png'),
                  crossFadeState: thekr.isFav == 1 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 500),
                ),
              ),
              GestureDetector(
                child: Image.asset('assets/icons/copy.png'),
                onTap: () => Copy.onCopy(thekr.text, context),
              ),
            ],
            ribbon: Ribbon.ribbon1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Text(
                !settings.tashkeel ? Tashkeel.remove(thekr.text) : thekr.text,
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
                textScaleFactor: settings.fontSize,
                style: Theme.of(context).textTheme.bodyText1.copyWith(fontFamily: settings.fontType)
              ),
            ),
          ),
        ),
        ((settings.showCounter ?? true) || thekr.counter > 1)
            ? Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: counter.getCounter < 1
                      ? AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.bounceInOut,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.done,
                            color: Color(0xff58d1ed),
                          ),
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).brightness == Brightness.light ? Colors.white : Color(0xff202b54),
                              border: Border.all(color: Color(0xff6f86d6), width: 2),
                              borderRadius: BorderRadius.circular(50.0)),
                          width: 45.0,
                          height: 45.0,
                        )
                      : Container(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              ToArabic.integer(counter.getCounter),
                              key: ValueKey<int>(counter.getCounter),
                              style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16, height: 1.25),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).brightness == Brightness.light ? Colors.white : Color(0xff202b54),
                              border: Border.all(
                                  color: Theme.of(context).brightness == Brightness.light
                                      ? Colors.grey[400]
                                      : Color(0xff33477f),
                                  width: 2),
                              borderRadius: BorderRadius.circular(50.0)),
                          width: 45.0,
                          height: 45.0,
                        ),
                ),
              )
            : Container()
      ],
    );
  }
}
