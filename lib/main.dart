import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:noor/app/app.dart';
import 'package:noor/exports/controllers.dart';
import 'package:noor/models/data.dart';
import 'package:noor/services/db.dart';
import 'package:noor/services/fcm.dart';
import 'package:noor/services/prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefsUtil.getInstance();
  await FCMService.instance.init();
  await DBService.db.initDB();

  GetIt.I.registerSingleton<DataModel>(DataModel());
  GetIt.I.registerSingletonAsync<DataController>(() => DataController.init());

  runApp(NoorApp());
}
