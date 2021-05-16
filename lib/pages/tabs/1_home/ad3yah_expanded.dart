import 'package:flutter/material.dart';
import 'package:noor/constants/categories.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:noor/exports/components.dart'
    show NoorCloseButton, CardTemplate, FavAction, CardText, CopyAction;
import 'package:noor/exports/models.dart' show Doaa, DataModel;
import 'package:noor/exports/controllers.dart' show SettingsModel;

class Ad3yahList extends StatefulWidget {
  const Ad3yahList({
    Key? key,
    this.index = 0,
    required this.category,
  }) : super(key: key);
  final int index;
  final NoorCategory category;
  _Ad3yahListState createState() => _Ad3yahListState();
}

class _Ad3yahListState extends State<Ad3yahList> {
  ItemScrollController controller = ItemScrollController();

  late List<List<Doaa>> data;

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
    final SettingsModel settings = context.watch<SettingsModel>();

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
                    categoryTitle[widget.category] ?? '',
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
              itemCount: data[widget.category.index - 1].length,
              initialScrollIndex: widget.index,
              itemScrollController: controller,
              itemBuilder: (BuildContext context, int index) {
                Doaa item = data[widget.category.index - 1][index];

                return CardTemplate(
                  ribbon: item.ribbon,
                  actions: <Widget>[
                    FavAction(item),
                    CopyAction(item.text),
                  ],
                  additionalContent: item.info.isNotEmpty
                      ? Text(
                          item.info,
                          textAlign: TextAlign.right,
                        )
                      : null,
                  child: CardText(text: item.text),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
