import 'package:flutter/material.dart';
import 'package:noor/pages/tabs/1_home/ad3yah_expanded.dart';
import 'package:noor/pages/tabs/1_home/allah_names_expanded.dart';
import 'package:noor/pages/tabs/1_home/athkar_expanded.dart';
import 'package:noor/pages/tabs/1_home/my_ad3yah.dart';
import 'package:noor/providers/data_provider.dart';
import 'package:provider/provider.dart';

backToLocation(item, BuildContext context) async {
  final provider = Provider.of<DataProvider>(context, listen: false);

  List tmpList = provider.list.where((element) => element.section == item.section).toList();
  final index = tmpList.indexWhere((element) => element == item);
  print(item.section);

  switch (item.section) {
    case 1:
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AthkarList(
            index: index,
          ),
        ),
      );
      break;
    case 5:
      tmpList = tmpList.reversed.toList();
      final int index = tmpList.indexWhere((dynamic element) => element == item);

      Navigator.of(context).push(
        MaterialPageRoute<MyAd3yah>(
          builder: (context) => MyAd3yah(
            index: index,
          ),
        ),
      );
      break;
    case 6:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AllahNamesList(
          index: index,
        ),
      ));
      break;
    default:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Ad3yahList(
          index: index,
          section: item.section - 2,
        ),
      ));
  }
}
