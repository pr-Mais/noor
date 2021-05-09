import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:noor/components/allah_names_title.dart';
import 'package:noor/components/noor_icons_icons.dart';
import 'package:noor/constants/ribbons.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:noor/components/abstract_card.dart';
import 'package:noor/models/allah_name.dart';
import 'package:noor/utils/copy.dart';
import 'package:noor/utils/remove_tashkeel.dart';
import 'package:noor/providers/data_provider.dart';

import '../../../components/close_button.dart';
import '../../../providers/settings_provider.dart';

class AllahNamesList extends StatefulWidget {
  const AllahNamesList({
    Key key,
    this.index = 0,
  }) : super(key: key);
  final index;
  _AllahNamesListState createState() => _AllahNamesListState();
}

class _AllahNamesListState extends State<AllahNamesList> with SingleTickerProviderStateMixin {
  ItemScrollController controller;
  ItemPositionsListener listener = ItemPositionsListener.create();
  Animation animation;
  AnimationController animationController;
  ValueNotifier<int> pagePosition;

  List names = [];

  @override
  void initState() {
    super.initState();
    pagePosition = ValueNotifier<int>(0);
    animationController = new AnimationController(
      vsync: this,
    );
    animation = Tween(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticIn),
    );
    controller = new ItemScrollController();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
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

  Widget backToMainLocation(name) {
    return Container(
      height: 30,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReferenceList(name: name),
          ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    names = context.read<DataProvider>().list.where((element) => element is AllahName).toList();
    final SettingsProvider settings = context.read<SettingsProvider>();
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
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
                  ChangeNotifierProvider<ValueNotifier<int>>.value(
                    value: pagePosition,
                    child: Consumer<ValueNotifier<int>>(
                      builder: (BuildContext context, ValueNotifier<int> position, _) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Text(
                            names[position.value].name,
                            textAlign: TextAlign.center,
                            key: ValueKey<String>(names[position.value].name),
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              height: 1.2,
                              fontSize: 18,
                            ),
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
              itemCount: names.length,
              addAutomaticKeepAlives: true,
              initialScrollIndex: widget.index,
              padding: EdgeInsets.only(bottom: 20),
              itemBuilder: (_, int index) {
                final AllahName name = names[index];

                List<String> textList = name.text.split('.');
                textList = textList.map((e) => e.trim()).toList();

                return Column(
                  children: [
                    NameTitleCard(
                      title: name.name,
                    ),
                    CardTemplate(
                      ribbon: Ribbon.ribbon6,
                      additionalContent: name.inApp ? backToMainLocation(name) : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            !settings.tashkeel ? Tashkeel.remove('${textList[0]}.') : '${textList[0]}.',
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl,
                            textScaleFactor: settings.fontSize,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(fontFamily: settings.fontType),
                          ),
                          SizedBox(height: 10),
                          Text(
                            !settings.tashkeel ? Tashkeel.remove('${textList[1]}.') : '${textList[1]}.',
                            textDirection: TextDirection.rtl,
                            textScaleFactor: settings.fontSize,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(fontFamily: settings.fontType),
                          )
                        ],
                      ),
                      actions: [
                        GestureDetector(
                          onTap: () {
                            print(name.isFav);
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
                          onTap: () {
                            Copy.onCopy(name.text, context);
                          },
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

  final List<String> ribbon = [
    Ribbon.ribbon1,
    Ribbon.ribbon2,
    Ribbon.ribbon3,
    Ribbon.ribbon4,
    Ribbon.ribbon5,
    Ribbon.ribbon6,
  ];

  final List icons = [
    NoorIcons.leaf,
    NoorIcons.quraan,
    NoorIcons.sunnah,
    NoorIcons.ruqyah,
    NoorIcons.myad3yah,
  ];
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context);
    final SettingsProvider settings = context.watch<SettingsProvider>();

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
                final dynamic element = data.list.singleWhere((dynamic item) => item.id == name.occurances[index]);

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
