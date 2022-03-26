import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:noor/exports/pages.dart' show AllahNamesList;
import 'package:noor/exports/models.dart' show DataModel, AllahName;
import 'package:noor/exports/constants.dart' show Images;
import 'package:noor/exports/controllers.dart' show ThemeModel;
import 'package:noor/exports/components.dart' show CardSliverAppBar, ListItem;

class AllahNames extends StatefulWidget {
  const AllahNames({Key? key}) : super(key: key);

  @override
  _AllahNamesState createState() => _AllahNamesState();
}

class _AllahNamesState extends State<AllahNames>
    with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();

  double maxHeight = 180;

  int index = 0;

  @override
  Widget build(BuildContext context) {
    final Images images = context.read<ThemeModel>().images;
    final DataModel model = Provider.of<DataModel>(context);
    final List<AllahName> allahNames = model.allahNames;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CardSliverAppBar(cardImagePath: images.allahNamesCard),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final AllahName title = allahNames[index];
                return ListItem(
                  title: title.name,
                  icon: images.allahNamesTitleIcon,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<AllahNamesList>(
                        builder: (_) => AllahNamesList(index: index),
                      ),
                    );
                  },
                );
              },
              childCount: allahNames.length,
            ),
          )
        ],
      ),
    );
  }
}
