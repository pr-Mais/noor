import 'package:flutter/material.dart';
import 'package:noor/components/add_dialog.dart';
import 'package:noor/exports/constants.dart';
import 'package:noor/exports/controllers.dart';
import 'package:noor/exports/pages.dart';
import 'package:noor/pages/tabs/3_counter/counter_view_model.dart';
import 'package:provider/provider.dart';
import 'package:noor/utils/to_arabic.dart';

class CounterListView extends StatefulWidget {
  CounterListView({Key? key}) : super(key: key);

  @override
  _CounterListViewState createState() => _CounterListViewState();
}

class _CounterListViewState extends State<CounterListView> {
  bool isEditMode = false;
  late CounterModel counterModel;

  @override
  void didChangeDependencies() {
    counterModel = context.watch<CounterModel>();
    super.didChangeDependencies();
  }

  showDialog() async {
    await AddDialog.of(context).show(
      enableSecondaryContent: true,
      onSave: () {},
      onCancel: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.dark
              ? darkModeBG
              : lightModeBG,
        ),
        child: Column(
          children: <Widget>[
            appBar(),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (_, __) => SizedBox(height: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                itemCount: counterModel.subhaList.length,
                itemBuilder: (_, int index) {
                  SubhaItem item = counterModel.subhaList[index];
                  return Container(
                    constraints: BoxConstraints(minHeight: 80),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: item.selected
                              ? Theme.of(context).accentColor
                              : Colors.transparent,
                          spreadRadius: 6,
                        )
                      ],
                    ),
                    margin: EdgeInsets.all(5.0),
                    padding: EdgeInsets.all(20.0),
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          item.key,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.black),
                        ),
                        SizedBox(
                          height: 30,
                          child: AnimatedContainer(
                            width: isEditMode ? 30 : 70,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              gradient: isEditMode
                                  ? LinearGradient(
                                      colors: [
                                        Colors.red,
                                        Colors.red,
                                      ],
                                    )
                                  : LinearGradient(
                                      colors: [
                                        Theme.of(context).primaryColor,
                                        Colors.blue
                                      ],
                                    ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Container(
                                child: Center(
                                  child: isEditMode
                                      ? Image.asset(
                                          Images.eraseIcon,
                                        )
                                      : Text(
                                          '${item.counter}'.arabicDigit(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: isEditMode
                  ? NoorIconButton(
                      key: ValueKey<bool>(isEditMode),
                      icon: context.read<ThemeModel>().images.addMyAd3yah,
                      onPressed: () {
                        if (isEditMode) {
                          setState(() {
                            isEditMode = false;
                          });
                        } else {
                          showDialog();
                        }
                      },
                    )
                  : NoorIconButton(
                      key: ValueKey<bool>(isEditMode),
                      icon: Images.editeIcon,
                      onPressed: () {
                        setState(() {
                          isEditMode = true;
                        });
                      },
                    ),
            ),
            Text(
              'قائمة الأذكار',
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            NoorIconButton(
              icon: Icons.close_rounded,
              onPressed: () {
                if (isEditMode) {
                  setState(() {
                    isEditMode = false;
                  });
                } else {
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
