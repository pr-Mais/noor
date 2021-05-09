import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:noor/models/allah_name.dart';
import 'package:noor/models/doaa.dart';
import 'package:noor/models/thekr.dart';
import 'package:noor/services/db.dart';
import 'package:noor/services/prefs.dart';
import 'package:noor/services/json.dart';

class DataProvider extends ChangeNotifier {
  DataProvider._(this.list, this.favList);

  List<dynamic> list;
  List<dynamic> favList;

  static Future<DataProvider> init() async {
    final service = await JsonService().init();
    final json = service.file;

    final List<dynamic> _list = [];
    final List<dynamic> _favList = [];

    if (_list.isEmpty) {
      //add الأذكار
      json['athkar'].forEach((k, v) {
        final title = Thekr(
          isTitle: true,
          text: k,
          sectionName: k,
        );
        _list.add(title);
        v.forEach((value) {
          _list.add(Thekr.fromMap(value, sectionName: k));
        });
      });

      int index = 2;

      //add الأدعية
      json['ad3yah'].forEach((k, v) {
        v.forEach((value) {
          _list.add(Doaa.fromMap(value, sectionName: k, section: index));
        });
        index++;
      });

      //add أسماء الله
      json['allah names'].forEach((v) {
        _list.add(AllahName.fromMap(v));
      });

      //add أدعيتي
      final myAd3yah = await DBService.db.get();

      _list.addAll(myAd3yah);

      //check favorite items

      List<String> x = SharedPrefsUtil.getStringList('fav') ?? <String>[];

      for (String id in x) {
        dynamic favItem;

        if (!_list.any((element) => element.id == id)) continue;

        favItem = _list.firstWhere((element) => element.id == id);

        favItem.isFav = 1;
        if (!_favList.contains(favItem)) {
          _favList.add(favItem);
        }
      }
    }

    return DataProvider._(_list, _favList);
  }

  updateMyAd3yahList(tmpFrom, tmpTo) async {
    await DBService.db.swap(tmpFrom, tmpTo);

    final myAd3yah = await DBService.db.get();

    list.removeWhere((dynamic element) => element.section == 5);
    list.addAll(myAd3yah);

    notifyListeners();
  }

  void addToFav(dynamic element) async {
    element.isFav = 1;

    List<String> fav = List<String>.from(SharedPrefsUtil.getStringList('fav')) ?? <String>[];

    if (!fav.contains(element.id)) {
      fav.add(element.id);
    }

    SharedPrefsUtil.putStringList('fav', fav);
    favList.insert(0, element);

    notifyListeners();
  }

  void removeFromFav(dynamic element) async {
    element.isFav = 0;

    final List<String> fav = List<String>.from(SharedPrefsUtil.getStringList('fav')) ?? [];
    fav.remove(element.id);
    SharedPrefsUtil.putStringList('fav', fav);

    favList.remove(element);

    notifyListeners();
  }

  void swapFav(from, to) async {
    log('${favList[from].text} => ${favList[to].text}', name: 'swapFav');

    final fromCard = favList[from];
    final toCard = favList[to];

    favList[to] = fromCard;
    favList[from] = toCard;

    final List<String> ids = favList.map((e) => e.id).toList().cast<String>();

    SharedPrefsUtil.putStringList('fav', ids);
    notifyListeners();
  }

  void insert(Doaa doaa) async {
    DBService.db.insert(doaa);

    list.add(doaa);
    notifyListeners();
  }

  void update(Doaa doaa) async {
    DBService.db.update(doaa);

    final int index = list.indexOf(doaa);
    list[index] = doaa;

    notifyListeners();
  }

  void remove(Doaa doaa) async {
    DBService.db.delete(doaa);

    final index = list.indexWhere((e) => e == doaa);
    list.remove(doaa);
    favList.remove(doaa);

    //cleaning fav list
    List<String> fav = SharedPrefsUtil.getStringList('fav');
    fav.remove(index.toString());
    SharedPrefsUtil.putStringList('fav', fav);

    notifyListeners();
  }
}
