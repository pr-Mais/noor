import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart' as intl;
import 'package:noor/exports/components.dart'
    show SettingsTitle, SubtitleWithIcon, SwitcherOption;
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SubtitleWithIcon(
                text: 'التنبيه لأذكار الصباح', icon: NoorIcons.morning),
            morningNotiEnabled
                ? SizedBox(
                    width: 100,
                    height: 30,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isDismissible: false,
                          context: context,
                          builder: (context) => SizedBox(
                            height: 250,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 35,
                                  color: Theme.of(context)
                                      .dialogTheme
                                      .backgroundColor,
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 60,
                                        child: TextButton(
                                          child: Text(
                                            'حفظ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontSize: 12),
                                          ),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            if (morningTemp != null) {
                                              setState(() {
                                                morningNotiTime = morningTemp;
                                              });

                                              SharedPrefsService.putString(
                                                  'morningNotiTime',
                                                  morningNotiTime.toString());

                                              setDailyNotification(
                                                  morningNotiTime, 'الصباح', 0);
                                            }
                                            if (morningNotiTime == null) {
                                              setState(() {
                                                morningNotiTime =
                                                    DateTime.now();
                                              });
                                              SharedPrefsService.putString(
                                                  'morningNotiTime',
                                                  morningNotiTime.toString());
                                              setDailyNotification(
                                                  morningNotiTime, 'الصباح', 0);
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: TextButton(
                                          child: Text(
                                            'إلغاء',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontSize: 12),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                                Expanded(
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: CupertinoTheme(
                                      data: CupertinoThemeData(
                                        textTheme: CupertinoTextThemeData(
                                          dateTimePickerTextStyle:
                                              Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                        ),
                                      ),
                                      child: CupertinoDatePicker(
                                        backgroundColor:
                                            Theme.of(context).cardColor,
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime:
                                            morningNotiTime ?? DateTime.now(),
                                        onDateTimeChanged:
                                            (DateTime newDateTime) {
                                          setState(() {
                                            morningTemp = newDateTime;
                                          });
                                        },
                                        minuteInterval: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                            color: Theme.of(context).dividerColor,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          formatTime(morningNotiTime),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 12),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Switch(
                  value: morningNotiEnabled,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) async {
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
                ),
              ),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SubtitleWithIcon(
                text: 'التنبيه لأذكار المساء', icon: NoorIcons.night),
            nightNotiEnabled
                ? SizedBox(
                    width: 100,
                    height: 30,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isDismissible: false,
                          context: context,
                          builder: (context) => SizedBox(
                            height: 250,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 35,
                                  color: Theme.of(context)
                                      .dialogTheme
                                      .backgroundColor,
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 60,
                                        child: TextButton(
                                          child: Text(
                                            'حفظ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontSize: 12),
                                          ),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            if (nightTemp != null) {
                                              setState(() {
                                                nightNotiTime = nightTemp;
                                              });
                                              SharedPrefsService.putString(
                                                  'nightNotiTime',
                                                  nightNotiTime.toString());

                                              setDailyNotification(
                                                  nightNotiTime, 'المساء', 1);
                                            }
                                            if (nightNotiTime == null) {
                                              setState(() {
                                                nightNotiTime = DateTime.now();
                                              });
                                              SharedPrefsService.putString(
                                                  'nightNotiTime',
                                                  nightNotiTime.toString());
                                              setDailyNotification(
                                                  nightNotiTime, 'المساء', 1);
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: TextButton(
                                          child: Text(
                                            'إلغاء',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontSize: 12),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                                Expanded(
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: CupertinoTheme(
                                      data: CupertinoThemeData(
                                        textTheme: CupertinoTextThemeData(
                                          dateTimePickerTextStyle: TextStyle(
                                            locale: Locale('ar'),
                                            fontFamily: 'SST Arabic',
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .textTheme
                                                .body1!
                                                .color,
                                          ),
                                        ),
                                      ),
                                      child: CupertinoDatePicker(
                                        backgroundColor:
                                            Theme.of(context).cardColor,
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime:
                                            nightNotiTime ?? DateTime.now(),
                                        onDateTimeChanged:
                                            (DateTime newDateTime) {
                                          setState(() {
                                            nightTemp = newDateTime;
                                          });
                                        },
                                        minuteInterval: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.5,
                              color: Theme.of(context).dividerColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          formatTime(nightNotiTime),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 12),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Switch(
                  value: nightNotiEnabled,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) async {
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
                ),
              ),
            ),
          ],
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
