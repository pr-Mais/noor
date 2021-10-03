import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:noor/exports/components.dart' show BottomNav;
import 'package:noor/exports/pages.dart'
    show Home, Favorite, CounterView, Settings, AthkarList;

class RootHome extends StatefulWidget {
  RootHome({Key? key}) : super(key: key);

  _RootHomeState createState() => _RootHomeState();
}

class _RootHomeState extends State<RootHome>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  String? payload;
  @override
  void initState() {
    super.initState();

    AndroidInitializationSettings initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_notification');
    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> onSelectNotification(String? payload) async {
    setState(() {
      this.payload = payload;
    });
    print(payload);
    Navigator.push(
      context,
      new MaterialPageRoute<AthkarList>(
        builder: (BuildContext context) => new AthkarList(
          index: payload == 'الصباح' ? 0 : 26,
        ),
      ),
    );
  }

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(
        onTap: (int index) {
          controller.jumpToPage(index);
        },
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: <Widget>[
          Home(),
          Favorite(),
          CounterView(),
          Settings(),
        ],
      ),
    );
  }
}
