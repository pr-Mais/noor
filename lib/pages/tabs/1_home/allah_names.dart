import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:noor/exports/pages.dart' show AllahNamesList;
import 'package:noor/exports/models.dart' show DataModel, AllahName;
import 'package:noor/exports/constants.dart' show Images;
import 'package:noor/exports/controllers.dart' show ThemeProvider;
import 'package:noor/exports/components.dart' show NoorCloseButton, ListItem;

class AllahNames extends StatefulWidget {
  const AllahNames({Key key}) : super(key: key);

  @override
  _AllahNamesState createState() => _AllahNamesState();
}

class _AllahNamesState extends State<AllahNames> with SingleTickerProviderStateMixin {
  ScrollController scrollController = new ScrollController();

  double currentScroll = 0;
  double maxHeight = 180;
  Animation<double> animation;
  AnimationController controller;

  int index = 0;

  initState() {
    super.initState();

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
                  child: Hero(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: maxHeight,
                      child: Image.asset(
                        Theme.of(context).brightness == Brightness.light
                            ? 'assets/home-cards/light/AllahNames.png'
                            : 'assets/home-cards/dark/AllahNames.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    tag: 'allah names',
                  ),
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 0) Navigator.of(context).pop();
                  },
                ),
              ),
              Positioned(
                left: 10.0,
                top: 40.0,
                child: NoorCloseButton(size: 35)
              ),
            ],
          ),
          Consumer<DataModel>(
            builder: (_,DataModel model, __) {
              final List<AllahName> allahNames = model.allahNames;
              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: allahNames.length,
                  controller: scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    final AllahName title = allahNames[index];
                    return ListItem(
                      title: '${title.name}',
                      icon: images.allahNames,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<AllahNamesList>(
                            builder: (_) => AllahNamesList(index: index),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
