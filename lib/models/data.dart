import 'package:flutter/material.dart';
import 'package:noor/models/allah_name.dart';
import 'package:noor/models/doaa.dart';
import 'package:noor/models/thekr.dart';

class DataModel extends ChangeNotifier {
  List<Thekr> _athkar = <Thekr>[];
  List<Doaa> _quraan = <Doaa>[];
  List<Doaa> _sunnah = <Doaa>[];
  List<Doaa> _ruqiya = <Doaa>[];
  List<Doaa> _myAd3yah = <Doaa>[];
  List<AllahName> _allahNames = <AllahName>[];

  List<dynamic> _favList = <dynamic>[];

  set athkar(List<Thekr> value) {
    _athkar = value;
    notifyListeners();
  }

  List<Thekr> get athkar => _athkar;

  set quraan(List<Doaa> value) {
    _quraan = value;
    notifyListeners();
  }

  List<Doaa> get quraan => _quraan;

  set sunnah(List<Doaa> value) {
    _sunnah = value;
    notifyListeners();
  }

  List<Doaa> get sunnah => _sunnah;

  set ruqiya(List<Doaa> value) {
    _ruqiya = value;
    notifyListeners();
  }

  List<Doaa> get ruqiya => _ruqiya;

  set myAd3yah(List<Doaa> value) {
    _myAd3yah = value;
    notifyListeners();
  }

  List<Doaa> get myAd3yah => _myAd3yah;

  set allahNames(List<AllahName> value) {
    _allahNames = value;
    notifyListeners();
  }

  List<AllahName> get allahNames => _allahNames;

  set favList(List<dynamic> value) {
    _favList = value;
    notifyListeners();
  }

  List<dynamic> get favList => _favList;
}
