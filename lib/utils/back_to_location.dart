import 'package:flutter/material.dart';
import 'package:noor/models/data.dart';
import 'package:noor/pages/tabs/1_home/ad3yah_expanded.dart';
import 'package:noor/pages/tabs/1_home/allah_names_expanded.dart';
import 'package:noor/pages/tabs/1_home/athkar_expanded.dart';
import 'package:noor/pages/tabs/1_home/my_ad3yah.dart';
import 'package:provider/provider.dart';

backToLocation(dynamic item, BuildContext context) async {
  final DataModel dataModel = Provider.of<DataModel>(context, listen: false);
  final List<dynamic> allLists = List<dynamic>.from(<dynamic>[
    ...dataModel.athkar,
    ...dataModel.quraan,
    ...dataModel.sunnah,
    ...dataModel.ruqiya,
    ...dataModel.myAd3yah,
    ...dataModel.allahNames,
  ]);
  List<dynamic> tmpList = allLists.where((dynamic element) => element.section == item.section).toList();
  final int index = tmpList.indexWhere((dynamic element) => element == item);
  print(item.section);

  switch (item.section) {
    case 1:
      Navigator.of(context).push(
        MaterialPageRoute<AthkarList>(
          builder: (_) => AthkarList(index: index),
        ),
      );
      break;
    case 5:
      final int index = tmpList.indexWhere((dynamic element) => element == item);

      Navigator.of(context).push(
        MaterialPageRoute<MyAd3yah>(
          builder: (_) => MyAd3yah(index: index),
        ),
      );
      break;
    case 6:
      Navigator.of(context).push(
        MaterialPageRoute<AllahNamesList>(
          builder: (_) => AllahNamesList(
            index: index,
          ),
        ),
      );
      break;
    default:
      Navigator.of(context).push(
        MaterialPageRoute<Ad3yahList>(
          builder: (_) => Ad3yahList(
            index: index,
            section: item.section - 2,
          ),
        ),
      );
  }
}
