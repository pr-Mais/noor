import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:noor/components/adaptive_icon.dart';
import 'package:noor/models/data.dart';
import 'package:noor/services/fcm.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:noor/exports/components.dart' show CardTemplate, CardText;
import 'package:noor/exports/services.dart' show SharedPrefsService;
import 'package:noor/exports/controllers.dart' show ThemeModel, AppSettings;
import 'package:noor/exports/constants.dart'
    show Images, Links, NoorIcons, Strings;

class Settings extends StatefulWidget {
  const Settings({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late bool morningNotiEnabled;
  late bool nightNotiEnabled;
  DateTime? morningNotiTime;
  DateTime? nightNotiTime;

  @override
  get wantKeepAlive => true;

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

  DateTime? morningTemp;
  DateTime? nightTemp;
  List<int> allowedFontSizes = <int>[16, 18, 20, 22, 24];
  TextStyle activeLabelStyle = const TextStyle(
    color: Color(0xff6db7e5),
    fontSize: 18,
    height: 1,
  );
  TextStyle inactiveLabelStyle = TextStyle(
    color: Colors.grey[400],
  );

  Widget title(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 20.0,
      ),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.subtitle1,
        textScaleFactor: 1,
      ),
    );
  }

  Widget subtitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 20.0,
      ),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              height: 1,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
        textScaleFactor: 1,
      ),
    );
  }

  Widget subtitleWithIcon(String text, String icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AdaptiveIcon(icon),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  height: 1,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }

  Widget switcherOption({
    required String icon,
    required String title,
    required Function(bool) onChanged,
    required bool value,
    String? image,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        subtitleWithIcon(title, icon),
        Container(
          margin: const EdgeInsets.only(left: 20.0),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Switch(
              value: value,
              activeColor: Theme.of(context).primaryColor,
              onChanged: onChanged,
            ),
          ),
        )
      ],
    );
  }

  segmentedControlOption({
    required String icon,
    required String title,
    required void Function(String?) onChanged,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        subtitleWithIcon(title, icon),
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            width: 130,
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            child: CupertinoSlidingSegmentedControl<String>(
              padding: const EdgeInsets.all(3),
              thumbColor: Theme.of(context).primaryColor,
              children: <String, Widget>{
                'strong': Text(
                  'قوي',
                  style: TextStyle(
                    color: value == 'strong' ? Colors.white : Colors.grey,
                    fontSize: 11,
                  ),
                ),
                'light': Text(
                  'خفيف',
                  style: TextStyle(
                    color: value == 'light' ? Colors.white : Colors.grey,
                    fontSize: 11,
                  ),
                ),
                'none': Text(
                  'إيقاف',
                  style: TextStyle(
                    color: value == 'none' ? Colors.white : Colors.grey,
                    fontSize: 11,
                  ),
                )
              },
              groupValue: value,
              onValueChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  formatTime(DateTime? dateTime) {
    return dateTime == null
        ? 'اختر وقت'
        : intl.DateFormat('h:mm a', 'ar').format(dateTime);
  }

  changeTheme(String value) async {
    context.read<AppSettings>().theme = value;
    context.read<ThemeModel>().userTheme = value;
  }

  Widget radioBtn(String icon, String title, String value) {
    return ListTileTheme(
      contentPadding: const EdgeInsets.only(right: 0, left: 20),
      dense: false,
      child: RadioListTile<String>(
        controlAffinity: ListTileControlAffinity.trailing,
        title: subtitleWithIcon(title, icon),
        activeColor: Theme.of(context).primaryColor,
        groupValue: context.watch<AppSettings>().theme,
        value: value,
        onChanged: (String? theme) => changeTheme(theme!),
      ),
    );
  }

  void share() {
    Share.share(Strings.shareText, subject: Strings.shareSubject);
  }

  void setDailyNotification(DateTime dateTime, String period, int id) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '$id',
      period,
      showWhen: true,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'أذكار $period',
      '',
      tz.TZDateTime.from(dateTime, tz.local).add(const Duration(days: 10000)),
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
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  launchURL(String url) async {
    await launch(url);
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AppSettings settings = context.watch<AppSettings>();
    final Images images = Provider.of<ThemeModel>(context).images;

    return Scaffold(
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  title('الخط'),
                  const Divider(),
                  const Card(),
                  const Divider(),
                  subtitleWithIcon(
                    'حجم الخط',
                    NoorIcons.fontSize,
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10.0),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List<Widget>.from(
                                <Widget>[
                                  animatedSizeText(0, 16),
                                  animatedSizeText(1, 18),
                                  animatedSizeText(2, 20),
                                  animatedSizeText(3, 22),
                                  animatedSizeText(4, 24)
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: SliderTheme(
                              data: SliderThemeData(
                                activeTrackColor:
                                    Theme.of(context).primaryColor,
                                thumbColor: Theme.of(context).primaryColor,
                                inactiveTrackColor: Colors.grey[400],
                                trackHeight: 2,
                                inactiveTickMarkColor:
                                    Theme.of(context).primaryColor,
                                activeTickMarkColor: Colors.grey[400],
                              ),
                              child: Slider(
                                divisions: 4,
                                onChanged: (double value) =>
                                    settings.fontSize = value,
                                value: settings.fontSize,
                                min: 1,
                                max: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  subtitleWithIcon(
                    'نوع الخط',
                    NoorIcons.fontType,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 40.0, left: 40.0, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        fontTypeButton('SST Arabic'),
                        fontTypeButton('Dubai'),
                        fontTypeButton('Geeza')
                      ],
                    ),
                  ),
                  const Divider(),
                  switcherOption(
                    icon: NoorIcons.tashkeel,
                    title: 'التشكيل',
                    value: settings.tashkeel,
                    onChanged: (bool value) => settings.tashkeel = value,
                  ),
                  const Divider(),
                  const VerticalSpace(),
                  title('العداد'),
                  const Divider(),
                  switcherOption(
                    icon: NoorIcons.jump,
                    title: 'الانتقال التلقائي إلى الذكر التالي',
                    value: settings.autoJump,
                    onChanged: (bool value) => settings.autoJump = value,
                  ),
                  const Divider(),
                  const VerticalSpace(),
                  title('إظهار العداد'),
                  const Divider(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    alignment: Alignment.center,
                    child: CupertinoSlidingSegmentedControl<int>(
                      padding: const EdgeInsets.all(3),
                      thumbColor: Theme.of(context).primaryColor,
                      children: <int, Widget>{
                        0: Text(
                          'للأذكار ذات تكرار أكثر من مرة',
                          style: TextStyle(
                            color: !settings.showCounter
                                ? Colors.white
                                : Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                        1: Text(
                          'لكل الأذكار',
                          style: TextStyle(
                            color: settings.showCounter
                                ? Colors.white
                                : Colors.grey,
                            fontSize: 11,
                          ),
                        )
                      },
                      groupValue: settings.showCounter ? 1 : 0,
                      onValueChanged: (dynamic value) =>
                          settings.showCounter = value == 1,
                    ),
                  ),
                  const Divider(),
                  const VerticalSpace(),
                  title('الهزاز'),
                  const Divider(),
                  switcherOption(
                    icon: NoorIcons.vibrate,
                    title: 'الهزاز لعداد صفحة الأذكار',
                    value: settings.vibrate,
                    onChanged: (bool value) => settings.vibrate = value,
                  ),
                  const Divider(),
                  AnimatedCrossFade(
                    firstChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: subtitle(
                            'نوع الهزاز لصفحة الأذكار',
                          ),
                        ),
                        const VerticalSpace(),
                        segmentedControlOption(
                          icon: NoorIcons.click,
                          title: 'لكل ضغطة',
                          value: settings.vibrationClick,
                          onChanged: (String? value) {
                            settings.vibrationClick = value!;
                            if (value == 'strong') {
                              HapticFeedback.lightImpact();
                            }
                            if (value == 'light') {
                              HapticFeedback.heavyImpact();
                            }
                          },
                        ),
                        const VerticalSpace(),
                        segmentedControlOption(
                          icon: NoorIcons.done,
                          title: 'عند اكتمال العد',
                          value: settings.vibrationDone,
                          onChanged: (String? value) {
                            settings.vibrationDone = value!;
                            if (value == 'strong') {
                              HapticFeedback.lightImpact();
                            }
                            if (value == 'light') {
                              HapticFeedback.heavyImpact();
                            }
                          },
                        ),
                        const VerticalSpace(),
                        const Divider(),
                      ],
                    ),
                    secondChild: Container(),
                    crossFadeState: settings.vibrate
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300),
                  ),
                  switcherOption(
                    icon: NoorIcons.vibrate,
                    title: 'الهزاز لصفحة السبحة',
                    value: settings.vibrateCounter,
                    onChanged: (bool value) => settings.vibrateCounter = value,
                  ),
                  const Divider(),
                  AnimatedCrossFade(
                    firstChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: subtitle(
                            'نوع الهزاز لصفحة السبحة',
                          ),
                        ),
                        const VerticalSpace(),
                        segmentedControlOption(
                            icon: NoorIcons.click,
                            title: 'لكل ضغطة',
                            value: settings.vibrationClickCounter,
                            onChanged: (String? value) {
                              settings.vibrationClickCounter = value!;
                              if (value == 'strong') {
                                HapticFeedback.lightImpact();
                              }
                              if (value == 'light') {
                                HapticFeedback.heavyImpact();
                              }
                            }),
                        const VerticalSpace(),
                        segmentedControlOption(
                          icon: NoorIcons.done,
                          title: 'عند مضاعفات المئة',
                          value: settings.vibrationHunderds,
                          onChanged: (String? value) {
                            settings.vibrationHunderds = value!;
                            if (value == 'strong') {
                              HapticFeedback.lightImpact();
                            }
                            if (value == 'light') {
                              HapticFeedback.heavyImpact();
                            }
                          },
                        ),
                        const VerticalSpace(),
                        const Divider(),
                      ],
                    ),
                    secondChild: Container(),
                    crossFadeState: settings.vibrateCounter
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300),
                  ),
                  const VerticalSpace(),
                  title('التنبيهات'),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      subtitleWithIcon(
                          'التنبيه لأذكار الصباح', NoorIcons.morning),
                      morningNotiEnabled
                          ? SizedBox(
                              width: 100,
                              height: 30,
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    isDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) => SizedBox(
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .secondary,
                                                              fontSize: 12),
                                                    ),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      if (morningTemp != null) {
                                                        setState(() {
                                                          morningNotiTime =
                                                              morningTemp;
                                                        });

                                                        SharedPrefsService
                                                            .putString(
                                                          'morningNotiTime',
                                                          morningNotiTime
                                                              .toString(),
                                                        );

                                                        setDailyNotification(
                                                            morningNotiTime!,
                                                            'الصباح',
                                                            0);
                                                      }
                                                      if (morningNotiTime ==
                                                          null) {
                                                        setState(() {
                                                          morningNotiTime =
                                                              DateTime.now();
                                                        });
                                                        SharedPrefsService
                                                            .putString(
                                                          'morningNotiTime',
                                                          morningNotiTime
                                                              .toString(),
                                                        );
                                                        setDailyNotification(
                                                            morningNotiTime!,
                                                            'الصباح',
                                                            0);
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .secondary,
                                                              fontSize: 12),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                              ],
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                            ),
                                          ),
                                          Expanded(
                                            child: Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: CupertinoTheme(
                                                data: CupertinoThemeData(
                                                  textTheme:
                                                      CupertinoTextThemeData(
                                                    dateTimePickerTextStyle:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                  ),
                                                ),
                                                child: CupertinoDatePicker(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .cardColor,
                                                  mode: CupertinoDatePickerMode
                                                      .time,
                                                  initialDateTime:
                                                      morningNotiTime ??
                                                          DateTime.now(),
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
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Switch(
                            value: morningNotiEnabled,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (bool value) async {
                              morningNotiEnabled = !morningNotiEnabled;
                              SharedPrefsService.putBool(
                                  'morningNotiEnabled', value);
                              if (morningNotiEnabled == false) {
                                cancelNotification(0);
                              }
                              if (morningNotiEnabled == true &&
                                  morningNotiTime != null) {
                                setDailyNotification(
                                    morningNotiTime!, 'الصباح', 0);
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      subtitleWithIcon(
                          'التنبيه لأذكار المساء', NoorIcons.night),
                      nightNotiEnabled
                          ? SizedBox(
                              width: 100,
                              height: 30,
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    isDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) => SizedBox(
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .secondary,
                                                              fontSize: 12),
                                                    ),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      if (nightTemp != null) {
                                                        setState(() {
                                                          nightNotiTime =
                                                              nightTemp;
                                                        });
                                                        SharedPrefsService
                                                            .putString(
                                                          'nightNotiTime',
                                                          nightNotiTime
                                                              .toString(),
                                                        );

                                                        setDailyNotification(
                                                            nightNotiTime!,
                                                            'المساء',
                                                            1);
                                                      }
                                                      if (nightNotiTime ==
                                                          null) {
                                                        setState(() {
                                                          nightNotiTime =
                                                              DateTime.now();
                                                        });
                                                        SharedPrefsService
                                                            .putString(
                                                          'nightNotiTime',
                                                          nightNotiTime
                                                              .toString(),
                                                        );
                                                        setDailyNotification(
                                                            nightNotiTime!,
                                                            'المساء',
                                                            1);
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .secondary,
                                                              fontSize: 12),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                              ],
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                            ),
                                          ),
                                          Expanded(
                                            child: Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: CupertinoTheme(
                                                data: CupertinoThemeData(
                                                  textTheme:
                                                      CupertinoTextThemeData(
                                                    dateTimePickerTextStyle:
                                                        TextStyle(
                                                      locale:
                                                          const Locale('ar'),
                                                      fontFamily: 'SST Arabic',
                                                      fontSize: 16,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .color,
                                                    ),
                                                  ),
                                                ),
                                                child: CupertinoDatePicker(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .cardColor,
                                                  mode: CupertinoDatePickerMode
                                                      .time,
                                                  initialDateTime:
                                                      nightNotiTime ??
                                                          DateTime.now(),
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
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Switch(
                            value: nightNotiEnabled,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (bool value) async {
                              nightNotiEnabled = !nightNotiEnabled;

                              SharedPrefsService.putBool(
                                  'nightNotiEnabled', value);
                              if (nightNotiEnabled == false) {
                                cancelNotification(1);
                              }
                              if (nightNotiEnabled == true &&
                                  nightNotiTime != null) {
                                setDailyNotification(
                                    nightNotiTime!, 'المساء', 1);
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  switcherOption(
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
                  const Divider(),
                  const VerticalSpace(),
                  title('المظهر'),
                  const Divider(),
                  radioBtn(
                    NoorIcons.lightMode,
                    'الوضع النهاري',
                    'light_theme',
                  ),
                  const Divider(),
                  radioBtn(
                    NoorIcons.darkMode,
                    'الوضع الليلي',
                    'dark_theme',
                  ),
                  const Divider(),
                  radioBtn(
                    NoorIcons.systemMode,
                    'وضع النظام',
                    'system_theme',
                  ),
                  const Divider(),
                  const VerticalSpace(),
                  title('المصادر'),
                  const Divider(),
                  InkWell(
                    onTap: () => launchURL(Links.allahNamesResource),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      child: subtitleWithIcon(
                          'قسم أسماء الله الحُسنى', NoorIcons.allahNames),
                    ),
                  ),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    width: MediaQuery.of(context).size.width,
                    child: subtitleWithIcon(
                        'قسم الرقية الشرعية، كُتيب أَوراد', NoorIcons.ruqiya),
                  ),
                  const Divider(),
                  const SizedBox(height: 10.0),
                  title('عن التطبيق'),
                  const Divider(),
                  InkWell(
                    onTap: () => launchURL(Links.appURL),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      child: subtitleWithIcon('تقييم التطبيق', NoorIcons.star),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: share,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      child: subtitleWithIcon('نشر التطبيق', NoorIcons.share),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () => launchURL(Links.contactEmailURL),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      child: subtitleWithIcon('تواصل معنا', NoorIcons.mail),
                    ),
                  ),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        subtitleWithIcon('شبكات التواصل', NoorIcons.follow),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => launchURL(Links.twitter),
                              child:
                                  Image.asset(images.twitterButton, width: 65),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => launchURL(Links.ig),
                              child: Image.asset(images.igButton, width: 65),
                            ),
                            const SizedBox(width: 20)
                          ],
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget animatedSizeText(int i, int size) {
    final selectedFontSize = SharedPrefsService.getDouble('fontSize') * 16;
    return AnimatedSize(
      child: Text(
        '${allowedFontSizes[i]}',
        style: selectedFontSize == size ? activeLabelStyle : inactiveLabelStyle,
      ),
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget fontTypeButton(String font) {
    return OutlinedButton(
      onPressed: () => context.read<AppSettings>().fontType = font,
      child: AnimatedDefaultTextStyle(
        style: TextStyle(
            fontFamily: font,
            color: context.read<AppSettings>().fontType == font
                ? Theme.of(context).primaryColor
                : Colors.grey[400],
            height: 1,
            fontSize: context.read<AppSettings>().fontType == font ? 20 : 16),
        duration: const Duration(milliseconds: 200),
        child: const Text('الحمدلله'),
      ),
    );
  }
}

class VerticalSpace extends StatelessWidget {
  const VerticalSpace({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 10.0);
  }
}

class Card extends StatelessWidget {
  const Card({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      ribbon: context.read<DataModel>().athkar[1].ribbon,
      actions: <Widget>[
        Image.asset(Images.outlineHeartIcon),
        Image.asset(Images.copyIcon),
      ],
      child: CardText(text: context.read<DataModel>().athkar[1].text),
    );
  }
}
