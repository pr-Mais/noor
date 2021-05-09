import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:noor/components/abstract_card.dart';
import 'package:noor/components/close_button.dart';
import 'package:noor/constants/ribbons.dart';
import 'package:noor/models/doaa.dart';
import 'package:noor/providers/data_provider.dart';
import 'package:noor/providers/settings_provider.dart';
import 'package:noor/utils/copy.dart';
import 'package:noor/utils/remove_tashkeel.dart';

class Ad3yahList extends StatefulWidget {
  const Ad3yahList({
    Key key,
    this.index = 0,
    @required this.section,
  }) : super(key: key);
  final int index;
  final int section;
  _Ad3yahListState createState() => _Ad3yahListState();
}

class _Ad3yahListState extends State<Ad3yahList> {
  ItemScrollController controller = ItemScrollController();

  List<String> title = <String>[
    'أدعية من القرآن الكريم',
    'أدعية من السنة النبوية',
    'الرقية الشرعية',
  ];
  final Map<String, String> ribbon = <String, String>{
    'أدعية من القرآن الكريم': Ribbon.ribbon2,
    'أدعية من السنة النبوية': Ribbon.ribbon3,
    'الرقية الشرعية': Ribbon.ribbon4,
  };

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settings = context.watch<SettingsProvider>();
    final DataProvider data = context.watch<DataProvider>();
    final List<Doaa> ad3yah = data.list
        .where((dynamic element) => element is Doaa && element.section == widget.section + 2)
        .toList()
        .cast<Doaa>();
    return Scaffold(
      body: Column(
        children: <Widget>[
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 45),
                  Text(
                    title[widget.section],
                    textAlign: TextAlign.center,
                   style: Theme.of(context).textTheme.headline1,
                  ),
                  NoorCloseButton(color: Theme.of(context).accentColor),
                ],
              ),
            ),
          ),
          Expanded(
            child: ScrollablePositionedList.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: ad3yah.length,
              initialScrollIndex: widget.index,
              itemScrollController: controller,
              itemBuilder: (BuildContext context, int index) {
                return CardTemplate(
                  ribbon: ribbon[ad3yah[index].sectionName],
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () {
                        ad3yah[index].isFav == 1 ? data.removeFromFav(ad3yah[index]) : data.addToFav(ad3yah[index]);
                      },
                      child: AnimatedCrossFade(
                        firstChild: Image.asset('assets/icons/outline_heart.png'),
                        secondChild: Image.asset('assets/icons/filled_heart.png'),
                        crossFadeState: ad3yah[index].isFav == 1 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        duration: Duration(milliseconds: 500),
                      ),
                    ),
                    GestureDetector(
                      child: Image.asset('assets/icons/copy.png'),
                      onTap: () {
                        Copy.onCopy(ad3yah[index].text, context);
                      },
                    ),
                  ],
                  additionalContent: ad3yah[index].info.isNotEmpty
                      ? Text(
                          ad3yah[index].info,
                          textAlign: TextAlign.right,
                          textScaleFactor: settings.fontSize,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontFamily: settings.fontType,
                                fontSize: 12,
                                color: Theme.of(context).primaryColor,
                              ),
                        )
                      : null,
                  child: Text(
                    !context.watch<SettingsProvider>().tashkeel
                        ? Tashkeel.remove(ad3yah[index].text)
                        : ad3yah[index].text,
                    textAlign: TextAlign.justify,
                    textScaleFactor: settings.fontSize,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontFamily: settings.fontType),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
