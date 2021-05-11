import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:noor/models/allah_name.dart';
import 'package:noor/models/thekr.dart';
import 'package:noor/pages/tabs/1_home/ad3yah.dart';
import 'package:noor/pages/tabs/1_home/allah_names.dart';
import 'package:noor/pages/tabs/1_home/athkar.dart';
import 'package:noor/providers/data_controller.dart';
import 'package:noor/providers/theme_provider.dart';
import 'package:noor/components/card.dart';
import 'package:noor/components/glowing_stars.dart';
import 'package:noor/components/logo.dart';
import 'package:noor/utils/back_to_location.dart';
import 'package:noor/utils/remove_tashkeel.dart';
import 'package:provider/provider.dart';
import 'package:noor/services/prefs.dart';

import 'package:noor/constants/images.dart';

class Home extends StatefulWidget {
  Home({
    Key key,
  }) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool isWriting = false;
  FocusNode _focusNode = new FocusNode();
  TextEditingController _searchController = new TextEditingController();
  List data = [];
  List results = [];
  List title = [];

  String searchWord;
  RemoteConfig remoteConfig;

  ValueNotifier<RemoteConfig> remoteConfigNotifier = ValueNotifier<RemoteConfig>(null);

  AnimationController cloudController;
  Animation<Offset> _topCloudAnim;
  Animation<Offset> _bottomCloudAnim;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    SharedPrefsUtil.putBool('CONFIG_STATE', true);
    loadRemoteConfig();
    setupReceivingFCM();
    setupCloudAnimation();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    cloudController.dispose();
    super.dispose();
  }

  loadRemoteConfig() async {
    RemoteConfig remoteConfig = await setupRemoteConfig();
    if (remoteConfigNotifier == null) {
      remoteConfigNotifier = ValueNotifier<RemoteConfig>(remoteConfig);
      print(remoteConfigNotifier.value);
    } else {
      remoteConfigNotifier.value = remoteConfig;
    }
  }

  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    Duration expiration = const Duration(seconds: 3600);
    remoteConfig.setConfigSettings(RemoteConfigSettings());

    remoteConfig.setDefaults(<String, dynamic>{
      'noorThker': 'قال تعالى: ﴿فَاذكُروني أَذكُركُم ﴾ [البقرة: ١٥٢]',
    });

    if (SharedPrefsUtil.getBool('CONFIG_STATE')) {
      SharedPrefsUtil.putBool('CONFIG_STATE', false);
      expiration = const Duration(seconds: 0);

      try {
        await remoteConfig.fetch(expiration: expiration);
        await remoteConfig.activateFetched();
      } catch (e) {
        print(e);
      }
    }

    return remoteConfig;
  }

  Future<void> displayNotification(String title, String body, String payload) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'RC',
      'RC notification',
      'RC channel',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  setupCloudAnimation() {
    cloudController = AnimationController(duration: Duration(seconds: 15), vsync: this)
      ..forward()
      ..reverse()
      ..repeat();

    _topCloudAnim = Tween<Offset>(begin: Offset(3.0, 0.0), end: Offset(-5.5, 0.0)).animate(cloudController);
    _bottomCloudAnim = Tween<Offset>(begin: Offset(-5.5, 0.0), end: Offset(3.0, 0.0)).animate(cloudController);
  }

  setupReceivingFCM() {
    FirebaseMessaging _fcm = FirebaseMessaging();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (message['data'].containsKey('CONFIG_STATE')) {
          SharedPrefsUtil.putBool('CONFIG_STATE', true);
          loadRemoteConfig();
        }
        if (SharedPrefsUtil.getBool('generalNotifications')) {
          displayNotification(message['notification']['body'], '', message['data'].toString());
        }
      },
    );
  }

  //once the user type something, results will start showing
  void _searchOperation(String query) {
    results.clear();
    title.clear();
    String tmp;
    setState(() {
      searchWord = query;
      isWriting = true;
      if (query.isEmpty) {
        isWriting = false;
      }
    });
    for (int i = 0; i < data.length; i++) {
      tmp = Tashkeel.remove(data[i].text);
      tmp = mask(tmp);
      if ((tmp.contains(query) || data[i].text.contains(query)) && data[i].section != 5) {
        results.add(data[i]);
        if (data[i].runtimeType == Thekr) {
          title.add(data[i].sectionName);
        } else if (data[i].runtimeType == AllahName) {
          if (data[i].name == 'الله جل جلاله') {
            title.add('اسم ${data[i].name}');
          } else {
            title.add('اسم الله ${data[i].name}');
          }
        } else {
          title.add(data[i].sectionName);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Images images = context.read<ThemeProvider>().images;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AnimatedHeader(
              focusNode: _focusNode,
              topCloudAnim: ValueNotifier<Animation<Offset>>(_topCloudAnim),
              bottomCloudAnim: ValueNotifier<Animation<Offset>>(_bottomCloudAnim),
              remoteConfigNotifier: remoteConfigNotifier,
              isWriting: isWriting,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    serachBar(),
                    Stack(
                      children: <Widget>[
                        if (!isWriting)
                          Column(
                            children: <Widget>[
                              HomeCard(
                                page: const AthkarPage(),
                                image: images.athkarCard,
                                tag: 'athkar',
                              ),
                              HomeCard(
                                page: const Ad3yah(),
                                image: images.ad3yahCard,
                                tag: 'ad3yah',
                              ),
                              HomeCard(
                                page: const AllahNames(),
                                image: images.allahNamesCard,
                                tag: 'allah names',
                              ),
                            ],
                          ),
                        Visibility(
                          visible: !isWriting && _focusNode.hasFocus,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 400),
                            opacity: _focusNode.hasFocus ? 1.0 : 0.0,
                            child: GestureDetector(
                              onTap: () {
                                if (_focusNode.hasFocus) {
                                  _searchController.clear();
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  setState(() {
                                    isWriting = false;
                                  });
                                }
                              },
                              child: Container(
                                color: Colors.transparent,
                                height: _focusNode.hasFocus && !isWriting ? MediaQuery.of(context).size.height : 0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isWriting)
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: SearchResults(
                          query: searchWord,
                          results: results,
                          title: title,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the search bar widget
  Widget serachBar() {
    return Container(
      padding: EdgeInsets.only(right: 25.0, left: 25.0),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: _searchOperation,
        onTap: () {
          if (!_focusNode.hasFocus) {
            setState(() {});
          }
        },
        style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.body1.color),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          hintText: 'ابحث عن ذكر أو دعاء',
          prefixIcon:
              Icon(Icons.search, color: Theme.of(context).brightness == Brightness.light ? Colors.grey : Colors.white),
          suffixIcon: isWriting
              ? IconButton(
                  icon: Icon(Icons.close,
                      color: Theme.of(context).brightness == Brightness.light ? Colors.grey : Colors.white),
                  onPressed: () {
                    _searchController.clear();
                    FocusScope.of(context).requestFocus(new FocusNode());
                    setState(() {
                      isWriting = false;
                    });
                  },
                )
              : null,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 2.0),
            borderRadius: BorderRadius.circular(16.0),
          ),
          filled: true,
          fillColor:
              Theme.of(context).brightness == Brightness.light ? Colors.black12 : Colors.grey[300].withOpacity(0.1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedHeader extends StatelessWidget {
  const AnimatedHeader({
    Key key,
    @required FocusNode focusNode,
    @required this.topCloudAnim,
    @required this.bottomCloudAnim,
    @required this.remoteConfigNotifier,
    @required this.isWriting,
  })  : _focusNode = focusNode,
        super(key: key);

  final FocusNode _focusNode;
  final ValueNotifier<Animation<Offset>> topCloudAnim;
  final ValueNotifier<Animation<Offset>> bottomCloudAnim;

  final ValueNotifier<RemoteConfig> remoteConfigNotifier;
  final bool isWriting;

  @override
  Widget build(BuildContext context) {
    final images = Provider.of<ThemeProvider>(context, listen: false).images;
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 230),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(images.homeHeader),
          fit: BoxFit.fitWidth,
          alignment: Alignment.bottomCenter,
        ),
      ),
      height: _focusNode.hasFocus || isWriting ? 0 : 160,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: <Widget>[
          if (Theme.of(context).brightness == Brightness.light)
            ValueListenableBuilder<Animation<Offset>>(
              valueListenable: bottomCloudAnim,
              builder: (_, Animation<Offset> value, __) => Positioned(
                top: 55,
                child: SlideTransition(
                  position: value,
                  child: Image.asset('assets/CloudTop.png'),
                ),
              ),
            ),
          if (Theme.of(context).brightness == Brightness.light)
            ValueListenableBuilder<Animation<Offset>>(
              valueListenable: topCloudAnim,
              builder: (context, value, child) => Positioned(
                top: 30,
                child: SlideTransition(
                  position: value,
                  child: Image.asset('assets/CloudBottom.png'),
                ),
              ),
            ),
          if (Theme.of(context).brightness == Brightness.dark)
            Align(
              alignment: Alignment.center,
              child: GlowingStars(),
            ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    const NoorLogo(),
                    const SizedBox(height: 25),
                    ValueListenableBuilder<RemoteConfig>(
                      valueListenable: remoteConfigNotifier,
                      builder: (_, RemoteConfig value, Widget child) {
                        return AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(child: child, opacity: animation);
                          },
                          child: value != null
                              ? Text(
                                  value.getString('noorThker'),
                                  key: UniqueKey(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'SST Roman', color: Colors.white, fontSize: 15),
                                )
                              : Container(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchResults extends StatefulWidget {
  const SearchResults({
    Key key,
    this.results,
    this.title,
    this.query,
  }) : super(key: key);
  final results;
  final title;
  final query;
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

String mask(string) {
  var tmp;
  // for each أ، إ، آ in string, replace with ا
  tmp = string.replaceAll(
      RegExp(
        r'[\u{0622}\u{0623}\u{0625}]',
        unicode: true,
      ),
      'ا');
  // ignore unicodes start with ufxxx, for each ئ،ي in string replace with ى
  tmp = tmp.replaceAll(
      RegExp(
        r'[\u{fef1}\u{fef3}\u{fef4}\u{0626}]',
        unicode: true,
      ),
      'ى');
  // for each ة in string replace with ه
  tmp = tmp.replaceAll(
      RegExp(
        r'[\u{0629}]',
        unicode: true,
      ),
      'ه');

  return tmp;
}

class _SearchResultsState extends State<SearchResults> {
  List<TextSpan> highlightOccurrences(String source, String query) {
    source = Tashkeel.remove(source);
    query = mask(query);
    if (query == null || query.isEmpty || !mask(source).contains(mask(query))) {
      return [TextSpan(text: source)];
    }
    final matches = query.allMatches(mask(source));

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(
        TextSpan(
          text: source.substring(match.start, match.end),
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      );

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(
          TextSpan(
            text: source.substring(match.end, source.length),
          ),
        );
      }

      lastMatchEnd = match.end;
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return widget.results?.length == 0
        ? Text('لا توجد نتائج')
        : ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: widget.results.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  backToLocation(widget.results[index], context);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: RichText(
                              text: TextSpan(
                                children: highlightOccurrences(widget.results[index].text, widget.query),
                                style: DefaultTextStyle.of(context).style,
                              ),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.fade,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                      ),
                    ),
                    Padding(
                      child: Text(
                        widget.title[index],
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style:
                            TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                      ),
                    ),
                    Divider(),
                  ],
                ),
              );
            },
          );
  }
}
