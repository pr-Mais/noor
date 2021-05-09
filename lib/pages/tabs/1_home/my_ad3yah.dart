import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noor/components/abstract_card.dart';
import 'package:noor/components/close_button.dart';
import 'package:noor/components/custom_dialog.dart';
import 'package:noor/components/image_button.dart';
import 'package:noor/constants/ribbons.dart';
import 'package:noor/models/doaa.dart';
import 'package:noor/providers/data_provider.dart';
import 'package:noor/providers/settings_provider.dart';
import 'package:noor/providers/theme_provider.dart';
import 'package:noor/services/db.dart';
import 'package:noor/utils/copy.dart';
import 'package:noor/utils/remove_tashkeel.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/data_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../services/prefs.dart';

class MyAd3yah extends StatefulWidget {
  MyAd3yah({Key key, this.index = 0}) : super(key: key);
  final index;
  _MyAd3yahState createState() => _MyAd3yahState();
}

class _MyAd3yahState extends State<MyAd3yah> with TickerProviderStateMixin {
  TextEditingController _firstController = new TextEditingController();
  TextEditingController _secondController = new TextEditingController();
  ScrollController controller;
  Widget animatedWidget;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  void initState() {
    super.initState();
    controller = ScrollController(initialScrollOffset: widget.index * 380.0);
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  //text input design (used in dialoges)
  input(maxHeight, minHeight, text, controller) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight, minHeight: minHeight),
      child: SingleChildScrollView(
        child: TextField(
          controller: controller,
          style: Theme.of(context).textTheme.body1,
          decoration: InputDecoration(
            filled: false,
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10.0),
            border: InputBorder.none,
            hintText: text,
          ),
          keyboardType: TextInputType.multiline,
          maxLines: 20,
          minLines: 1,
        ),
      ),
    );
  }

  //button design (used in dialoges)
  button({text, border, radius, textColor, onPress}) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(border: border),
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: radius),
          elevation: 0.0,
          focusElevation: 0.0,
          highlightElevation: 0.0,
          hoverElevation: 0.0,
          splashColor: Colors.white24,
          highlightColor: Colors.white24,
          onPressed: onPress,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w300,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  //add dailog
  addDoaa({
    id,
    data,
  }) {
    if (data != null) {
      _firstController.text = data.text;
      _secondController.text = data.info;
    }
    showGeneralDialog(
        transitionDuration: Duration(milliseconds: 600),
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.75),
        barrierLabel: '',
        context: context,
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 800, 0.0),
            child: Dialog(
              elevation: 6.0,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light ? Colors.white : Color(0xff1B2349),
                    borderRadius: BorderRadius.circular(15.0)),
                constraints: BoxConstraints(maxHeight: 360),
                child: Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          input(200.0, 200.0, 'أضِف ذِكر..', _firstController),
                          Divider(),
                          input(100.0, 100.0, 'نص إضافي..', _secondController),
                          SizedBox(
                            height: 40,
                          )
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          constraints: BoxConstraints.expand(height: 40),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              button(
                                  text: 'حفظ',
                                  border: Border(left: BorderSide(width: 0.5, color: Colors.white)),
                                  radius: BorderRadius.only(bottomRight: Radius.circular(15)),
                                  textColor: Colors.lightBlue[100],
                                  onPress: () async {
                                    if (data != null) {
                                      data.text = _firstController.text;
                                      data.info = _secondController.text;
                                      update(data);
                                    } else {
                                      Doaa doaa = Doaa(
                                        text: _firstController.text,
                                        info: _secondController.text,
                                        section: 5,
                                        sectionName: 'أدعيتي',
                                        isFav: 0,
                                      );
                                      insert(doaa);
                                    }
                                    Navigator.of(context).pop();
                                  }),
                              button(
                                  text: 'إلغاء',
                                  border: Border(right: BorderSide(width: 0.5, color: Colors.white)),
                                  radius: BorderRadius.only(bottomLeft: Radius.circular(15)),
                                  textColor: Colors.white,
                                  onPress: () {
                                    Navigator.of(context).pop();
                                    _firstController.clear();
                                    _secondController.clear();
                                  }),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            ),
          );
        },
        pageBuilder: (context, animation1, animation2) {});
  }

  //delete dialog confirmation
  deleteDialog(dataToDelete) {
    showGeneralDialog(
        transitionDuration: Duration(milliseconds: 600),
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.75),
        barrierLabel: '',
        context: context,
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
              transform: Matrix4.translationValues(0.0, curvedValue * 800, 0.0),
              child: CustomDialog(
                onDelete: () => delete(dataToDelete),
              ));
        },
        pageBuilder: (context, animation1, animation2) {});
    _firstController.clear();
    _secondController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final images = context.read<ThemeProvider>().images;
    final provider = Provider.of<DataProvider>(context);

    final List<Doaa> myAd3yah =
        provider.list.reversed.where((element) => element is Doaa && element.section == 5).toList().cast<Doaa>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SvgPicture.asset(images.myAd3yahBg, fit: BoxFit.fill),
          SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ImageButton(
                        image: images.addMyAd3yah,
                        onTap: addDoaa,
                        width: 45,
                        height: 45,
                      ),
                      Text(
                        'أدعيتي',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      NoorCloseButton(size: 35)
                    ],
                  ),
                ),
                SizedBox(height: 35),
                Expanded(
                                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 400),
                    child: myAd3yah.isNotEmpty
                        ?  CustomScrollView(
                              slivers: <Widget>[
                                ReorderableSliverList(
                                  key: ValueKey<String>('list'),
                                  controller: controller,
                                  buildDraggableFeedback: (_, BoxConstraints constraints, Widget child) {
                                    return Material(
                                      type: MaterialType.transparency,
                                      child: SizedBox(width: constraints.maxWidth, child: child),
                                    );
                                  },
                                  delegate: ReorderableSliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return card(myAd3yah[index]);
                                    },
                                    childCount: myAd3yah.length,
                                  ),
                                  onReorder: (from, to) async {
                                    final tmpFrom = myAd3yah[from];
                                    final tmpTo = myAd3yah[to];

                                    await provider.updateMyAd3yahList(tmpFrom, tmpTo);

                                    if (tmpFrom.isFav == 1) {
                                      provider.favList[provider.favList.indexOf(tmpFrom.id)] = tmpTo.id;
                                    }

                                    if (tmpTo.isFav == 1) {
                                      provider.favList[provider.favList.indexOf(tmpTo.id)] = tmpFrom.id;
                                    }

                                    SharedPrefsUtil.putStringList('fav', provider.favList);
                                  },
                                ),
                              ],
                            
                          )
                        : Image.asset(images.noAd3yah),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void insert(Doaa doaa) {
    final provider = Provider.of<DataProvider>(context, listen: false);
    _firstController.clear();
    _secondController.clear();
    provider.insert(doaa);
  }

  void delete(Doaa doaa) {
    final provider = Provider.of<DataProvider>(context, listen: false);

    provider.remove(doaa);
  }

  void update(Doaa doaa) {
    final provider = Provider.of<DataProvider>(context, listen: false);
    print(doaa.text);
    provider.update(doaa);
  }

  Widget card(Doaa item) {
    final provider = Provider.of<DataProvider>(context);
    final settings = context.read<SettingsProvider>();
    return CardTemplate(
      ribbon: Ribbon.ribbon5,
      key: ValueKey(item),
      actions: <Widget>[
        GestureDetector(
          onTap: () async {
            item.isFav == 1 ? provider.removeFromFav(item) : provider.addToFav(item);
            await DBService.db.update(item);
          },
          child: AnimatedCrossFade(
            firstChild: Image.asset('assets/icons/outline_heart.png'),
            secondChild: Image.asset('assets/icons/filled_heart.png'),
            crossFadeState: item.isFav == 1 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 500),
          ),
        ),
        GestureDetector(
          child: Image.asset('assets/icons/edite.png'),
          onTap: () => addDoaa(data: item),
        ),
        GestureDetector(
          child: Image.asset('assets/icons/copy.png'),
          onTap: () => Copy.onCopy(item.text, context),
        ),
        GestureDetector(
          child: Image.asset('assets/icons/erase.png'),
          onTap: () => deleteDialog(item),
        ),
      ],
      child: Text(
        !context.read<SettingsProvider>().tashkeel ? Tashkeel.remove(item.text) : item.text,
        textAlign: TextAlign.justify,
        textDirection: TextDirection.rtl,
        textScaleFactor: settings.fontSize,
        style: TextStyle(
          fontSize: 16,
          fontFamily: settings.fontType,
          height: 1.8,
        ),
      ),
      additionalContent: Text(
        !context.read<SettingsProvider>().tashkeel ? Tashkeel.remove(item.info) : item.info,
        textAlign: TextAlign.justify,
        textDirection: TextDirection.rtl,
        textScaleFactor: settings.fontSize,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).primaryColor,
          fontFamily: settings.fontType,
          height: 1.6,
        ),
      ),
    );
  }
}
