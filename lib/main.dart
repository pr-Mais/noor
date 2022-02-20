import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:noor/app/app.dart';
import 'package:noor/exports/controllers.dart' show DataController;
import 'package:noor/exports/models.dart' show DataModel;
import 'package:noor/exports/services.dart'
    show DBService, SharedPrefsService, FCMService;
import 'package:noor/exports/models.dart' show SettingsModel;
import 'package:noor/pages/tabs/page_3_counter/counter_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await SharedPrefsService.getInstance();
  await FCMService.instance.init();
  await DBService.db.initDB();

  GetIt.I.registerSingleton<DataModel>(DataModel());
  GetIt.I.registerSingleton<SettingsModel>(SettingsModel());
  GetIt.I.registerSingletonAsync<DataController>(() => DataController.init());
  GetIt.I
      .registerSingletonAsync<CounterViewModel>(() => CounterViewModel.init());

  runApp(const NoorApp());
}
