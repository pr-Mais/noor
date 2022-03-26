import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:noor/models/data.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

import 'package:noor/exports/components.dart'
    show CardTemplate, DeleteConfirmationDialog, ImageButton;
import 'package:noor/exports/models.dart' show AllahName;
import 'package:noor/exports/constants.dart' show Images, NoorCategory;
import 'package:noor/exports/pages.dart'
    show Ad3yahList, AllahNamesList, AthkarList, MyAd3yah;
import 'package:noor/exports/controllers.dart' show DataController, ThemeModel;
import 'package:noor/exports/utils.dart' show backToExactLocation;
import 'package:noor/exports/components.dart' show CardText;

class Favorite extends StatefulWidget {
  const Favorite({
    Key? key,
  }) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _scrollController = ScrollController();
  List<dynamic> sectionList = <dynamic>[];
  List<dynamic> favList = <dynamic>[];

  late ValueNotifier<int> section = ValueNotifier<int>(0);

  List<String> icons = <String>[
    Images.allFavIcon,
    Images.athkarFavIcon,
    Images.quraanFavIcon,
    Images.sunnahFavIcon,
    Images.ruqyaFavIcon,
    Images.myAd3yahFavIcon,
    Images.allahNamesFavIcon,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // This will be triggered whenever an item is added
    // or removed from favorite somehwere else, so this page
    // rebuilds to reflect the new list
    setState(() {
      favList = context.watch<DataModel>().favList;
      updateSectionList();
    });

    // This will run only at the first build of this page
    // if there were items in favList
    if (favList.isNotEmpty && sectionList.isEmpty) {
      updateSectionList();
    }

    // Updates the sections with corresponding items on click
    section.addListener(updateSectionList);
  }

  updateSectionList() {
    setState(() {
      sectionList = section.value == 0
          ? favList
          : favList
              .where((dynamic element) =>
                  element.category.index + 1 == section.value)
              .toList();
    });
  }

  backToMainPage(dynamic item) async {
    final DataModel dataModel = context.read<DataModel>();

    final List<dynamic> allLists = List<dynamic>.from(<dynamic>[
      ...dataModel.athkar,
      ...dataModel.quraan,
      ...dataModel.sunnah,
      ...dataModel.ruqiya,
      ...dataModel.allahNames,
    ]);
    final List<dynamic> tmpList = allLists
        .where((dynamic element) => element.category == item.category)
        .toList();
    final int index = tmpList.indexWhere(
        (dynamic element) => element.sectionName == item.sectionName);
    switch (item.category) {
      case NoorCategory.athkar:
        Navigator.of(context).push(
          MaterialPageRoute<AthkarList>(
            builder: (_) => AthkarList(index: index),
          ),
        );
        break;
      case NoorCategory.myad3yah:
        Navigator.of(context).push(
          MaterialPageRoute<MyAd3yah>(
            builder: (_) => const MyAd3yah(),
          ),
        );
        break;
      case NoorCategory.allahname:
        Navigator.of(context).push(
          MaterialPageRoute<AllahNamesList>(
            builder: (_) => const AllahNamesList(),
          ),
        );
        break;
      default:
        Navigator.of(context).push(
          MaterialPageRoute<Ad3yahList>(
            builder: (_) => Ad3yahList(
              index: index,
              category: item.category,
            ),
          ),
        );
    }
  }

  //delete dialog confirmation
  deleteDialog(dynamic dataToDelete, int i) async {
    final bool? result = await DeleteConfirmationDialog.of(context).show();

    if (result == true) {
      GetIt.I<DataController>().removeFromFav(dataToDelete);
    }
  }

  void onSectionTap(int i) {
    section.value = i;
  }

