import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:noor/exports/services.dart' show SharedPrefsService;
import 'package:noor/services/json.dart';

class CounterModel extends ChangeNotifier {
  CounterModel.init() {
    loadDefaultIfMissing();
  }

  void loadDefaultIfMissing() async {
    List<String> storedList =
        SharedPrefsService.getStringList('subha').cast<String>();
    _subhaList = storedList
        .map((String e) => SubhaItem.fromJson(json.decode(e)))
        .toList()
        .cast<SubhaItem>();

    // Read from the default Json list if it's missing from prefs
    if (_subhaList.isEmpty) {
      final List<String> _default =
          await JsonService.instance.loadDefaultSubhaList();

      final _mappedDefault = _default
          .map((item) => SubhaItem(counter: 0, key: item, selected: false))
          .toList()
          .cast<SubhaItem>();

      // default to select the first item
      _mappedDefault[0].selected = true;
      setSubhaList = _mappedDefault;
    }

    // set the selected item
    _selectedItem = _subhaList.firstWhere((SubhaItem item) => item.selected);
  }

  late SubhaItem _selectedItem;
  SubhaItem get selectedItem => _selectedItem;
  set setSelectedItem(SubhaItem item) {
    int i = _subhaList.indexOf(_selectedItem);

    _selectedItem = item;
    _subhaList[i] = item;
    setSubhaList = _subhaList;

    notifyListeners();
  }

  late List<SubhaItem> _subhaList;
  List<SubhaItem> get subhaList => _subhaList;
  set setSubhaList(List<SubhaItem> list) {
    _subhaList = list;

    SharedPrefsService.putStringList(
      'subha',
      list
          .map((SubhaItem e) => json.encode(e.toJson()))
          .toList()
          .cast<String>(),
    );
    notifyListeners();
  }
}

class SubhaItem extends ChangeNotifier {
  int counter;
  String key;
  bool selected;

  set setCounter(int c) {
    counter = c;

    notifyListeners();
  }

  SubhaItem({
    required this.counter,
    required this.key,
    required this.selected,
  });

  toJson() {
    return <String, dynamic>{
      'counter': counter,
      'key': key,
      'selected': selected
    };
  }

  static fromJson(Map<String, dynamic> json) {
    return SubhaItem(
      counter: json['counter'],
      key: json['key'],
      selected: json['selected'],
    );
  }
}
