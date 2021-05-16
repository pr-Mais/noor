import 'dart:convert';

import 'package:flutter/services.dart';

class JsonService {
  static Future<List<dynamic>> init() async {
    List<String> _files = <String>[
      'assets/json/1_athkar.json',
      'assets/json/2_quraan_ad3yah.json',
      'assets/json/3_sunnah_ad3yah.json',
      'assets/json/4_ruqiya.json',
      'assets/json/6_allah_names.json',
    ];
    final List<dynamic> _content = <dynamic>[];
    for (String f in _files) {
      final String load = await rootBundle.loadString(f);
      final dynamic decode = json.decode(load);

      _content.add(decode);
    }

    return _content;
  }
}
