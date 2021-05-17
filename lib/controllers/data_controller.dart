import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:noor/constants/categories.dart';
import 'package:noor/constants/ribbons.dart';
import 'package:noor/exports/models.dart'
    show DataModel, Doaa, Thekr, AllahName;
import 'package:noor/exports/services.dart'
    show DBService, SharedPrefsService, JsonService;

class DataController {
  static Future<DataController> init() async {
    final List<dynamic> data = await JsonService.init();
    final DataModel dataModel = GetIt.I<DataModel>();
    if (dataModel.athkar.isEmpty) {
      int section = 0;

      //add الأذكار
      data[0].forEach((String k, dynamic v) {
        final Thekr title = Thekr.fromMap(
          <String, dynamic>{
            'text': k,
            'isTitle': true,
            'sectionName': k,
            'section': section,
          },
        );

        dataModel.athkar = <Thekr>[...dataModel.athkar, title];

        v.forEach((dynamic value) {
          value['sectionName'] = k;
          value['section'] = section;

          dataModel.athkar = <Thekr>[...dataModel.athkar, Thekr.fromMap(value)];
        });

        section++;
      });
    }

    //add الأدعية

    if (dataModel.quraan.isEmpty) {
      dataModel.quraan = data[1]
          .map((dynamic e) {
            e['category'] = NoorCategory.QURAAN;
            e['ribbon'] = Ribbon.ribbon2;
            e['sectionName'] = categoryTitle[NoorCategory.QURAAN];

            return Doaa.fromMap(e);
          })
          .toList()
          .cast<Doaa>();
    }
    if (dataModel.sunnah.isEmpty) {
      dataModel.sunnah = data[2]
          .map((dynamic e) {
            e['category'] = NoorCategory.SUNNAH;
            e['ribbon'] = Ribbon.ribbon3;
            e['sectionName'] = categoryTitle[NoorCategory.SUNNAH];

            return Doaa.fromMap(e);
          })
          .toList()
          .cast<Doaa>();
    }
    if (dataModel.ruqiya.isEmpty) {
      dataModel.ruqiya = data[3]
          .map((dynamic e) {
            e['ribbon'] = Ribbon.ribbon4;
            e['category'] = NoorCategory.RUQIYA;
            e['sectionName'] = categoryTitle[NoorCategory.RUQIYA];

            return Doaa.fromMap(e);
          })
          .toList()
          .cast<Doaa>();
    }

    //add أسماء الله
    if (dataModel.allahNames.isEmpty) {
      dataModel.allahNames = data[4]
          .map((dynamic e) {
            e['ribbon'] = Ribbon.ribbon6;
            return AllahName.fromMap(e);
          })
          .toList()
          .cast<AllahName>();
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
    List<String> favPrefs = SharedPrefsService.getStringList('fav');

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

      favItem.isFav = true;

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

    List<String?> favPrefs = SharedPrefsService.getStringList('fav');

    int iFrom = favPrefs.indexOf(tmpFrom.id);
    int iTo = favPrefs.indexOf(tmpTo.id);

    if (tmpFrom.isFav) {
      favPrefs[iFrom] = tmpTo.id;
    }

    if (tmpTo.isFav) {
      favPrefs[iTo] = tmpFrom.id;
    }

    SharedPrefsService.putStringList('fav', favPrefs);

    updateFavList();
  }

  void addToFav(dynamic element) async {
    element.isFav = true;

    List<String?> favPrefs =
        List<String>.from(SharedPrefsService.getStringList('fav'));

    if (!favPrefs.contains(element.id)) {
      favPrefs.insert(0, element.id);
    }

    // Update underlying fav prefs list for persistency
    SharedPrefsService.putStringList('fav', favPrefs);

    updateFavList();
  }

  void removeFromFav(dynamic element) async {
    element.isFav = false;

    final List<String> favPrefs =
        List<String>.from(SharedPrefsService.getStringList('fav'));
    favPrefs.remove(element.id);

    // Update underlying fav prefs list for persistency
    SharedPrefsService.putStringList('fav', favPrefs);

    // Update underlying data model
    updateFavList();
  }

  void swapFav(int from, int to) async {
    List<String?> favPrefs = SharedPrefsService.getStringList('fav');

    // Swap IDs
    favPrefs.removeAt(from);
    favPrefs.insert(to, GetIt.I<DataModel>().favList[from].id);

    // Update user prefs list
    SharedPrefsService.putStringList('fav', favPrefs);

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
    List<String> favList = SharedPrefsService.getStringList('fav');
    favList.remove(doaa.id);
    SharedPrefsService.putStringList('fav', favList);

    updateFavList();
  }
}
