import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noor/models/data.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

import 'package:noor/components/abstract_card.dart';
import 'package:noor/components/custom_dialog.dart';
import 'package:noor/components/image_button.dart';
import 'package:noor/components/noor_icons_icons.dart';
import 'package:noor/components/noor_settings_icons.dart';

import 'package:noor/constants/fav_buttons.dart';
import 'package:noor/constants/ribbons.dart';
import 'package:noor/constants/images.dart';
import 'package:noor/models/allah_name.dart';

import 'package:noor/pages/tabs/1_home/ad3yah_expanded.dart';
import 'package:noor/pages/tabs/1_home/allah_names_expanded.dart';
import 'package:noor/pages/tabs/1_home/athkar_expanded.dart';
import 'package:noor/pages/tabs/1_home/my_ad3yah.dart';

import 'package:noor/providers/data_controller.dart';
import 'package:noor/providers/settings_provider.dart';
import 'package:noor/providers/theme_provider.dart';
import 'package:noor/services/prefs.dart';
import 'package:noor/utils/back_to_location.dart';
import 'package:noor/utils/remove_tashkeel.dart';

import '../../providers/data_controller.dart';

class Favorite extends StatefulWidget {
  Favorite({
    Key key,
  }) : super(key: key);
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ScrollController _scrollController = ScrollController();
  List<dynamic> list;
  List<dynamic> sectionList = <dynamic>[];

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

  Map<int, String> ribbons = <int, String>{
    1: Ribbon.ribbon1,
    2: Ribbon.ribbon2,
    3: Ribbon.ribbon3,
    4: Ribbon.ribbon4,
    5: Ribbon.ribbon5,
    6: Ribbon.ribbon6,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    list = Provider.of<DataModel>(context).favList ?? <dynamic>[];
    sectionList = list;
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
    final tmpList = allLists.where((element) => element.section == item.section).toList();
    final index = tmpList.indexWhere((element) => element.sectionName == item.sectionName);
    switch (item.section) {
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AthkarList(
            index: index,
          ),
        ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyAd3yah(),
        ));
        break;
      case 6:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AllahNamesList(),
        ));
        break;
      default:
        Navigator.of(context).push(
          MaterialPageRoute<Ad3yahList>(
            builder: (_) => Ad3yahList(
              index: index,
              section: item.section - 2,
            ),
          ),
        );
    }
  }

  // TODO(Mais): Refactor into a widget
  //delete dialog confirmation
  deleteDialog(dynamic dataToDelete, int i) {
    final DataController data = context.read<DataController>();

    showGeneralDialog(
      transitionDuration: Duration(milliseconds: 600),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.75),
      barrierLabel: '',
      context: context,
      transitionBuilder: (_, Animation<double> a1, Animation<double> a2, __) {
        final double curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 800, 0.0),
          child: CustomDialog(
            onDelete: () {
              data.removeFromFav(dataToDelete);
            },
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) => null,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Images images = context.read<ThemeProvider>().images;
    final DataController data = context.watch<DataController>();

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
                separatorBuilder: (_, __) => const SizedBox(width: 10.0),
                scrollDirection: Axis.horizontal,
                itemCount: FavButtons.list.length,
                itemBuilder: (_, int i) {
                  return ImageButton(
                    width: 110,
                    image: FavButtons.list[i],
                    onTap: () {
                      section.value = i;
                      setState(() {
                        sectionList = section.value == 0
                            ? list
                            : list.where((dynamic element) => element.section == section.value).toList();
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
                              slivers: <Widget>[
                                ReorderableSliverList(
                                  key: ValueKey<String>('List'),
                                  controller: _scrollController,
                                  buildDraggableFeedback: (_, BoxConstraints constraints, Widget child) {
                                    return Material(
                                      type: MaterialType.transparency,
                                      child: SizedBox(
                                        width: constraints.maxWidth,
                                        child: child,
                                      ),
                                    );
                                  },
                                  delegate: ReorderableSliverChildBuilderDelegate(
                                    (BuildContext context, int index) => FavCard(
                                      key: ValueKey<int>(index),
                                      icon: icons[sectionList.toList()[index].section],
                                      item: sectionList.toList()[index],
                                      remove: () {
                                        deleteDialog(sectionList.toList()[index],
                                            sectionList.indexOf(sectionList.toList()[index]));
                                      },
                                      ribbon: ribbons[sectionList.toList()[index].section],
                                      backToLocation: () {
                                        backToLocation(sectionList.toList()[index], context);
                                      },
                                      backToGeneralLocation: () {
                                        backToMainPage(sectionList.toList()[index]);
                                      },
                                    ),
                                    childCount: sectionList.length,
                                  ),
                                  onReorder: data.swapFav,
                                ),
                              ],
                            ),
                          )
                        : Scrollbar(
                            controller: _scrollController,
                            child: ListView(
                              controller: _scrollController,
                              key: ValueKey<int>(section.value),
                              children: <Widget>[
                                for (dynamic item in sectionList.toList())
                                  FavCard(
                                    key: ValueKey<dynamic>(item),
                                    icon: icons[item.section],
                                    item: item,
                                    remove: () {
                                      deleteDialog(item, sectionList.indexOf(item));
                                    },
                                    ribbon: ribbons[item.section],
                                    backToLocation: () {
                                      backToLocation(item, context);
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
    Key key,
    this.item,
    this.icon,
    this.ribbon,
    this.remove,
    this.backToLocation,
    this.backToGeneralLocation,
  }) : super(key: key);
  final dynamic item;
  final String ribbon;
  final IconData icon;
  final Function remove;
  final Function backToLocation;
  final Function backToGeneralLocation;

  Widget backToMainLocation(String location) {
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
              location,
              style: TextStyle(fontSize: 14, color: Color(0xff6f85d5), fontFamily: 'SST Light', height: 1),
              textScaleFactor: 1,
            ),
          ],
        ),
        onPressed: backToLocation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settings = context.watch<SettingsProvider>();

    return CardTemplate(
      ribbon: ribbon,
      actions: <Widget>[
        IconButton(
          padding: EdgeInsets.zero,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          icon: Icon(
            icon,
            size: item.runtimeType == AllahName ? 22 : 32,
            color: Colors.white,
          ),
          onPressed: backToGeneralLocation,
        ),
        GestureDetector(
          child: Image.asset('assets/icons/erase.png'),
          onTap: () {
            remove();
          },
        ),
      ],
      additionalContent: item.section == 5
          ? Text(
              !settings.tashkeel ? Tashkeel.remove(item.info) : item.info,
              textScaleFactor: settings.fontSize,
            )
          : null,
      actionButton: backToMainLocation(item is AllahName ? item.name : item.sectionName),
      child: item is AllahName
          ? SingleChildScrollView(
              child: Builder(
                builder: (BuildContext context) {
                  final List<String> textList = item.text.split('.');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        !settings.tashkeel ? Tashkeel.remove('${textList[0].trim()}.') : '${textList[0].trim()}.',
                        textScaleFactor: settings.fontSize,
                      ),
                      SizedBox(height: 10),
                      Text(
                        !settings.tashkeel ? Tashkeel.remove('${textList[1].trim()}.') : '${textList[1].trim()}.',
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
