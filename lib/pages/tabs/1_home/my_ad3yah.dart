import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reorderables/reorderables.dart';

import 'package:noor/exports/controllers.dart' show ThemeModel, DataController;
import 'package:noor/exports/constants.dart' show Images, Ribbon;
import 'package:noor/exports/models.dart' show DataModel, Doaa;
import 'package:noor/exports/components.dart'
    show
        CardTemplate,
        NoorCloseButton,
        DeleteConfirmationDialog,
        ImageButton,
        CardText,
        CopyAction,
        FavAction;

class MyAd3yah extends StatefulWidget {
  MyAd3yah({Key? key, this.index = 0}) : super(key: key);
  final int index;
  _MyAd3yahState createState() => _MyAd3yahState();
}

class _MyAd3yahState extends State<MyAd3yah> with TickerProviderStateMixin {
  TextEditingController _firstController = new TextEditingController();
  TextEditingController _secondController = new TextEditingController();
  ScrollController? controller;
  Widget? animatedWidget;
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
  input(double maxHeight, double minHeight, String text,
      TextEditingController controller) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight, minHeight: minHeight),
      child: SingleChildScrollView(
        child: TextField(
          controller: controller,
          style: Theme.of(context).textTheme.body1,
          decoration: InputDecoration(
            filled: false,
            contentPadding:
                EdgeInsets.symmetric(vertical: 12, horizontal: 10.0),
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
  button({required text, border, required radius, textColor, onPress}) {
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
  addDoaa({id, data}) {
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
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Color(0xff1B2349),
                  borderRadius: BorderRadius.circular(15.0)),
              constraints: BoxConstraints(maxHeight: 360),
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        input(200.0, 200.0, 'أضِف ذِكر..', _firstController),
                        const Divider(),
                        input(100.0, 100.0, 'نص إضافي..', _secondController),
                        const SizedBox(height: 40)
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
                              border: Border(
                                  left: BorderSide(
                                      width: 0.5, color: Colors.white)),
                              radius: BorderRadius.only(
                                  bottomRight: Radius.circular(15)),
                              textColor: Colors.lightBlue[100],
                              onPress: () => onSave(prevDoaa: data),
                            ),
                            button(
                              text: 'إلغاء',
                              border: Border(
                                  right: BorderSide(
                                      width: 0.5, color: Colors.white)),
                              radius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15)),
                              textColor: Colors.white,
                              onPress: onCancel,
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
          ),
        );
      },
      pageBuilder: (_, __, ___) => SizedBox(),
    );
  }

  //delete dialog confirmation
  deleteDialog(Doaa dataToDelete) async {
    final bool? result = await DeleteConfirmationDialog.of(context).show();

    if (result == true) {
      GetIt.I<DataController>().remove(dataToDelete);
    }

    _firstController.clear();
    _secondController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Images images = context.read<ThemeModel>().images;
    final DataModel dataModel = Provider.of<DataModel>(context);

    final List<Doaa> myAd3yah = dataModel.myAd3yah;

    // Sort descendingly
    myAd3yah.sort((Doaa a, Doaa b) => b.id.compareTo(a.id));

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
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
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
                const SizedBox(height: 35),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 400),
                    child: myAd3yah.isNotEmpty
                        ? Scrollbar(
                            controller: controller,
                            child: CustomScrollView(
                              controller: controller,
                              slivers: <Widget>[
                                ReorderableSliverList(
                                  key: ValueKey<String>('list'),
                                  controller: controller,
                                  buildDraggableFeedback: (_,
                                      BoxConstraints constraints,
                                      Widget child) {
                                    return Material(
                                      type: MaterialType.transparency,
                                      child: SizedBox(
                                        width: constraints.maxWidth,
                                        child: child,
                                      ),
                                    );
                                  },
                                  delegate:
                                      ReorderableSliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return card(myAd3yah[index]);
                                    },
                                    childCount: myAd3yah.length,
                                  ),
                                  onReorder: (int from, int to) async {
                                    await GetIt.I<DataController>()
                                        .updateMyAd3yahList(from, to);
                                  },
                                ),
                              ],
                            ),
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

  onCancel() {
    _firstController.clear();
    _secondController.clear();
    Navigator.of(context).pop();
  }

  onSave({Doaa? prevDoaa}) async {
    Doaa doaa = Doaa.fromMap(
      <String, dynamic>{
        if (prevDoaa != null) 'id': prevDoaa.id,
        'text': _firstController.text,
        'info': _secondController.text,
        'sectionName': 'أدعيتي',
      },
    );
    if (prevDoaa != null) {
      GetIt.I<DataController>().update(doaa);
    } else {
      GetIt.I<DataController>().insert(doaa);
    }

    _firstController.clear();
    _secondController.clear();

    Navigator.of(context).pop();
  }

  Widget card(Doaa item) {
    return CardTemplate(
      ribbon: Ribbon.ribbon5,
      key: ValueKey<Doaa>(item),
      actions: <Widget>[
        FavAction(item),
        GestureDetector(
          child: Image.asset(Images.editeIcon),
          onTap: () => addDoaa(data: item),
        ),
        CopyAction(
            item.text + (item.info.isNotEmpty ? ('. ' + item.info) : '')),
        GestureDetector(
          child: Image.asset(Images.eraseIcon),
          onTap: () => deleteDialog(item),
        ),
      ],
      child: CardText(text: item.text),
      additionalContent: CardText(
        text: item.info,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
