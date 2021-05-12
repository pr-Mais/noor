import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noor/models/data.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:noor/exports/components.dart' show NoorCloseButton, CardTemplate;
import 'package:noor/exports/constants.dart' show Ribbon;
import 'package:noor/exports/models.dart' show Doaa;
import 'package:noor/exports/controllers.dart' show DataController, SettingsProvider;
import 'package:noor/exports/utils.dart' show Copy, Tashkeel;

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

  List<List<Doaa>> data;

  @override
  void didChangeDependencies() {
    final DataModel dataModel = context.watch<DataModel>();

    data = <List<Doaa>>[
      dataModel.quraan,
      dataModel.sunnah,
      dataModel.ruqiya,
    ];

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settings = context.watch<SettingsProvider>();
    final DataController provider = context.watch<DataController>();

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
              itemCount: data[widget.section].length,
              initialScrollIndex: widget.index,
              itemScrollController: controller,
              itemBuilder: (BuildContext context, int index) {
                Doaa item = data[widget.section][index];
                return CardTemplate(
                  ribbon: ribbon[item.sectionName],
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () {
                        item.isFav == 1 ? provider.removeFromFav(item) : provider.addToFav(item);
                      },
                      child: AnimatedCrossFade(
                        firstChild: Image.asset('assets/icons/outline_heart.png'),
                        secondChild: Image.asset('assets/icons/filled_heart.png'),
                        crossFadeState: item.isFav == 1 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        duration: Duration(milliseconds: 500),
                      ),
                    ),
                    GestureDetector(
                      child: Image.asset('assets/icons/copy.png'),
                      onTap: () {
                        Copy.onCopy(item.text, context);
                      },
                    ),
                  ],
                  additionalContent: item.info.isNotEmpty
                      ? Text(
                          item.info,
                          textAlign: TextAlign.right,
                          textScaleFactor: settings.fontSize,
                        )
                      : null,
                  child: Text(
                    !context.watch<SettingsProvider>().tashkeel ? Tashkeel.remove(item.text) : item.text,
                    textScaleFactor: settings.fontSize,
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
