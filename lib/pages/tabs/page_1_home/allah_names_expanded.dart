import 'package:flutter/material.dart';
import 'package:noor/exports/components.dart'
    show
        NoorCloseButton,
        CardTemplate,
        NameTitleCard,
        FavAction,
        CopyAction,
        CardText;
import 'package:noor/exports/constants.dart' show Images, Ribbon;
import 'package:noor/exports/models.dart' show DataModel, AllahName;
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AllahNamesList extends StatefulWidget {
  const AllahNamesList({
    Key? key,
    this.index = 0,
  }) : super(key: key);
  final int index;
  @override
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listener.itemPositions.addListener(changeAppBar);
    });

    animationController = AnimationController(vsync: this);
    animation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticIn),
    );
    controller = ItemScrollController();
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
          style: Theme.of(context).textTheme.labelLarge,
          textScaler: const TextScaler.linear(1),
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
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(width: 45),
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
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        );
                      },
                    ),
                  ),
                  NoorCloseButton(
                      color: Theme.of(context).colorScheme.secondary),
                ],
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: ScrollablePositionedList.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemScrollController: controller,
                itemPositionsListener: listener,
                itemCount: allahNames.length,
                addAutomaticKeepAlives: true,
                initialScrollIndex: widget.index,
                padding: const EdgeInsets.only(bottom: 20),
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
                            const SizedBox(height: 10),
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

  final List<String> icons = <String>[
    Images.athkarFavIcon,
    Images.quraanFavIcon,
    Images.sunnahFavIcon,
    Images.ruqyaFavIcon,
    Images.allahNamesFavIcon,
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
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(width: 45),
                  Text(
                    name.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  NoorCloseButton(
                      color: Theme.of(context).colorScheme.secondary),
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
                    child: CardText(
                      text: element.text,
                      item: name,
                    ),
                    actions: <Widget>[
                      Image.asset(icons[element.category.index]),
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
