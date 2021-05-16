import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:noor/models/data.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

import 'package:noor/exports/components.dart'
    show
        CardTemplate,
        DeleteConfirmationDialog,
        ImageButton,
        NoorIcons,
        NoorSettingsIcons;
import 'package:noor/exports/models.dart' show AllahName, SettingsModel;
import 'package:noor/exports/constants.dart'
    show FavButtons, Images, NoorCategory;
import 'package:noor/exports/pages.dart'
    show Ad3yahList, AllahNamesList, AthkarList, MyAd3yah;
import 'package:noor/exports/controllers.dart'
    show DataController, ThemeProvider;
import 'package:noor/exports/utils.dart' show Tashkeel, backToExactLocation;

class Favorite extends StatefulWidget {
  Favorite({
    Key? key,
  }) : super(key: key);
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ScrollController _scrollController = ScrollController();
  List<dynamic> sectionList = <dynamic>[];
  List<dynamic> favList = <dynamic>[];

  ValueNotifier<int> section = ValueNotifier<int>(0);

  List<IconData> icons = <IconData>[
    NoorIcons.all,
    NoorIcons.leaf,
    NoorIcons.quraan,
    NoorIcons.sunnah,
    NoorIcons.ruqyah,
    NoorIcons.myad3yah,
    NoorSettingsIcons.allahnames,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    favList = context.watch<DataModel>().favList;
    sectionList = favList;
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
    final tmpList =
        allLists.where((element) => element.category == item.category).toList();
    final index = tmpList
        .indexWhere((element) => element.sectionName == item.sectionName);
    switch (item.category) {
      case NoorCategory.ATHKAR:
        Navigator.of(context).push(
          MaterialPageRoute<AthkarList>(
            builder: (context) => AthkarList(
              index: index,
            ),
          ),
        );
        break;
      case NoorCategory.MYAD3YAH:
        Navigator.of(context).push(
          MaterialPageRoute<MyAd3yah>(
            builder: (context) => MyAd3yah(),
          ),
        );
        break;
      case NoorCategory.ALLAHNAME:
        Navigator.of(context).push(
          MaterialPageRoute<AllahNamesList>(
            builder: (context) => AllahNamesList(),
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

  // TODO(Mais): Refactor into a widget
  //delete dialog confirmation
  deleteDialog(dynamic dataToDelete, int i) {
    final DataController? data = GetIt.I<DataController>();

    showGeneralDialog(
      transitionDuration: Duration(milliseconds: 600),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.75),
      barrierLabel: '',
      context: context,
      transitionBuilder: (_, Animation<double> a1, Animation<double> a2, __) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 800, 0.0),
          child: DeleteConfirmationDialog(
            () => data!.removeFromFav(dataToDelete),
          ),
        );
      },
      pageBuilder: ((_, __, ___) => SizedBox()),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Images images = context.read<ThemeProvider>().images;
    final DataController? data = GetIt.I<DataController>();

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
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                separatorBuilder: (context, __) => const SizedBox(width: 10.0),
                scrollDirection: Axis.horizontal,
                itemCount: FavButtons.list.length,
                itemBuilder: (context, int i) {
                  return ImageButton(
                    width: 110,
                    image: FavButtons.list[i],
                    onTap: () {
                      section.value = i;
                      setState(() {
                        sectionList = i == 0
                            ? favList
                            : favList
                                .where((dynamic element) =>
                                    element.category.index + 1 == section.value)
                                .toList();
                      });
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
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
                                  key: ValueKey<String>('List'),
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
                                    (BuildContext context, int index) =>
                                        FavCard(
                                      key: ValueKey<int>(index),
                                      icon: icons[
                                          sectionList[index].category.index +
                                              1],
                                      item: sectionList[index],
                                      remove: () {
                                        deleteDialog(
                                            sectionList[index],
                                            sectionList
                                                .indexOf(sectionList[index]));
                                      },
                                      ribbon: sectionList[index].ribbon,
                                      backToLocation: () {
                                        backToExactLocation(
                                            sectionList[index], context);
                                      },
                                      backToGeneralLocation: () {
                                        backToMainPage(sectionList[index]);
                                      },
                                    ),
                                    childCount: sectionList.length,
                                  ),
                                  onReorder: data!.swapFav,
                                ),
                              ],
                            ),
                          )
                        : Scrollbar(
                            key: ValueKey<int>(section.value),
                            controller: _scrollController,
                            child: ListView(
                              controller: _scrollController,
                              key: ValueKey<int>(section.value),
                              children: <Widget>[
                                for (dynamic item in sectionList.toList())
                                  FavCard(
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
                                  )
                              ],
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
  FavCard({
    Key? key,
    this.item,
    this.icon,
    this.ribbon,
    required this.remove,
    this.backToLocation,
    this.backToGeneralLocation,
  }) : super(key: key);
  final dynamic item;
  final String? ribbon;
  final IconData? icon;
  final void Function() remove;
  final Function? backToLocation;
  final Function? backToGeneralLocation;

  Widget backToMainLocation(dynamic item) {
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
              item is AllahName ? item.name : item.sectionName,
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff6f85d5),
                  fontFamily: 'SST Light',
                  height: 1),
              textScaleFactor: 1,
            ),
          ],
        ),
        onPressed: backToLocation as void Function()?,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SettingsModel settings = context.watch<SettingsModel>();

    return CardTemplate(
      ribbon: ribbon,
      actions: <Widget>[
        IconButton(
          padding: EdgeInsets.zero,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          icon: Icon(
            icon,
            size: item is AllahName ? 22 : 32,
            color: Colors.white,
          ),
          onPressed: backToGeneralLocation as void Function()?,
        ),
        GestureDetector(
          child: Image.asset('assets/icons/erase.png'),
          onTap: remove,
        ),
      ],
      additionalContent: item.category == NoorCategory.MYAD3YAH
          ? Text(
              !settings.tashkeel ? Tashkeel.remove(item.info) : item.info,
              textScaleFactor: settings.fontSize,
            )
          : null,
      actionButton: backToMainLocation(item),
      child: item is AllahName
          ? SingleChildScrollView(
              child: Builder(
                builder: (BuildContext context) {
                  final List<String>? textList = item.text.split('.');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        !settings.tashkeel
                            ? Tashkeel.remove('${textList![0].trim()}.')
                            : '${textList![0].trim()}.',
                        textScaleFactor: settings.fontSize,
                      ),
                      SizedBox(height: 10),
                      Text(
                        !settings.tashkeel
                            ? Tashkeel.remove('${textList[1].trim()}.')
                            : '${textList[1].trim()}.',
                        textScaleFactor: settings.fontSize,
                        textAlign: TextAlign.right,
                      )
                    ],
                  );
                },
              ),
            )
          : Text(
              settings.tashkeel ? item.text : Tashkeel.remove(item.text),
              textScaleFactor: settings.fontSize,
            ),
    );
  }
}
