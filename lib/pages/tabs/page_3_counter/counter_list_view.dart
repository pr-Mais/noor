import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noor/components/add_dialog.dart';
import 'package:noor/components/alert_dialog.dart';
import 'package:noor/components/delete_dialog.dart';
import 'package:noor/exports/constants.dart';
import 'package:noor/exports/controllers.dart';
import 'package:noor/exports/pages.dart';
import 'package:noor/pages/tabs/page_3_counter/counter_view_model.dart';
import 'package:noor/utils/build_context.dart';
import 'package:noor/utils/to_arabic.dart';
import 'package:provider/provider.dart';

const kMaxLength = 75;

LinearGradient lightModeCounterBG = const LinearGradient(
  colors: <Color>[
    Color(0xff9AE2F6),
    Color(0xff48C6EF),
  ],
  begin: Alignment.bottomRight,
  end: Alignment.topLeft,
);

LinearGradient darkModeCounterBG = const LinearGradient(
  colors: <Color>[
    Color(0xff9FB6FF),
    Color(0xff6C6CD3),
  ],
  begin: Alignment.bottomRight,
  end: Alignment.topLeft,
);

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

  onTap(SubhaItem item) {
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
    } else if (item.locked) {
      NoorAlertDialog.of(context).show(
        title: 'عُــذراً',
        content: 'لا يمكن حذف الأذكار المُقترحة',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final counterModel = context.watch<CounterViewModel>();
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            context.read<ThemeModel>().images.subhaBg,
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          Column(
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
                    return SubhaListItem(
                      item: item,
                      isEditMode: isEditMode,
                      onDelete: onDelete,
                      onTap: onTap,
                    );
                  },
                ),
              )
            ],
          ),
        ],
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
                  .displayMedium!
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

class SubhaListItem extends StatelessWidget {
  const SubhaListItem({
    Key? key,
    required this.item,
    required this.onTap,
    required this.onDelete,
    this.isEditMode = false,
  }) : super(key: key);

  final SubhaItem item;
  final bool isEditMode;
  final Function(SubhaItem) onTap;
  final Function(SubhaItem) onDelete;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(50);
    final settings = context.watch<AppSettings>();
    final theme = context.watch<ThemeModel>();

    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: isEditMode ? null : () => onTap(item),
        borderRadius: BorderRadius.circular(8.0),
        splashColor: Colors.transparent,
        highlightColor: context.customColors?.selectedRowColor,
        child: Container(
          constraints: const BoxConstraints(minHeight: 80),
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(viewPadding),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: Color(theme.colors.subhaListItemBg),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: item.selected
                    ? context.customColors?.selectedRowColor ?? Colors.black
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
                  textScaler: TextScaler.linear(settings.fontSize),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: context.read<AppSettings>().fontType,
                      height: 1.4),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: 8.0),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: SizedBox(
                  height: 40,
                  child: AnimatedContainer(
                    width: isEditMode ? 40 : 90,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      gradient: isEditMode
                          ? LinearGradient(
                              colors: item.locked
                                  ? [
                                      Color(theme.colors.subhaLockBg),
                                      Color(theme.colors.subhaLockBg)
                                    ]
                                  : [Colors.red, Colors.red],
                            )
                          : Theme.of(context).brightness == Brightness.dark
                              ? darkModeCounterBG
                              : lightModeCounterBG,
                      borderRadius: borderRadius,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        borderRadius: borderRadius,
                        onTap: !isEditMode ? null : () => onDelete(item),
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          decoration: BoxDecoration(
                            borderRadius: borderRadius,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Center(
                              child: isEditMode
                                  ? item.locked
                                      ? SvgPicture.asset(
                                          NoorIcons.subhaLock,
                                          width: 40,
                                        )
                                      : Image.asset(
                                          Images.eraseIcon,
                                          height: 40,
                                        )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        '${item.counter}'.arabicDigit(),
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
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
  }
}
