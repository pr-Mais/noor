import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:noor/exports/controllers.dart' show DataController;
import 'package:noor/exports/constants.dart' show Images;

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

    return GestureDetector(
      onTap: () {
        widget.item.isFav
            ? dataController.removeFromFav(widget.item)
            : dataController.addToFav(widget.item);
      },
      child: AnimatedCrossFade(
        firstChild: Image.asset(Images.outlineHeartIcon),
        secondChild: Image.asset(Images.filledHeartIcon),
        crossFadeState: widget.item.isFav
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }
}