  void onReorder(a, b) {
    GetIt.I<DataController>().swapFav(a, b);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Images images = context.read<ThemeModel>().images;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 22),
              height: 45,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                separatorBuilder: (_, __) => const SizedBox(width: 10.0),
                scrollDirection: Axis.horizontal,
                itemCount: Images.favButtonsList.length,
                itemBuilder: (_, int i) {
                  return ImageButton(
                    width: 110,
                    image: Images.favButtonsList[i],
                    onTap: () => onSectionTap(i),
                  );
                },
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: sectionList.isEmpty
                    ? Container(
                        key: ValueKey<String>(images.noAd3yahFav),
                        height: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(images.noAd3yahFav),
                          ),
                        ),
                      )
                    : section.value == 0
                        ? Scrollbar(
                            controller: _scrollController,
                            child: CustomScrollView(
                              controller: _scrollController,
                              slivers: <Widget>[
                                ReorderableSliverList(
                                  key: const ValueKey<String>('List'),
                                  controller: _scrollController,
                                  buildDraggableFeedback: (_,
                                      BoxConstraints constraints,
                                      Widget child) {
                                    return Material(
                                      type: MaterialType.transparency,
                                      child: SizedBox(
                                        width: constraints.maxWidth,
                                        child: child,
                                      ),
                                    );
                                  },
                                  delegate:
                                      ReorderableSliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      dynamic item = sectionList[index];
                                      return FavCard(
                                        key: ValueKey<int>(index),
                                        icon: icons[item.category.index + 1],
                                        item: item,
                                        remove: () {
                                          deleteDialog(
                                              item, favList.indexOf(item));
                                        },
                                        ribbon: item.ribbon,
                                        backToLocation: () {
                                          backToExactLocation(item, context);
                                        },
                                        backToGeneralLocation: () {
                                          backToMainPage(item);
                                        },
                                      );
                                    },
                                    childCount: favList.length,
                                  ),
                                  onReorder: onReorder,
                                ),
                              ],
                            ),
                          )
                        : Scrollbar(
                            key: ValueKey<int>(section.value),
                            controller: _scrollController,
                            child: ListView.builder(
                              itemCount: sectionList.length,
                              controller: _scrollController,
                              key: ValueKey<int>(section.value),
                              itemBuilder: (BuildContext context, int index) {
                                dynamic item = sectionList[index];
                                return FavCard(
                                  key: ValueKey<dynamic>(item),
                                  icon: icons[item.category.index + 1],
                                  item: item,
                                  remove: () {
                                    deleteDialog(
                                        item, sectionList.indexOf(item));
                                  },
                                  ribbon: item.ribbon,
                                  backToLocation: () {
                                    backToExactLocation(item, context);
                                  },
                                  backToGeneralLocation: () {
                                    backToMainPage(item);
                                  },
                                );
                              },
                            ),
                          ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FavCard extends StatelessWidget {
  const FavCard({
    Key? key,
    required this.item,
    required this.icon,
    required this.ribbon,
    required this.remove,
    required this.backToLocation,
    required this.backToGeneralLocation,
  }) : super(key: key);

  final dynamic item;
  final String ribbon;
  final String icon;
  final void Function() remove;
  final void Function() backToLocation;
  final void Function() backToGeneralLocation;

  Widget backToMainLocation(dynamic item, BuildContext context) {
    return Container(
      height: 30,
      alignment: Alignment.bottomRight,
      child: TextButton.icon(
        icon: Image.asset(Images.referenceIcon),
        label: Text(
          item is AllahName ? item.name : item.sectionName,
          textScaleFactor: 1,
          style: Theme.of(context).textTheme.button,
        ),
        onPressed: backToLocation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      ribbon: ribbon,
      actions: <Widget>[
        GestureDetector(
          child: Image.asset(icon),
          onTap: backToGeneralLocation,
        ),
        GestureDetector(
          child: Image.asset(Images.eraseIcon),
          onTap: remove,
        ),
      ],
      additionalContent: item.category == NoorCategory.myad3yah
          ? CardText(
              text: item.info,
              color: Theme.of(context).primaryColor,
            )
          : null,
      actionButton: backToMainLocation(item, context),
      child: item is AllahName
          ? SingleChildScrollView(
              child: Builder(
                builder: (BuildContext context) {
                  final List<String> textList = item.text.split('.');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CardText(text: textList[0].trim()),
                      const SizedBox(height: 10),
                      CardText(text: textList[1].trim()),
                    ],
                  );
                },
              ),
            )
          : CardText(text: item.text),
    );
  }
}
