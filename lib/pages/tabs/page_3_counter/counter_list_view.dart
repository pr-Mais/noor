import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:noor/components/add_dialog.dart';
import 'package:noor/components/delete_dialog.dart';
import 'package:noor/exports/constants.dart';
import 'package:noor/exports/controllers.dart';
import 'package:noor/exports/pages.dart';
import 'package:noor/pages/tabs/page_3_counter/counter_view_model.dart';
import 'package:provider/provider.dart';
import 'package:noor/utils/to_arabic.dart';

const kMaxLength = 80;

class CounterListView extends StatefulWidget {
  const CounterListView({Key? key}) : super(key: key);

  @override
  _CounterListViewState createState() => _CounterListViewState();
}

class _CounterListViewState extends State<CounterListView> {
  bool isEditMode = false;
  final scrollController = ScrollController();

  addDialog() async {
    final counterModel = context.read<CounterViewModel>();

    await AddDialog.of(context).show(
      enableSecondaryContent: false,
      mainContentMaxLength: kMaxLength,
      onSave: (content) {
        counterModel.addSubhaItem(
          SubhaItem(counter: 0, key: content, selected: false),
        );

        Navigator.of(context).pop();

        scrollController.animateTo(0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut);
      },
      onCancel: () {
        Navigator.of(context).pop();
      },
    );
  }

  onSelect(SubhaItem item) {
    final counterModel = context.read<CounterViewModel>();
    counterModel.setSelectedItem = item;

    Navigator.of(context).pop();
  }

  onDelete(SubhaItem item) async {
    final counterModel = context.read<CounterViewModel>();

    if (!item.locked && isEditMode) {
      final confirm = await DeleteConfirmationDialog.of(context).show();
      if (confirm ?? false) {
        counterModel.deleteSubhaItem(item);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final counterModel = context.watch<CounterViewModel>();
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
                controller: scrollController,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                itemCount: counterModel.subhaList.length,
                itemBuilder: (_, int index) {
                  SubhaItem item = counterModel.subhaList[index];
                  return Material(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: InkWell(
                      onTap: isEditMode ? null : () => onSelect(item),
                      borderRadius: BorderRadius.circular(8.0),
                      splashColor: Colors.transparent,
                      highlightColor: Theme.of(context).selectedRowColor,
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 80),
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(viewPadding),
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: item.selected
                                  ? Theme.of(context).selectedRowColor
                                  : Colors.transparent,
                              spreadRadius: 6,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                item.key,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                        color: Colors.black,
                                        fontFamily: context
                                            .read<SettingsModel>()
                                            .fontType,
                                        height: 1.2),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: SizedBox(
                                  height: 30,
                                  child: InkWell(
                                    onTap: () => onDelete(item),
                                    child: AnimatedContainer(
                                      width: isEditMode ? 30 : 70,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                      decoration: BoxDecoration(
                                        gradient: isEditMode
                                            ? LinearGradient(
                                                colors: item.locked
                                                    ? [
                                                        Colors.grey[400]!,
                                                        Colors.grey[400]!
                                                      ]
                                                    : [Colors.red, Colors.red],
                                              )
                                            : LinearGradient(
                                                colors: [
                                                  Theme.of(context)
                                                      .primaryColor,
                                                  Colors.blue
                                                ],
                                              ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        child: Center(
                                          child: isEditMode
                                              ? item.locked
                                                  ? Image.asset(
                                                      Images.eraseIcon)
                                                  : Image.asset(
                                                      Images.eraseIcon)
                                              : Text(
                                                  '${item.counter}'
                                                      .arabicDigit(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline2,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
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
          horizontal: viewPadding,
          vertical: 10.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isEditMode
                  ? NoorIconButton(
                      key: ValueKey<bool>(isEditMode),
                      icon: context.read<ThemeModel>().images.addMyAd3yah,
                      onPressed: addDialog,
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
