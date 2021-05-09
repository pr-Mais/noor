import 'dart:convert';

import 'package:flutter/services.dart';

class JsonService {
  var _x;
  Future<JsonService> init() async {
    _x = json.decode(await _loadFromAsset());
    return this;
  }

  Future<String> _loadFromAsset() async {
    return await rootBundle.loadString('assets/noor-data/data.json');
  }

  get file => _x;
}
