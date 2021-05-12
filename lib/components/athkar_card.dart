import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:noor/exports/models.dart' show Thekr;
import 'package:noor/exports/pages.dart' show Counter;
import 'package:noor/exports/constants.dart' show Ribbon;
import 'package:noor/exports/components.dart' show CardTemplate;
import 'package:noor/exports/utils.dart' show Tashkeel, Copy, ToArabicNumbers;
import 'package:noor/exports/controllers.dart' show DataController, SettingsProvider;
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
    final DataController dataController = GetIt.I<DataController>();
    final SettingsProvider settings = context.watch<SettingsProvider>();

    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: onTap,
          child: CardTemplate(
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  thekr.isFav == 1 ? dataController.removeFromFav(thekr) : dataController.addToFav(thekr);
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
                textScaleFactor: settings.fontSize,
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
                              '${counter.getCounter}'.arabicDigit(),
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
