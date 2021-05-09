import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:noor/components/close_button.dart';
import 'package:noor/components/list_item.dart';
import 'package:noor/constants/titles.dart';
import 'package:noor/pages/tabs/1_home/ad3yah_expanded.dart';
import 'package:noor/pages/tabs/1_home/my_ad3yah.dart';
import 'package:noor/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class Ad3yah extends StatefulWidget {
  const Ad3yah();
  _Ad3yahState createState() => _Ad3yahState();
}

class _Ad3yahState extends State<Ad3yah> with SingleTickerProviderStateMixin {
  ScrollController scrollController = new ScrollController();
  int index = 0;
  double currentScroll = 0;
  double maxHeight = 180;
  Animation<double> animation;
  AnimationController controller;

  initState() {
    super.initState();

    controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
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
                        Theme.of(context).brightness == Brightness.light
                            ? 'assets/home-cards/light/Ad3yah.png'
                            : 'assets/home-cards/dark/Ad3yah.png',
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
              Positioned(left: 10.0, top: 40.0, child: NoorCloseButton(size: 35)),
            ],
          ),
          Consumer<ThemeProvider>(
            builder: (_, ThemeProvider theme, __) {
              return Expanded(
                child: ListView(
                  padding: EdgeInsets.only(top: 15.0),
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  children: <Ad3yahTitleCard>[
                    Ad3yahTitleCard(
                      title: Titles.quraan,
                      icon: theme.images.quraan,
                      section: 0,
                    ),
                    Ad3yahTitleCard(
                      title: Titles.sunnah,
                      icon: theme.images.sunnah,
                      section: 1,
                    ),
                    Ad3yahTitleCard(
                      title: Titles.ruqya,
                      icon: theme.images.ruqya,
                      section: 2,
                    ),
                    Ad3yahTitleCard(
                      title: Titles.myAd3yah,
                      icon: theme.images.myAd3yah,
                      section: 3,
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
  const Ad3yahTitleCard({Key key, @required this.icon, @required this.title, @required this.section}) : super(key: key);

  final String icon;
  final String title;
  final int section;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      icon: icon,
      title: title,
      onTap: () {
        if (section == 3) {
          Navigator.of(context).push(
            MaterialPageRoute<MyAd3yah>(
              builder: (_) => MyAd3yah(),
              fullscreenDialog: true,
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute<Ad3yahList>(
              builder: (_) => Ad3yahList(section: section),
              fullscreenDialog: true,
            ),
          );
        }
      },
    );
  }
}
