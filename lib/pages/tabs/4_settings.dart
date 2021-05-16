import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:noor/services/fcm.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:noor/exports/components.dart'
    show CardTemplate, NoorSettingsIcons;
import 'package:noor/exports/services.dart' show SharedPrefsService;
import 'package:noor/exports/utils.dart' show Tashkeel;
import 'package:noor/exports/controllers.dart'
    show ThemeProvider, SettingsModel;
import 'package:noor/exports/constants.dart' show Images, Links, Ribbon;

class Settings extends StatefulWidget {
  Settings({
    Key? key,
  }) : super(key: key);

  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  var morningNotiEnabled;
  var nightNotiEnabled;
  var morningNotiTime;
  var nightNotiTime;

  @override
  get wantKeepAlive => true;

  @override
  void initState() {
    tz.initializeTimeZones();

    morningNotiEnabled = SharedPrefsService.getBool('morningNotiEnabled') &&
        SharedPrefsService.getString('morningNotiTime').isNotEmpty;
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

  var morningTemp;
  var nightTemp;
  List fonts = ['١٦', '١٨', '٢٠', '٢٢'];
  var activeLabelStyle =
      const TextStyle(color: Color(0xff6db7e5), fontSize: 18, height: 1);
  var inactiveLabelStyle = TextStyle(
    color: Colors.grey[400],
  );
  String placeholderText =
      'أعوذ بـالـلـه من الشيطان الـرجـيم ﴿اللَّهُ لاَ إِلَٰهَ إِلاَّ هُـوَ الْـحَيُّ الْـقَيُّومُ لاَ تَأخذُهُ سنَةٌ ولا نومٌ لهُ ما في السَّمَاوَاتِ وما في الأَرضِ من ذا الَّذِي يَشْفَعُ عِنْدَهُ إِلاَّ بإِذنهِ يعْلَمُ ما بينَ أيدِيهِمْ وما خلفَهُمْ ولا يُحيطُونَ بِشيءٍ مِّن عِلْمِهِ إِلاَّ بِمَا شَاء وَسعَ كُرْسيُّهُ السَّمَاوَاتِ وَالأَرْضَ وَلاَ يَؤودُهُ حِفظُهُمَا وهوَ العَليُّ العَظيمُ﴾ [البقرة: ٢٥٥].';

  Widget title(text, {color = const Color(0xff6f85d5)}) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 20.0,
      ),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(color: color, fontFamily: 'SST', fontSize: 15),
        textScaleFactor: 1,
      ),
    );
  }

  Widget subTitle(String text, IconData? icon, {String? image}) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 30.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 20,
            child: image != null
                ? Image.asset(image, height: 16)
                : Icon(icon, size: icon == NoorSettingsIcons.bulb_on ? 20 : 16),
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ],
      ),
    );
  }

  Widget switcherOption({
    IconData? icon,
    required title,
    option1,
    option2,
    onChanged,
    required value,
    String? image,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        subTitle(title, icon, image: image),
        Container(
          margin: EdgeInsets.only(left: 20.0),
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

  segmentedControlOption({icon, required title, required onChanged, value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        subTitle(title, icon),
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            width: 130,
            margin: EdgeInsets.symmetric(horizontal: 30.0),
            child: CupertinoSlidingSegmentedControl<String>(
              padding: EdgeInsets.all(3),
              thumbColor: Theme.of(context).primaryColor,
              children: <String, Widget>{
                'strong': Text(
                  'قوي',
                  style: TextStyle(
                      color: value == 'strong' ? Colors.white : Colors.grey,
                      fontSize: 11,
                      fontFamily: 'SST Roman'),
                ),
                'light': Text(
                  'خفيف',
                  style: TextStyle(
                      color: value == 'light' ? Colors.white : Colors.grey,
                      fontSize: 11,
                      fontFamily: 'SST Roman'),
                ),
                'none': Text(
                  'إيقاف',
                  style: TextStyle(
                      color: value == 'none' ? Colors.white : Colors.grey,
                      fontSize: 11,
                      fontFamily: 'SST Roman'),
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

  formatTime(DateTime dateTime) {
    return dateTime == null
        ? 'اختر وقت'
        : intl.DateFormat('h:mm a', 'ar').format(dateTime);
  }

  changeTheme(value) async {
    context.read<SettingsModel>().theme = value;
    context.read<ThemeProvider>().userTheme = value;
  }

  Widget radioBtn(icon, title, value) {
    return ListTileTheme(
      contentPadding: EdgeInsets.only(right: 0, left: 20),
      dense: false,
      child: RadioListTile(
        controlAffinity: ListTileControlAffinity.trailing,
        title: subTitle(title, icon),
        activeColor: Theme.of(context).primaryColor,
        groupValue: context.watch<SettingsModel>().theme,
        value: value,
        onChanged: changeTheme,
      ),
    );
  }

  void share() {
    Share.share(
        'يضمُّ تطبيق نُور العديد من الأذكار والأدعية الواردة في كتاب حصن المسلم. كما يحتوي التطبيق على أدعية من القرآن الكريم والسنة النبوية. والعديد من المميزات. \n https://play.google.com/store/apps/details?id=com.noor.sa',
        subject: 'تطبيق نُور');
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

  void cancelNotification(id) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  launchURL(url) async {
    await launch(url);
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final SettingsModel settings = context.watch<SettingsModel>();
    final Images images = Provider.of<ThemeProvider>(context).images;

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
                  Card(
                    data: placeholderText,
                    scaleFactor: settings.fontSize,
                    tashkeel: settings.tashkeel,
                  ),
                  const Divider(),
                  subTitle(
                    'حجم الخط',
                    NoorSettingsIcons.font_size,
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
                              children: List.from(
                                [
                                  animatedSizeText(0, 16),
                                  animatedSizeText(1, 18),
                                  animatedSizeText(2, 20),
                                  animatedSizeText(3, 22)
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
                                divisions: 3,
                                onChanged: (value) => settings.fontSize = value,
                                value: settings.fontSize,
                                min: 1,
                                max: 1.375,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  subTitle(
                    'نوع الخط',
                    NoorSettingsIcons.font_face,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 40.0, left: 40.0, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        fontTypeButton('SST Roman'),
                        fontTypeButton('Dubai'),
                        fontTypeButton('Geeza')
                      ],
                    ),
                  ),
                  const Divider(),
                  switcherOption(
                    icon: NoorSettingsIcons.tashkeel,
                    title: 'التشكيل',
                    value: settings.tashkeel,
                    onChanged: (value) => settings.tashkeel = value,
                  ),
                  const Divider(),
                  VerticalSpace(),
                  title('العداد'),
                  const Divider(),
                  switcherOption(
                    icon: NoorSettingsIcons.jump,
                    title: 'الانتقال التلقائي إلى الذكر التالي',
                    value: settings.autoJump,
                    onChanged: (value) => settings.autoJump = value,
                  ),
                  const Divider(),
                  VerticalSpace(),
                  title('إظهار العداد'),
                  const Divider(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                    alignment: Alignment.center,
                    child: CupertinoSlidingSegmentedControl(
                      padding: EdgeInsets.all(3),
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
                  VerticalSpace(),
                  title('الهزاز'),
                  const Divider(),
                  switcherOption(
                    icon: NoorSettingsIcons.vibrate,
                    title: 'الهزاز لعداد صفحة الأذكار',
                    value: settings.vibrate,
                    onChanged: (value) => settings.vibrate = value,
                  ),
                  const Divider(),
                  AnimatedCrossFade(
                    firstChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: title('نوع الهزاز لصفحة الأذكار',
                              color: Theme.of(context).textTheme.body1!.color),
                        ),
                        VerticalSpace(),
                        segmentedControlOption(
                          icon: NoorSettingsIcons.click,
                          title: 'لكل ضغطة',
                          value: settings.vibrationClick,
                          onChanged: (value) {
                            settings.vibrationClick = value;
                            if (value == 'strong') {
                              HapticFeedback.lightImpact();
                            }
                            if (value == 'light') {
                              HapticFeedback.heavyImpact();
                            }
                          },
                        ),
                        VerticalSpace(),
                        segmentedControlOption(
                          icon: NoorSettingsIcons.done,
                          title: 'عند اكتمال العد',
                          value: settings.vibrationDone,
                          onChanged: (value) {
                            settings.vibrationDone = value;
                            if (value == 'strong') {
                              HapticFeedback.lightImpact();
                            }
                            if (value == 'light') {
                              HapticFeedback.heavyImpact();
                            }
                          },
                        ),
                        VerticalSpace(),
                        Divider(),
                      ],
                    ),
                    secondChild: Container(),
                    crossFadeState: settings.vibrate
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 300),
                  ),
                  switcherOption(
                    icon: NoorSettingsIcons.vibrate,
                    title: 'الهزاز لصفحة العداد',
                    value: SharedPrefsService.getBool('vibrateCounter'),
                    onChanged: (value) => settings.vibrateCounter = value,
                  ),
                  Divider(),
                  AnimatedCrossFade(
                    firstChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: title('نوع الهزاز لصفحة العداد',
                              color: Theme.of(context).textTheme.body1!.color),
                        ),
                        VerticalSpace(),
                        segmentedControlOption(
                            icon: NoorSettingsIcons.click,
                            title: 'لكل ضغطة',
                            value: settings.vibrationClickCounter,
                            onChanged: (value) {
                              settings.vibrationClickCounter = value;
                              if (value == 'strong') {
                                HapticFeedback.lightImpact();
                              }
                              if (value == 'light') {
                                HapticFeedback.heavyImpact();
                              }
                            }),
                        VerticalSpace(),
                        segmentedControlOption(
                          icon: NoorSettingsIcons.done,
                          title: 'عند مضاعفات المئة',
                          value: settings.vibrationHunderds,
                          onChanged: (value) {
                            settings.vibrationHunderds = value;
                            if (value == 'strong') {
                              HapticFeedback.lightImpact();
                            }
                            if (value == 'light') {
                              HapticFeedback.heavyImpact();
                            }
                          },
                        ),
                        VerticalSpace(),
                        Divider(),
                      ],
                    ),
                    secondChild: Container(),
                    crossFadeState: settings.vibrateCounter
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 300),
                  ),
                  VerticalSpace(),
                  title('التنبيهات'),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      subTitle(
                          'التنبيه لأذكار الصباح', NoorSettingsIcons.morning),
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
                                                  child: FlatButton(
                                                    child: Text(
                                                      'حفظ',
                                                      style: TextStyle(
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .light
                                                              ? Theme.of(
                                                                      context)
                                                                  .accentColor
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'SST Roman'),
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
                                                                    .toString());

                                                        setDailyNotification(
                                                            morningNotiTime,
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
                                                                    .toString());
                                                        setDailyNotification(
                                                            morningNotiTime,
                                                            'الصباح',
                                                            0);
                                                      }
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 60,
                                                  child: FlatButton(
                                                    child: Text(
                                                      'إلغاء',
                                                      style: TextStyle(
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .light
                                                              ? Theme.of(
                                                                      context)
                                                                  .accentColor
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'SST Roman'),
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
                                                      locale: Locale('ar'),
                                                      fontFamily: 'SST',
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
                                        color: Theme.of(context).dividerColor),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    formatTime(morningNotiTime),
                                    style: Theme.of(context).textTheme.subtitle,
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
                              SharedPrefsService.putBool(
                                  'morningNotiEnabled', value);
                              if (morningNotiEnabled == false) {
                                cancelNotification(0);
                              }
                              if (morningNotiEnabled == true &&
                                  morningNotiTime != null) {
                                setDailyNotification(
                                    morningNotiTime, 'الصباح', 0);
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
                      subTitle(
                          'التنبيه لأذكار المساء', NoorSettingsIcons.night),
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
                                                  child: FlatButton(
                                                    child: Text(
                                                      'حفظ',
                                                      style: TextStyle(
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .light
                                                              ? Theme.of(
                                                                      context)
                                                                  .accentColor
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'SST Roman'),
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
                                                                    .toString());

                                                        setDailyNotification(
                                                            nightNotiTime,
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
                                                                    .toString());
                                                        setDailyNotification(
                                                            nightNotiTime,
                                                            'المساء',
                                                            1);
                                                      }
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 60,
                                                  child: FlatButton(
                                                    child: Text(
                                                      'إلغاء',
                                                      style: TextStyle(
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .light
                                                              ? Theme.of(
                                                                      context)
                                                                  .accentColor
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'SST Roman'),
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
                                                      locale: Locale('ar'),
                                                      fontFamily: 'SST',
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
                                    style: Theme.of(context).textTheme.subtitle,
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

                              SharedPrefsService.putBool(
                                  'nightNotiEnabled', value);
                              if (nightNotiEnabled == false) {
                                cancelNotification(1);
                              }
                              if (nightNotiEnabled == true &&
                                  nightNotiTime != null) {
                                setDailyNotification(
                                    nightNotiTime, 'المساء', 1);
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  switcherOption(
                    image: Theme.of(context).brightness == Brightness.light
                        ? 'assets/icons/generalNotificationsLight.png'
                        : 'assets/icons/generalNotificationsDark.png',
                    title: 'إشعارات عامة',
                    value: settings.generalNotification,
                    onChanged: (bool value) {
                      if (value) {
                        FCMService.instance.subscribe();
                      } else {
                        FCMService.instance.unsubscribe();
                      }
                      setState(() {});
                    },
                  ),
                  Divider(),
                  VerticalSpace(),
                  title('المظهر'),
                  Divider(),
                  radioBtn(
                    NoorSettingsIcons.bulb_on,
                    'الوضع النهاري',
                    'light_theme',
                  ),
                  Divider(),
                  radioBtn(
                    NoorSettingsIcons.bulb_off,
                    'الوضع الليلي',
                    'dark_theme',
                  ),
                  Divider(),
                  radioBtn(
                    NoorSettingsIcons.system_mode,
                    'وضع النظام',
                    'system_theme',
                  ),
                  const Divider(),
                  VerticalSpace(),
                  title('المصادر'),
                  const Divider(),
                  InkWell(
                    onTap: () => launchURL(Links.allahNamesResource),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      child: subTitle('قسم أسماء الله الحُسنى',
                          NoorSettingsIcons.allahnames),
                    ),
                  ),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    width: MediaQuery.of(context).size.width,
                    child: subTitle('قسم الرقية الشرعية، كُتيب أَوراد',
                        NoorSettingsIcons.ruqya),
                  ),
                  const Divider(),
                  SizedBox(height: 10.0),
                  title('عن التطبيق'),
                  const Divider(),
                  InkWell(
                    onTap: () => launchURL(Links.appURL),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      child: subTitle('قيِّم التطبيق', NoorSettingsIcons.star),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: share,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      child: subTitle('نشر التطبيق', NoorSettingsIcons.share),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () => launchURL(Links.contactEmailURL),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      child: subTitle('تواصل معنا', NoorSettingsIcons.mail),
                    ),
                  ),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        subTitle('شبكات التواصل', NoorSettingsIcons.follow),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => launchURL(Links.twitter),
                              child:
                                  Image.asset(images.twitterButton, width: 65),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => launchURL(Links.ig),
                              child: Image.asset(images.igButton, width: 65),
                            ),
                            SizedBox(width: 20)
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
    return AnimatedSize(
      child: Text(
        fonts[i],
        style: SharedPrefsService.getDouble('fontSize') * 16 == size
            ? activeLabelStyle
            : inactiveLabelStyle,
      ),
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  Widget fontTypeButton(String font) {
    return FlatButton(
      onPressed: () => context.read<SettingsModel>().fontType = font,
      child: AnimatedDefaultTextStyle(
        style: TextStyle(
            fontFamily: font,
            color: context.read<SettingsModel>().fontType == font
                ? Theme.of(context).primaryColor
                : Colors.grey[400],
            height: 1,
            fontSize: context.read<SettingsModel>().fontType == font ? 20 : 16),
        duration: Duration(milliseconds: 200),
        child: Text('الحمدلله'),
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
  Card({
    this.data,
    this.scaleFactor,
    this.tashkeel,
  });

  final String? data;
  final double? scaleFactor;
  final bool? tashkeel;

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      ribbon: Ribbon.ribbon1,
      actions: <Widget>[
        Image.asset('assets/icons/outline_heart.png'),
        Image.asset('assets/icons/copy.png'),
      ],
      child: Text(
        !tashkeel! ? Tashkeel.remove(data!) : data!,
        textScaleFactor: scaleFactor,
      ),
    );
  }
}
