import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:noor/exports/pages.dart' show Ad3yahList, MyAd3yah;
import 'package:noor/exports/constants.dart' show Titles, NoorCategory;
import 'package:noor/exports/components.dart' show NoorCloseButton, ListItem;
import 'package:noor/exports/controllers.dart' show ThemeModel;

class Ad3yah extends StatefulWidget {
  const Ad3yah({Key? key}) : super(key: key);
  @override
  _Ad3yahState createState() => _Ad3yahState();
}

class _Ad3yahState extends State<Ad3yah> with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  int index = 0;
  double currentScroll = 0;
  double maxHeight = 180;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = Tween<double>(begin: maxHeight, end: 0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInCubic,
    ))
      ..addListener(() {
        setState(() {
          maxHeight = animation.value;
        });
      });

    scrollController.addListener(() {
      currentScroll = scrollController.position.pixels;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeModel themeProvider = context.watch<ThemeModel>();

    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Positioned(
                child: GestureDetector(
                  child: Hero(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: maxHeight,
                      child: Image.asset(
                        themeProvider.images.ad3yahCard,
                        fit: BoxFit.cover,
                      ),
                    ),
                    tag: 'ad3yah',
                  ),
                  onVerticalDragUpdate: (DragUpdateDetails details) {
                    if (details.delta.dy > 0) Navigator.of(context).pop();
                  },
                ),
              ),
              const Positioned(
                  left: 10.0, top: 40.0, child: NoorCloseButton(size: 35)),
            ],
          ),
          Consumer<ThemeModel>(
            builder: (_, ThemeModel theme, __) {
              return Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 15.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  children: <Ad3yahTitleCard>[
                    Ad3yahTitleCard(
                      title: Titles.quraan,
                      icon: theme.images.quraanTitleIcon,
                      category: NoorCategory.quraan,
                    ),
                    Ad3yahTitleCard(
                      title: Titles.sunnah,
                      icon: theme.images.sunnahTitleIcon,
                      category: NoorCategory.sunnah,
                    ),
                    Ad3yahTitleCard(
                      title: Titles.ruqya,
                      icon: theme.images.ruqyaTitleIcon,
                      category: NoorCategory.ruqiya,
                    ),
                    Ad3yahTitleCard(
                      title: Titles.myAd3yah,
                      icon: theme.images.myAd3yahTitleIcon,
                      category: NoorCategory.myad3yah,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Ad3yahTitleCard extends StatelessWidget {
  const Ad3yahTitleCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.category,
  }) : super(key: key);

  final String icon;
  final String title;
  final NoorCategory category;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      icon: icon,
      title: title,
      onTap: () {
        if (category == NoorCategory.myad3yah) {
          Navigator.of(context).push(
            MaterialPageRoute<MyAd3yah>(
              builder: (_) => const MyAd3yah(),
              fullscreenDialog: true,
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute<Ad3yahList>(
              builder: (_) => Ad3yahList(category: category),
              fullscreenDialog: true,
            ),
          );
        }
      },
    );
  }
}
