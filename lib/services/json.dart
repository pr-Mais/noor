import 'dart:convert';

import 'package:flutter/services.dart';

class JsonService {
  static Future<Map<String, dynamic>> init() async {
    try {
      final String jsonFile = await rootBundle.loadString('assets/noor-data/data.json');
    Map<String, dynamic> decodedJson = json.decode(jsonFile);

    return decodedJson;
    } catch (e) {
      print(e);
    }
  }
}