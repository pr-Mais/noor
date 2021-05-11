import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:noor/components/close_button.dart';
import 'package:noor/components/list_item.dart';
import 'package:noor/constants/images.dart';
import 'package:noor/models/data.dart';
import 'package:noor/models/thekr.dart';
import 'package:noor/pages/tabs/1_home/athkar_expanded.dart';
import 'package:noor/providers/data_controller.dart';
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
    final Images images = context.read<ThemeProvider>().images;

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
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  if (details.delta.dy > 0) Navigator.of(context).pop();
                },
              ),
            ),
            Positioned(left: 10.0, top: 40.0, child: NoorCloseButton(size: 35)),
          ],
        ),
        Expanded(
          child: NotificationListener<Notification>(
            child: Consumer<DataModel>(
              builder: (_, DataModel model, __) {
                final List<Thekr> athkarTitles = model.athkar.where((Thekr thekr) => thekr.isTitle).toList();

                return ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: athkarTitles.where((Thekr thekr) => thekr.isTitle).length,
                  controller: scrollController,
                  padding: EdgeInsets.only(top: 10),
                  itemBuilder: (BuildContext context, int index) {
                    final Thekr title = athkarTitles[index];
                    final int position = model.athkar.indexOf(title);

                    return title.isTitle
                        ? ListItem(
                            title: '${title.text}',
                            icon: images.athkar,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<AthkarList>(
                                  builder: (_) => AthkarList(index: position),
                                ),
                              );
                            },
                          )
                        : Container();
                  },
                );
              },
            ),
            onNotification: (_) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (currentScroll < 100) {
                  controller.forward();
                }
                if (currentScroll == 0) {
                  controller.reverse();
                }
              });

              return true;
            },
          ),
        ),
      ],
    ));
  }
}
