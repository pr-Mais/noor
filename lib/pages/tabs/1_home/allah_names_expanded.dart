import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:noor/exports/utils.dart' show Copy, Tashkeel;
import 'package:noor/exports/models.dart' show DataModel, AllahName;
import 'package:noor/exports/constants.dart' show Ribbon;
import 'package:noor/exports/components.dart' show NoorCloseButton, CardTemplate, NoorIcons, NameTitleCard;
import 'package:noor/exports/controllers.dart' show DataController, SettingsProvider;

class AllahNamesList extends StatefulWidget {
  const AllahNamesList({
    Key key,
    this.index = 0,
  }) : super(key: key);
  final int index;
  _AllahNamesListState createState() => _AllahNamesListState();
}

class _AllahNamesListState extends State<AllahNamesList> with SingleTickerProviderStateMixin {
  ItemScrollController controller;
  ItemPositionsListener listener = ItemPositionsListener.create();
  Animation<double> animation;
  AnimationController animationController;
  ValueNotifier<int> pagePosition;

  List<AllahName> allahNames = <AllahName>[];

  @override
  void initState() {
    super.initState();
    pagePosition = ValueNotifier<int>(0);
    animationController = new AnimationController(
      vsync: this,
    );
    animation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticIn),
    );
    controller = new ItemScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listener.itemPositions.addListener(changeAppBar);
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  changeAppBar() {
    pagePosition.value = listener.itemPositions.value.toList()[0].index;
  }

  Widget backToMainLocation(AllahName name) {
    return Container(
      height: 30,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/icons/back.png'),
            SizedBox(width: 10),
            Text(
              'ذُكِرَ في',
              style: TextStyle(fontSize: 14, color: Color(0xff6f85d5), fontFamily: 'SST Light', height: 1),
              textScaleFactor: 1,
            ),
          ],
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<ReferenceList>(
              builder: (_) => ReferenceList(name: name),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DataController dataProvider = context.watch<DataController>();
    final DataModel dataModel = context.watch<DataModel>();

    allahNames = dataModel.allahNames;

    final SettingsProvider settings = context.read<SettingsProvider>();
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
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
                  ChangeNotifierProvider<ValueNotifier<int>>.value(
                    value: pagePosition,
                    child: Consumer<ValueNotifier<int>>(
                      builder: (BuildContext context, ValueNotifier<int> position, _) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Text(
                            allahNames[position.value].name,
                            textAlign: TextAlign.center,
                            key: ValueKey<String>(allahNames[position.value].name),
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        );
                      },
                    ),
                  ),
                  NoorCloseButton(color: Theme.of(context).accentColor),
                ],
              ),
            ),
          ),
          Expanded(
            child: ScrollablePositionedList.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemScrollController: controller,
              itemPositionsListener: listener,
              itemCount: allahNames.length,
              addAutomaticKeepAlives: true,
              initialScrollIndex: widget.index,
              padding: EdgeInsets.only(bottom: 20),
              itemBuilder: (_, int index) {
                final AllahName name = allahNames[index];

                List<String> textList = name.text.split('.');
                textList = textList.map((String e) => e.trim()).toList();

                return Column(
                  children: <Widget>[
                    NameTitleCard(title: name.name),
                    CardTemplate(
                      ribbon: Ribbon.ribbon6,
                      additionalContent: name.inApp ? backToMainLocation(name) : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            !settings.tashkeel ? Tashkeel.remove('${textList[0]}.') : '${textList[0]}.',
                            textScaleFactor: settings.fontSize,
                          ),
                          SizedBox(height: 10),
                          Text(
                            !settings.tashkeel ? Tashkeel.remove('${textList[1]}.') : '${textList[1]}.',
                            textScaleFactor: settings.fontSize,
                            textAlign: TextAlign.right,
                          )
                        ],
                      ),
                      actions: <Widget>[
                        GestureDetector(
                          onTap: () {
                            name.isFav == 1 ? dataProvider.removeFromFav(name) : dataProvider.addToFav(name);
                          },
                          child: AnimatedCrossFade(
                            firstChild: Image.asset('assets/icons/outline_heart.png'),
                            secondChild: Image.asset('assets/icons/filled_heart.png'),
                            crossFadeState: name.isFav == 1 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                            duration: Duration(milliseconds: 500),
                          ),
                        ),
                        GestureDetector(
                          child: Image.asset('assets/icons/copy.png'),
                          onTap: () => Copy.onCopy(name.text, context),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class ReferenceList extends StatelessWidget {
  ReferenceList({Key key, this.name}) : super(key: key);
  final AllahName name;

  final List<String> ribbon = <String>[
    Ribbon.ribbon1,
    Ribbon.ribbon2,
    Ribbon.ribbon3,
    Ribbon.ribbon4,
    Ribbon.ribbon5,
    Ribbon.ribbon6,
  ];

  final List<IconData> icons = <IconData>[
    NoorIcons.leaf,
    NoorIcons.quraan,
    NoorIcons.sunnah,
    NoorIcons.ruqyah,
    NoorIcons.myad3yah,
  ];
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settings = context.watch<SettingsProvider>();
    final DataModel dataModel = context.watch<DataModel>();

    final List<dynamic> allLists = List<dynamic>.from(<dynamic>[
      ...dataModel.athkar,
      ...dataModel.quraan,
      ...dataModel.sunnah,
      ...dataModel.ruqiya,
      ...dataModel.allahNames,
    ]);

    return Scaffold(
      body: Column(
        children: <Widget>[
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 45),
                  Text(
                    name.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      height: 1.2,
                      fontSize: 18,
                    ),
                  ),
                  NoorCloseButton(color: Theme.of(context).accentColor),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: name.occurances.length,
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int index) {
                final dynamic element = allLists.singleWhere((dynamic item) => item.id == name.occurances[index]);

                return CardTemplate(
                  ribbon: ribbon[element.section - 1],
                  additionalContent: Text(
                    '${element.sectionName}',
                    textScaleFactor: settings.fontSize,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                      height: 1.6,
                    ),
                  ),
                  child: Text(
                    !settings.tashkeel ? Tashkeel.remove('${element.text}') : '${element.text}',
                    textAlign: TextAlign.justify,
                    textDirection: TextDirection.rtl,
                    textScaleFactor: settings.fontSize,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontFamily: settings.fontType),
                  ),
                  actions: <Widget>[
                    Icon(
                      icons[element.section - 1],
                      color: Colors.white,
                    ),
                    GestureDetector(
                      child: Image.asset('assets/icons/copy.png'),
                      onTap: () {
                        Copy.onCopy(element.text, context);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
