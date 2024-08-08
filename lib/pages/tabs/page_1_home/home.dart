import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:noor/env_config.dart';
import 'package:noor/exports/components.dart' show GlowingStars, HomeCard;
import 'package:noor/exports/constants.dart' show Images;
import 'package:noor/exports/controllers.dart' show ThemeModel;
import 'package:noor/exports/models.dart' show AllahName, DataModel;
import 'package:noor/exports/pages.dart' show AllahNames, AthkarPage, Ad3yah;
import 'package:noor/exports/services.dart' show SharedPrefsService;
import 'package:noor/exports/utils.dart' show backToExactLocation, Tashkeel;
import 'package:noor/services/remote_config.dart';
import 'package:provider/provider.dart';

export 'package:noor/pages/tabs/page_1_home/ad3yah_expanded.dart';
export 'package:noor/pages/tabs/page_1_home/allah_names_expanded.dart';
export 'package:noor/pages/tabs/page_1_home/athkar_expanded.dart';
export 'package:noor/pages/tabs/page_1_home/my_ad3yah.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  bool isWriting = false;
  final _focusNode = FocusNode();
  final _searchController = TextEditingController();
  List<dynamic> results = [];
  List<dynamic> title = [];

  String searchWord = '';

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    _searchController.addListener(_searchOperation);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> displayNotification(
      String title, String body, String payload) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'RC',
      'RC notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  //once the user type something, results will start showing
  void _searchOperation() {
    // The whitespace in arabic has a special unicode
    final RegExp arWhitespace = RegExp(r'[\u200f]');
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

    String? tmp;

    results.clear();
    title.clear();

    setState(() {
      searchWord = _searchController.text;
      isWriting = true;
      if (_searchController.text.isEmpty) {
        isWriting = false;
      }
    });

    for (dynamic item in allLists) {
      tmp = Tashkeel.remove(item.text);
      tmp = mask(tmp).replaceAll(arWhitespace, '');
      searchWord = Tashkeel.remove(searchWord);
      searchWord = mask(searchWord).replaceAll(arWhitespace, '');

      if (tmp.contains(searchWord) || item.text.contains(searchWord)) {
        results.add(item);

        if (item is AllahName) {
          if (item.name == 'الله جل جلاله') {
            title.add('اسم ${item.name}');
          } else {
            title.add('اسم الله ${item.name}');
          }
        } else {
          title.add(item.sectionName);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Images images = context.watch<ThemeModel>().images;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          AnimatedHeader(
            focusNode: _focusNode,
            isWriting: isWriting,
          ),
          Expanded(
            flex: isWriting ? 0 : 1,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  if (_focusNode.hasFocus) const SizedBox(height: 10),
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
                            duration: const Duration(milliseconds: 400),
                            opacity: _focusNode.hasFocus ? 1.0 : 0.0,
                            child: GestureDetector(
                              onTap: () {
                                if (_focusNode.hasFocus) {
                                  _searchController.clear();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
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
    );
  }

  /// Build the search bar widget
  Widget searchBar() {
    return Container(
      padding: const EdgeInsets.only(right: 25.0, left: 25.0),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onTap: () {
          if (!_focusNode.hasFocus) {
            setState(() {});
          }
        },
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          hintText: 'ابحث عن ذكر أو دعاء',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey
                : Colors.white,
          ),
          suffixIcon: isWriting
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey
                        : Colors.white,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    //FocusScope.of(context).requestFocus(new FocusNode());
                    // setState(() {
                    //   isWriting = false;
                    // });
                  },
                )
              : null,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
            borderRadius: BorderRadius.circular(16.0),
          ),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[100]
              : Colors.white12,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(
              color: Colors.transparent,
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
    required this.isWriting,
    required this.focusNode,
  }) : super(key: key);

  final FocusNode focusNode;
  final bool isWriting;

  @override
  _AnimatedHeaderState createState() => _AnimatedHeaderState();
}

class _AnimatedHeaderState extends State<AnimatedHeader>
    with TickerProviderStateMixin {
  ValueNotifier<String> remoteConfigNotifier = ValueNotifier<String>('');

  late Animation<Offset> _topCloudAnim;
  late Animation<Offset> _bottomCloudAnim;

  late AnimationController cloudController;

  @override
  void initState() {
    _loadRemoteConfig();
    _setupReceivingFCM();
    _setupCloudAnimation();

    super.initState();
  }

  @override
  void dispose() {
    cloudController.dispose();
    super.dispose();
  }

  _setupCloudAnimation() {
    cloudController =
        AnimationController(duration: const Duration(seconds: 15), vsync: this)
          ..forward()
          ..reverse()
          ..repeat();

    _topCloudAnim = Tween<Offset>(
            begin: const Offset(3.0, 0.0), end: const Offset(-5.5, 0.0))
        .animate(cloudController);
    _bottomCloudAnim = Tween<Offset>(
            begin: const Offset(-5.5, 0.0), end: const Offset(3.0, 0.0))
        .animate(cloudController);
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
      duration: const Duration(milliseconds: 300),
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
        margin: EdgeInsets.only(
            bottom: widget.focusNode.hasFocus
                ? MediaQuery.of(context).viewPadding.top
                : 15.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (Theme.of(context).brightness == Brightness.light)
              Positioned(
                top: 40,
                child: SafeArea(
                  child: SlideTransition(
                    position: _bottomCloudAnim,
                    child: Image.asset(Images.cloudBottom, width: 100),
                  ),
                ),
              ),
            if (Theme.of(context).brightness == Brightness.light)
              Positioned(
                top: 10,
                child: SafeArea(
                  child: SlideTransition(
                    position: _topCloudAnim,
                    child: Image.asset(Images.cloutTop, width: 100),
                  ),
                ),
              ),
            if (Theme.of(context).brightness == Brightness.dark)
              const Align(
                alignment: Alignment.center,
                child: GlowingStars(),
              ),
            SafeArea(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 120,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 5),
                      SvgPicture.asset(
                        'assets/images/${prefix}logo-dark.svg',
                        width: 60,
                      ),
                      const SizedBox(height: 15),
                      ValueListenableBuilder<String>(
                        valueListenable: remoteConfigNotifier,
                        builder: (_, String value, Widget? child) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                  child: child, opacity: animation);
                            },
                            child: Text(
                              value,
                              key: ValueKey<String>(value),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
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
          ],
        ),
      ),
    );
  }
}

class SearchResults extends StatefulWidget {
  const SearchResults({
    Key? key,
    required this.results,
    required this.title,
    required this.query,
  }) : super(key: key);
  final List<dynamic> results;
  final List<dynamic> title;
  final String query;
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

String mask(string) {
  String tmp;
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
    if (query.isEmpty || !mask(source).contains(mask(query))) {
      return <TextSpan>[
        TextSpan(text: source),
      ];
    }
    final Iterable<Match> matches = query.allMatches(mask(source));

    int lastMatchEnd = 0;

    final List<TextSpan> children = <TextSpan>[];
    for (int i = 0; i < matches.length; i++) {
      final Match match = matches.elementAt(i);

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
      child: widget.results.isEmpty
          ? const Text('لا توجد نتائج')
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              itemCount: widget.results.length,
              itemBuilder: (BuildContext context, int index) {
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
                          children: <Widget>[
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30.0,
                        ),
                      ),
                      if (widget.title.isNotEmpty)
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                          ),
                        ),
                      const Divider(),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
