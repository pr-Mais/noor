import 'package:flutter/material.dart';
import 'package:noor/components/close_button.dart';
import 'package:noor/components/list_item.dart';
import 'package:noor/models/allah_name.dart';
import 'package:noor/pages/tabs/1_home/allah_names_expanded.dart';
import 'package:noor/providers/data_provider.dart';
import 'package:noor/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/images.dart';

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
          Consumer<DataProvider>(
            builder: (_, provider, child) {
              final asmaa = provider.list.where((element) => element.runtimeType == AllahName).toList();
              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: asmaa.length,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    final title = asmaa[index];
                    return ListItem(
                      title: '${title.name}',
                      icon: images.allahNames,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
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
