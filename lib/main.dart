import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:noor/app/app.dart';
import 'package:noor/services/db.dart';
import 'package:noor/services/fcm.dart';
import 'package:noor/services/prefs.dart';
import 'package:noor/providers/data_provider.dart';

void main() async {
  GetIt.I.registerSingletonAsync(() => DataProvider.init());

  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsUtil.getInstance();
  await DBService.db.initDB();
  await FCMService.instance.init();
  runApp(NoorApp());
}


