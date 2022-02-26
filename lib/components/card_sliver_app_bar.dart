import 'package:flutter/material.dart';

import 'close_button.dart';

class CardSliverAppBar extends StatelessWidget {
  const CardSliverAppBar({
    Key? key,
    required this.cardImagePath,
  }) : super(key: key);
  final String cardImagePath;
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 10),
      sliver: SliverAppBar(
        floating: true,
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          stretchModes: const <StretchMode>[
            StretchMode.zoomBackground,
            //StretchMode.blurBackground,
          ],
          background: Image.asset(
            cardImagePath,
            fit: BoxFit.cover,
          ),
        ),
        actions: const [
          NoorCloseButton(size: 40),
        ],
        backgroundColor: Theme.of(context).canvasColor,
        onStretchTrigger: () async {},
        stretchTriggerOffset: 200,
        collapsedHeight: 140,
        expandedHeight: 140,
      ),
    );
  }
}
