import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:noor/exports/models.dart' show DataModel, AllahName;
import 'package:noor/exports/constants.dart' show Images, Ribbon;
import 'package:noor/exports/components.dart'
    show
        NoorCloseButton,
        CardTemplate,
        NoorIcons,
        NameTitleCard,
        FavAction,
        CopyAction,
        CardText;

class AllahNamesList extends StatefulWidget {
  const AllahNamesList({
    Key? key,
    this.index = 0,
  }) : super(key: key);
  final int index;
  _AllahNamesListState createState() => _AllahNamesListState();
}

class _AllahNamesListState extends State<AllahNamesList>
    with SingleTickerProviderStateMixin {
  ItemScrollController? controller;
  ItemPositionsListener listener = ItemPositionsListener.create();
  late Animation<double> animation;
  late AnimationController animationController;
  late ValueNotifier<int> pagePosition;

  List<AllahName> allahNames = <AllahName>[];

  @override
  void initState() {
    super.initState();
    pagePosition = ValueNotifier<int>(0);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      listener.itemPositions.addListener(changeAppBar);
    });

    animationController = new AnimationController(vsync: this);
    animation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticIn),
    );
    controller = new ItemScrollController();
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
      child: TextButton.icon(
        icon: Image.asset(Images.referenceIcon),
        label: Text(
          'ذُكِرَ في',
          style: Theme.of(context).textTheme.button,
          textScaleFactor: 1,
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
    final DataModel dataModel = context.watch<DataModel>();

    allahNames = dataModel.allahNames;

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
                      builder: (BuildContext context,
                          ValueNotifier<int> position, _) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Text(
                            allahNames[position.value].name,
                            textAlign: TextAlign.center,
                            key: ValueKey<String?>(
                              allahNames[position.value].name,
                            ),
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
            child: Scrollbar(
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
                        additionalContent:
                            name.inApp ? backToMainLocation(name) : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CardText(text: textList[0] + '.'),
                            SizedBox(height: 10),
                            CardText(text: textList[1] + '.'),
                          ],
                        ),
                        actions: <Widget>[
                          FavAction(name),
                          CopyAction('اسم الله (${name.name}): ${name.text}')
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ReferenceList extends StatelessWidget {
  ReferenceList({Key? key, required this.name}) : super(key: key);
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
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 45),
                  Text(
                    name.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  NoorCloseButton(color: Theme.of(context).accentColor),
                ],
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                controller: scrollController,
                itemCount: name.occurances.length,
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  final dynamic element = allLists.singleWhere(
                    (dynamic item) => item.id == name.occurances[index],
                  );

                  return CardTemplate(
                    ribbon: element.ribbon,
                    additionalContent: Text('${element.sectionName}'),
                    child: CardText(text: element.text),
                    actions: <Widget>[
                      Icon(
                        icons[element.category.index],
                        color: Colors.white,
                      ),
                      CopyAction(element.text)
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
