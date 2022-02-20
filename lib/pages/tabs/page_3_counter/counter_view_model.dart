import 'dart:convert';
import 'package:collection/collection.dart';

import 'package:flutter/foundation.dart';

import 'package:noor/exports/services.dart' show SharedPrefsService;
import 'package:noor/services/json.dart';

class CounterViewModel extends ChangeNotifier {
  CounterViewModel._(this._subhaList, this._selectedItem);

  static Future<CounterViewModel> init() async {
    List<SubhaItem> _subhaList = SharedPrefsService.getStringList('subha')
        .map((String e) => SubhaItem.fromJson(json.decode(e)))
        .toList()
        .cast<SubhaItem>();

    final List<String> _default =
        await JsonService.instance.loadDefaultSubhaList();

    // Check in case the stored Subha list doesn't have equal keys to the default Json list.
    final List<String> temp =
        _subhaList.where((item) => item.locked).map((e) => e.key).toList();

    bool missingDefault =
        !const IterableEquality().equals(temp, _default.toList());

    // Read from the default Json list if it's missing from prefs
    if (_subhaList.isEmpty || missingDefault) {
      final _mappedDefault = _default
          .map((item) => SubhaItem(
                counter: _subhaList.map((e) => e.key).contains(item)
                    ? _subhaList.firstWhere((e) => e.key == item).counter
                    : 0,
                key: item,
                selected: _subhaList.map((e) => e.key).contains(item)
                    ? _subhaList.firstWhere((e) => e.key == item).selected
                    : false,
                locked: true,
              ))
          .toList();

      _subhaList.removeWhere((item) => item.locked);
      _subhaList.addAll(_mappedDefault);

      if (!_subhaList.any((element) => element.selected)) {
        // If none in the final list is selected, default to select the first item.
        _subhaList[0].selected = true;
      }

      // Finally make sure to update the stored list again.
      SharedPrefsService.putStringList(
        'subha',
        _subhaList
            .map((SubhaItem e) => json.encode(e.toJson()))
            .toList()
            .cast<String>(),
      );
    }

    // Set the selected item.
    final _selectedItem =
        _subhaList.firstWhere((SubhaItem item) => item.selected);

    return CounterViewModel._(_subhaList, _selectedItem);
  }

  SubhaItem? _selectedItem;
  SubhaItem? get selectedItem => _selectedItem;
  set setSelectedItem(SubhaItem item) {
    // Clear all selections.
    for (var item in _subhaList) {
      item.setSelected = false;
    }

    _selectedItem = item;
    _selectedItem!.setSelected = true;

    setSubhaList = _subhaList;

    notifyListeners();
  }

  incrementSelectedItem() {
    _selectedItem!.setCounter = ++_selectedItem!.counter;
    setSubhaList = _subhaList;
  }

  resetSelectedItemCounter() {
    _selectedItem!.setCounter = 0;
    setSubhaList = _subhaList;
  }

  late List<SubhaItem> _subhaList;
  List<SubhaItem> get subhaList => _subhaList;
  set setSubhaList(List<SubhaItem> list) {
    _subhaList = list;

    SharedPrefsService.putStringList(
      'subha',
      _subhaList
          .map((SubhaItem e) => json.encode(e.toJson()))
          .toList()
          .cast<String>(),
    );
    notifyListeners();
  }

  void addSubhaItem(SubhaItem item) {
    _subhaList.insert(0, item);

    setSubhaList = _subhaList;

    notifyListeners();
  }

  void deleteSubhaItem(SubhaItem item) {
    _subhaList.remove(item);
    if (item.selected) {
      _selectedItem = _subhaList.first;
      _selectedItem!.setSelected = true;
    }

    setSubhaList = _subhaList;

    notifyListeners();
  }
}

class SubhaItem extends ChangeNotifier {
  int counter;
  String key;
  bool selected;
  bool locked;

  set setCounter(int c) {
    counter = c;

    notifyListeners();
  }

  set setSelected(bool value) {
    selected = value;

    notifyListeners();
  }

  SubhaItem({
    required this.counter,
    required this.key,
    required this.selected,
    this.locked = false,
  });

  toJson() {
    return <String, dynamic>{
      'counter': counter,
      'key': key,
      'selected': selected,
      'locked': locked,
    };
  }

  static fromJson(Map<String, dynamic> json) {
    return SubhaItem(
      counter: json['counter'],
      key: json['key'],
      selected: json['selected'],
      locked: json['locked'],
    );
  }
}
