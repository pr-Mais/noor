import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:get_it/get_it.dart';
import 'package:noor/controllers/theme_controller.dart';
import 'package:noor/exports/controllers.dart' show DataController;

class FavAction extends StatefulWidget {
  FavAction(this.item, {Key? key})
      : assert(item.isFav != null),
        super(key: key);
  final dynamic item;

  @override
  _FavActionState createState() => _FavActionState();
}

class _FavActionState extends State<FavAction> {
  @override
  Widget build(BuildContext context) {
    final DataController dataController = GetIt.I<DataController>();
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();

    return GestureDetector(
      onTap: () {
        widget.item.isFav
            ? dataController.removeFromFav(widget.item)
            : dataController.addToFav(widget.item);
      },
      child: AnimatedCrossFade(
        firstChild: Image.asset(themeProvider.images.outlineHeartIcon),
        secondChild: Image.asset(themeProvider.images.filledHeartIcon),
        crossFadeState: widget.item.isFav
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: Duration(milliseconds: 500),
      ),
    );
  }
}
