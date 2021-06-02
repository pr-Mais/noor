import 'package:flutter/material.dart';
import 'package:noor/constants/images.dart';
import 'package:noor/exports/components.dart' show CardTemplate, CardText;
import 'package:noor/models/data.dart' show DataModel;
import 'package:provider/provider.dart';

class NoorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      ribbon: context.read<DataModel>().athkar[1].ribbon,
      actions: <Widget>[
        Image.asset(Images.outlineHeartIcon),
        Image.asset(Images.copyIcon),
      ],
      child: CardText(text: context.read<DataModel>().athkar[1].text),
    );
  }
}
