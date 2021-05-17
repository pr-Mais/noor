import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:noor/services/remote_config.dart';

import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:noor/exports/constants.dart' show Images;
import 'package:noor/exports/pages.dart' show AllahNames, AthkarPage, Ad3yah;
import 'package:noor/exports/components.dart' show GlowingStars, HomeCard;
import 'package:noor/exports/utils.dart' show backToExactLocation, Tashkeel;
import 'package:noor/exports/controllers.dart' show ThemeModel;
import 'package:noor/exports/services.dart' show SharedPrefsService;
import 'package:noor/exports/models.dart' show AllahName, DataModel, Thekr;
import 'package:noor/exports/constants.dart' show NoorCategory;

class Home extends StatefulWidget {
  Home({
    Key? key,
  }) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool isWriting = false;
  FocusNode _focusNode = new FocusNode();
  TextEditingController _searchController = new TextEditingController();
  List results = [];
  List title = [];

  String? searchWord;

  late AnimationController cloudController;
  late Animation<Offset> _topCloudAnim;
  late Animation<Offset> _bottomCloudAnim;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    setupCloudAnimation();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    cloudController.dispose();
    super.dispose();
  }

  Future<void> displayNotification(
      String title, String body, String payload) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'RC',
      'RC notification',
      'RC channel',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  setupCloudAnimation() {
    cloudController =
        AnimationController(duration: Duration(seconds: 15), vsync: this)
          ..forward()
          ..reverse()
          ..repeat();

    _topCloudAnim =
        Tween<Offset>(begin: Offset(3.0, 0.0), end: Offset(-5.5, 0.0))
            .animate(cloudController);
    _bottomCloudAnim =
        Tween<Offset>(begin: Offset(-5.5, 0.0), end: Offset(3.0, 0.0))
            .animate(cloudController);
  }

  //once the user type something, results will start showing
  void _searchOperation(String query) {
    final DataModel dataModel = GetIt.I<DataModel>();

    final List<dynamic> allLists = List<dynamic>.from(
      <dynamic>[
        ...dataModel.athkar,
        ...dataModel.quraan,
        ...dataModel.sunnah,
        ...dataModel.ruqiya,
        ...dataModel.allahNames,
      ],
    );

    results.clear();
    title.clear();
    String? tmp;
    setState(() {
      searchWord = query;
      isWriting = true;
      if (query.isEmpty) {
        isWriting = false;
      }
    });
    for (int i = 0; i < allLists.length; i++) {
      tmp = Tashkeel.remove(allLists[i].text);
      tmp = mask(tmp);
      if ((tmp!.contains(query) || allLists[i].text.contains(query)) &&
          allLists[i].category != NoorCategory.MYAD3YAH) {
        results.add(allLists[i]);
        if (allLists[i].runtimeType == Thekr) {
          title.add(allLists[i].sectionName);
        } else if (allLists[i].runtimeType == AllahName) {
          if (allLists[i].name == 'الله جل جلاله') {
            title.add('اسم ${allLists[i].name}');
          } else {
            title.add('اسم الله ${allLists[i].name}');
          }
        } else {
          title.add(allLists[i].sectionName);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Images images = context.read<ThemeModel>().images;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            AnimatedHeader(
              focusNode: _focusNode,
              topCloudAnim: ValueNotifier<Animation<Offset>>(_topCloudAnim),
              bottomCloudAnim:
                  ValueNotifier<Animation<Offset>>(_bottomCloudAnim),
              isWriting: isWriting,
            ),
            Expanded(
              flex: isWriting ? 0 : 1,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    searchBar(),
                    const SizedBox(height: 10),
                    if (!isWriting)
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
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    setState(() {
                                      isWriting = false;
                                    });
                                  }
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  height: _focusNode.hasFocus && !isWriting
                                      ? MediaQuery.of(context).size.height
                                      : 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            if (isWriting)
              Expanded(
                child: SearchResults(
                  query: searchWord,
                  results: results,
                  title: title,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build the search bar widget
  Widget searchBar() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(right: 25.0, left: 25.0),
        child: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          onChanged: (String text) => _searchOperation(text),
          onTap: () {
            if (!_focusNode.hasFocus) {
              setState(() {});
            }
          },
          style: TextStyle(
              fontSize: 14, color: Theme.of(context).textTheme.body1!.color),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            hintText: 'ابحث عن ذكر أو دعاء',
            prefixIcon: Icon(Icons.search,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey
                    : Colors.white),
            suffixIcon: isWriting
                ? IconButton(
                    icon: Icon(Icons.close,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey
                            : Colors.white),
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
            fillColor: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[100]
                : Colors.white12,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedHeader extends StatefulWidget {
  const AnimatedHeader({
    Key? key,
    required FocusNode focusNode,
    required this.topCloudAnim,
    required this.bottomCloudAnim,
    required this.isWriting,
  })   : focusNode = focusNode,
        super(key: key);

  final FocusNode focusNode;
  final ValueNotifier<Animation<Offset>> topCloudAnim;
  final ValueNotifier<Animation<Offset>> bottomCloudAnim;

  final bool isWriting;

  @override
  _AnimatedHeaderState createState() => _AnimatedHeaderState();
}

class _AnimatedHeaderState extends State<AnimatedHeader>
    with TickerProviderStateMixin {
  ValueNotifier<String> remoteConfigNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    _loadRemoteConfig();
    _setupReceivingFCM();
    super.initState();
  }

  Future<void> _loadRemoteConfig() async {
    remoteConfigNotifier.value =
        await RemoteConfigService.instance.fetchNoorRC();
  }

  Future<void> _setupReceivingFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      SharedPrefsService.putBool('CONFIG_STATE', true);
      _loadRemoteConfig();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Images images =
        Provider.of<ThemeModel>(context, listen: false).images;
    return AnimatedSize(
      curve: Curves.easeInOutCirc,
      duration: Duration(milliseconds: 300),
      vsync: this,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(images.homeHeader),
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: widget.focusNode.hasFocus || widget.isWriting ? 0 : 170,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: <Widget>[
            if (Theme.of(context).brightness == Brightness.light)
              ValueListenableBuilder<Animation<Offset>>(
                valueListenable: widget.bottomCloudAnim,
                builder: (_, Animation<Offset> value, Widget? child) {
                  return Positioned(
                    top: 65,
                    child: SlideTransition(
                      position: value,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(Images.cloudBottom, width: 100),
              ),
            if (Theme.of(context).brightness == Brightness.light)
              ValueListenableBuilder<Animation<Offset>>(
                valueListenable: widget.topCloudAnim,
                builder: (_, Animation<Offset> value, Widget? child) {
                  return Positioned(
                    top: 40,
                    child: SlideTransition(
                      position: value,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(Images.cloutTop, width: 100),
              ),
            if (Theme.of(context).brightness == Brightness.dark)
              Align(
                alignment: Alignment.center,
                child: GlowingStars(),
              ),
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        SvgPicture.asset(
                          'assets/images/logo-dark.svg',
                          width: 50,
                        ),
                        const SizedBox(height: 15),
                        ValueListenableBuilder<String>(
                          valueListenable: remoteConfigNotifier,
                          builder: (_, String value, Widget? child) {
                            return AnimatedSwitcher(
                              duration: Duration(milliseconds: 500),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                    child: child, opacity: animation);
                              },
                              child: Text(
                                value,
                                key: ValueKey<String>(value),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResults extends StatefulWidget {
  const SearchResults({
    Key? key,
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

String? mask(string) {
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
    query = mask(query)!;
    if (query == null ||
        query.isEmpty ||
        !mask(source)!.contains(mask(query)!)) {
      return [TextSpan(text: source)];
    }
    final matches = query.allMatches(mask(source)!);

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
    return SizedBox(
      child: widget.results.length == 0
          ? Text('لا توجد نتائج')
          : ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              itemCount: widget.results.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    backToExactLocation(widget.results[index], context);
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
                                  children: highlightOccurrences(
                                      widget.results[index].text, widget.query),
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
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
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
            ),
    );
  }
}
