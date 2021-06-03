import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart' as intl;
import 'package:noor/exports/components.dart'
    show
        SettingsTitle,
        SwitcherOption,
        NotificationTile,
        NotificationSelectableTime;
import 'package:noor/exports/constants.dart' show NoorIcons;
import 'package:noor/exports/controllers.dart' show SettingsModel;
import 'package:noor/exports/services.dart' show FCMService, SharedPrefsService;
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NoorNotifications extends StatefulWidget {
  const NoorNotifications({Key? key}) : super(key: key);

  @override
  _NoorNotificationsState createState() => _NoorNotificationsState();
}

class _NoorNotificationsState extends State<NoorNotifications> {
  var morningNotiEnabled;
  var nightNotiEnabled;
  var morningNotiTime;
  var nightNotiTime;
  var morningTemp;
  var nightTemp;

  String formatTime(DateTime? dateTime) {
    return dateTime == null
        ? 'اختر وقت'
        : intl.DateFormat('h:mm a', 'ar').format(dateTime);
  }

  void setDailyNotification(DateTime dateTime, period, id) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      '$id',
      '$period',
      'repeatDailyAtTime $dateTime',
      showWhen: true,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'أذكار $period',
      '',
      tz.TZDateTime.from(dateTime, tz.local).add(Duration(days: 10000)),
      platformChannelSpecifics,
      payload: period,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  void cancelNotification(int id) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  @override
  void initState() {
    tz.initializeTimeZones();

    morningNotiEnabled = SharedPrefsService.getBool('morningNotiEnabled');
    morningNotiTime = SharedPrefsService.getString('morningNotiTime').isNotEmpty
        ? DateTime.parse(SharedPrefsService.getString('morningNotiTime'))
        : null;
    nightNotiEnabled = SharedPrefsService.getBool('nightNotiEnabled') &&
        SharedPrefsService.getString('nightNotiTime').isNotEmpty;
    nightNotiTime = SharedPrefsService.getString('nightNotiTime').isNotEmpty
        ? DateTime.parse(SharedPrefsService.getString('nightNotiTime'))
        : null;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SettingsModel settings = context.watch<SettingsModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SettingsTitle(text: 'التنبيهات'),
        Divider(),
        NotificationTile(
          icon: NoorIcons.morning,
          title: 'التنبيه لأذكار الصباح',
          notificationTime: morningNotiTime,
          enabled: morningNotiEnabled,
          onChanged: (bool value) async {
            morningNotiEnabled = !morningNotiEnabled;
            SharedPrefsService.putBool('morningNotiEnabled', value);
            if (morningNotiEnabled == false) {
              cancelNotification(0);
            }
            if (morningNotiEnabled == true && morningNotiTime != null) {
              setDailyNotification(morningNotiTime, 'الصباح', 0);
            }
            setState(() {});
          },
          onTimeTap: () {
            showModalBottomSheet(
              isDismissible: false,
              context: context,
              builder: (BuildContext context) => NotificationSelectableTime(
                initialDateTime: morningNotiTime ?? DateTime.now(),
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    morningTemp = newDateTime;
                  });
                },
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (morningTemp != null) {
                    setState(() {
                      morningNotiTime = morningTemp;
                    });

                    SharedPrefsService.putString(
                        'morningNotiTime', morningNotiTime.toString());

                    setDailyNotification(morningNotiTime, 'الصباح', 0);
                  }
                  if (morningNotiTime == null) {
                    setState(() {
                      morningNotiTime = DateTime.now();
                    });
                    SharedPrefsService.putString(
                        'morningNotiTime', morningNotiTime.toString());
                    setDailyNotification(morningNotiTime, 'الصباح', 0);
                  }
                },
              ),
            );
          },
        ),
        Divider(),
        NotificationTile(
          enabled: nightNotiEnabled,
          title: 'التنبيه لأذكار المساء',
          icon: NoorIcons.night,
          notificationTime: nightNotiTime,
          onChanged: (bool value) async {
            nightNotiEnabled = !nightNotiEnabled;
            SharedPrefsService.putBool('nightNotiEnabled', value);
            if (nightNotiEnabled == false) {
              cancelNotification(1);
            }
            if (nightNotiEnabled == true && nightNotiTime != null) {
              setDailyNotification(nightNotiTime, 'المساء', 1);
            }
            setState(() {});
          },
          onTimeTap: () {
            showModalBottomSheet(
              isDismissible: false,
              context: context,
              builder: (BuildContext context) => NotificationSelectableTime(
                initialDateTime: nightNotiTime ?? DateTime.now(),
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    print(newDateTime);
                    nightTemp = newDateTime;
                  });
                },
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (nightTemp != null) {
                    setState(() {
                      nightNotiTime = nightTemp;
                    });
                    SharedPrefsService.putString(
                        'nightNotiTime', nightNotiTime.toString());

                    setDailyNotification(nightNotiTime, 'المساء', 1);
                  }
                  if (nightNotiTime == null) {
                    setState(() {
                      nightNotiTime = DateTime.now();
                    });
                    SharedPrefsService.putString(
                        'nightNotiTime', nightNotiTime.toString());
                    setDailyNotification(nightNotiTime, 'المساء', 1);
                  }
                },
              ),
            );
          },
        ),
        Divider(),
        SwitcherOption(
          icon: NoorIcons.notifications,
          title: 'إشعارات عامة',
          value: settings.generalNotification,
          onChanged: (bool value) {
            if (value) {
              FCMService.instance.subscribe();
            } else {
              FCMService.instance.unsubscribe();
            }
          },
        ),
        Divider(),
      ],
    );
  }
}
