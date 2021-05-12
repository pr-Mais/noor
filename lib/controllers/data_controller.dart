import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:noor/exports/models.dart' show DataModel, Doaa, Thekr, AllahName;
import 'package:noor/exports/services.dart' show DBService, SharedPrefsUtil, JsonService;

class DataController {
  static Future<DataController> init() async {
    final Map<String, dynamic> json = await JsonService.init();
    final DataModel dataModel = GetIt.I<DataModel>();
    if (dataModel.athkar.isEmpty) {
      //add الأذكار
      json['athkar'].forEach((String k, dynamic v) {
        final Thekr title = Thekr(
          isTitle: true,
          text: k,
          sectionName: k,
        );
        dataModel.athkar = <Thekr>[...dataModel.athkar, title];

        v.forEach((value) {
          value['section'] = 1;
          value['sectionName'] = k;
          dataModel.athkar = <Thekr>[...dataModel.athkar, Thekr.fromMap(value)];
        });
      });
    }

    int index = 2;

    List<dynamic> tmpQuraan = <dynamic>[];
    List<dynamic> tmpSunnah = <dynamic>[];
    List<dynamic> tmpRuqiya = <dynamic>[];

    //add الأدعية
    json['ad3yah'].forEach((String k, dynamic v) {
      if (index == 2) {
        tmpQuraan = v.map((e) {
          e['section'] = index;
          e['sectionName'] = k;

          return e;
        }).toList();
      } else if (index == 3) {
        tmpSunnah = v.map((e) {
          e['section'] = index;
          e['sectionName'] = k;

          return e;
        }).toList();
      } else if (index == 4) {
        tmpRuqiya = v.map((e) {
          e['section'] = index;
          e['sectionName'] = k;

          return e;
        }).toList();
      }

      index++;
    });
    if (dataModel.quraan.isEmpty) {
      dataModel.quraan = tmpQuraan.map((dynamic e) => Doaa.fromMap(e)).toList().cast<Doaa>();
    }
    if (dataModel.sunnah.isEmpty) {
      dataModel.sunnah = tmpSunnah.map((dynamic e) => Doaa.fromMap(e)).toList().cast<Doaa>();
    }
    if (dataModel.ruqiya.isEmpty) {
      dataModel.ruqiya = tmpRuqiya.map((dynamic e) => Doaa.fromMap(e)).toList().cast<Doaa>();
    }

    //add أسماء الله
    if (dataModel.allahNames.isEmpty) {
      json['allah names'].forEach((dynamic v) {
        dataModel.allahNames = <AllahName>[...dataModel.allahNames, AllahName.fromMap(v)];
      });
    }

    //add أدعيتي
    final List<Doaa> myAd3yah = await DBService.db.get();

    if (dataModel.myAd3yah.isEmpty) {
      dataModel.myAd3yah = myAd3yah.cast<Doaa>();
    }

    //check favorite items
    if (dataModel.favList.isEmpty) {
      updateFavList();
    }

    await Future<void>.delayed(Duration(seconds: 1));

    return DataController();
  }

  static void updateFavList() {
    final DataModel dataModel = GetIt.I<DataModel>();
    List<String> favPrefs = SharedPrefsUtil.getStringList('fav') ?? <String>[];

    final List<dynamic> allLists = List<dynamic>.from(<dynamic>[
      ...dataModel.athkar.where((Thekr thekr) => !thekr.isTitle).toList(),
      ...dataModel.quraan,
      ...dataModel.sunnah,
      ...dataModel.ruqiya,
      ...dataModel.myAd3yah,
      ...dataModel.allahNames,
    ]);

    List<dynamic> _favList = <dynamic>[];

    for (String id in favPrefs) {
      dynamic favItem;

      if (!allLists.any((dynamic element) => element.id == id)) continue;

      favItem = allLists.firstWhere((dynamic element) => element.id == id);

      favItem.isFav = 1;

      if (!_favList.contains(favItem)) {
        _favList.add(favItem);
      }
    }

    dataModel.favList = _favList;
  }

  updateMyAd3yahList(int from, int to) async {
    final DataModel dataModel = GetIt.I<DataModel>();

    final Doaa tmpFrom = dataModel.myAd3yah[from];
    final Doaa tmpTo = dataModel.myAd3yah[to];

    await DBService.db.swap(tmpFrom, tmpTo);
    dataModel.myAd3yah = await DBService.db.get();

    List<String> favPrefs = SharedPrefsUtil.getStringList('fav') ?? <String>[];

    int iFrom = favPrefs.indexOf(tmpFrom.id);
    int iTo = favPrefs.indexOf(tmpTo.id);

    if (tmpFrom.isFav == 1) {
      favPrefs[iFrom] = tmpTo.id;
    }

    if (tmpTo.isFav == 1) {
      favPrefs[iTo] = tmpFrom.id;
    }

    SharedPrefsUtil.putStringList('fav', favPrefs);

    updateFavList();
  }

  void addToFav(dynamic element) async {
    element.isFav = 1;

    List<String> favPrefs = List<String>.from(SharedPrefsUtil.getStringList('fav')) ?? <String>[];

    if (!favPrefs.contains(element.id)) {
      favPrefs.insert(0, element.id);
    }

    // Update underlying fav prefs list for persistency
    SharedPrefsUtil.putStringList('fav', favPrefs);

    updateFavList();
  }

  void removeFromFav(dynamic element) async {
    element.isFav = 0;

    final List<String> favPrefs = List<String>.from(SharedPrefsUtil.getStringList('fav')) ?? <String>[];
    favPrefs.remove(element.id);

    // Update underlying fav prefs list for persistency
    SharedPrefsUtil.putStringList('fav', favPrefs);

    // Update underlying data model
    updateFavList();
  }

  void swapFav(int from, int to) async {
    List<String> favPrefs = SharedPrefsUtil.getStringList('fav') ?? <String>[];

    // Swap IDs
    favPrefs.removeAt(from);
    favPrefs.insert(to, GetIt.I<DataModel>().favList[from].id);

    // Update user prefs list
    SharedPrefsUtil.putStringList('fav', favPrefs);

    // Update underlying data model to rebuild
    updateFavList();
  }

  void insert(Doaa doaa) async {
    DBService.db.insert(doaa);

    GetIt.I<DataModel>().myAd3yah = await DBService.db.get();
  }

  void update(Doaa doaa) async {
    DBService.db.update(doaa);

    GetIt.I<DataModel>().myAd3yah = await DBService.db.get();
  }

  void remove(Doaa doaa) async {
    DBService.db.delete(doaa);
    GetIt.I<DataModel>().myAd3yah = await DBService.db.get();

    //cleaning fav list
    List<String> favList = SharedPrefsUtil.getStringList('fav');
    favList.remove(doaa.id);
    SharedPrefsUtil.putStringList('fav', favList);

    updateFavList();
  }
}
