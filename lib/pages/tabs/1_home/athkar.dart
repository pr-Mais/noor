import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:noor/components/close_button.dart';
import 'package:noor/components/list_item.dart';
import 'package:noor/models/thekr.dart';
import 'package:noor/pages/tabs/1_home/athkar_expanded.dart';
import 'package:noor/providers/data_provider.dart';
import 'package:noor/providers/theme_provider.dart';
import 'package:noor/services/db.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/settings_provider.dart';

class AthkarPage extends StatefulWidget {
  const AthkarPage();
  _AthkarPageState createState() => _AthkarPageState();
}

class _AthkarPageState extends State<AthkarPage> with SingleTickerProviderStateMixin {
  ScrollController scrollController = new ScrollController();
  double currentScroll = 0;
  double maxHeight = 180;
  Animation animation;
  AnimationController controller;

  initState() {
    super.initState();
    DBService.db.initDB();
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
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
    final images = Provider.of<ThemeProvider>(context, listen: false).images;

    return Scaffold(
        body: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned(
              child: GestureDetector(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: maxHeight,
                  child: Hero(
                    tag: 'athkar',
                    child: Image.asset(
                      images.athkarCard,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0) Navigator.of(context).pop();
                },
              ),
            ),
            Positioned(left: 10.0, top: 40.0, child: NoorCloseButton(size: 35)),
          ],
        ),
        Expanded(
          child: NotificationListener(
            child: Consumer<DataProvider>(
              builder: (context, provider, child) {
                final athkarTitles = provider.list.where((element) => element.runtimeType == Thekr).toList();
                return ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: athkarTitles.length,
                  controller: scrollController,
                  padding: EdgeInsets.only(top: 10),
                  itemBuilder: (context, index) {
                    final title = athkarTitles[index];
                    return title.isTitle
                        ? ListItem(
                            title: '${title.text}',
                            icon: images.athkar,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AthkarList(index: index),
                                ),
                              );
                            },
                          )
                        : Container();
                  },
                );
              },
            ),
            onNotification: (t) {
              WidgetsBinding.instance.addPostFrameCallback((t) {
                if (currentScroll < 100) {
                  controller.forward();
                }
                if (currentScroll == 0) {
                  controller.reverse();
                }
              });
            },
          ),
        ),
      ],
    ));
  }
}
