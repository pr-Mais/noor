import 'package:flutter/material.dart';
import 'package:noor/components/dialog_button.dart';
import 'package:noor/pages/tabs/page_3_counter/counter_list_view.dart';

import 'editable_text_max_length_highlighter.dart';

class AddDialog extends StatefulWidget {
  const AddDialog(
    this.context, {
    Key? key,
    this.mainContent = '',
    this.mainContentMaxLength,
    this.secondaryContent = '',
    this.onSave,
    this.onCancel,
    this.enableSecondaryContent = false,
  }) : super(key: key);
  final BuildContext context;
  final String mainContent;
  final String secondaryContent;
  final int? mainContentMaxLength;
  final void Function(String)? onSave;
  final void Function()? onCancel;
  final bool enableSecondaryContent;

  static AddDialog of(BuildContext context) {
    return AddDialog(context);
  }

  Future<bool?> show({
    String mainContent = '',
    String secondaryContent = '',
    void Function(String)? onSave,
    void Function()? onCancel,
    bool enableSecondaryContent = false,
    bool barrierDismissible = true,
    final int? mainContentMaxLength,
  }) async {
    return await showGeneralDialog(
      transitionDuration: const Duration(milliseconds: 600),
      barrierColor: Colors.black.withOpacity(0.75),
      barrierLabel: '',
      barrierDismissible: barrierDismissible,
      context: context,
      transitionBuilder: (_, Animation<double> a1, Animation<double> a2, __) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 800, 0.0),
          child: AddDialog(
            context,
            mainContent: mainContent,
            mainContentMaxLength: mainContentMaxLength,
            secondaryContent: secondaryContent,
            onSave: onSave,
            onCancel: onCancel,
            enableSecondaryContent: enableSecondaryContent,
          ),
        );
      },
      pageBuilder: (_, __, ___) => const SizedBox(),
    );
  }

  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  late TextFieldMaxLengthHighlighter mainContentController;
  late TextEditingController secondaryContentController;
  bool mainContentActive = false;

  @override
  void initState() {
    super.initState();
    mainContentController = TextFieldMaxLengthHighlighter(
      text: widget.mainContent,
      maxLength: widget.mainContentMaxLength,
    );

    secondaryContentController =
        TextEditingController(text: widget.secondaryContent);

    mainContentController.addListener(() {
      setState(() {
        if (mainContentController.text.isEmpty ||
            mainContentController.text.length > kMaxLength) {
          mainContentActive = false;
        } else {
          mainContentActive = true;
        }
      });
    });
  }

  button({
    required String text,
    required BorderRadiusGeometry radius,
    void Function()? onPressed,
    BoxBorder? border,
    Color? textColor,
  }) {
    return DialogButton(
      label: text,
      border: border,
      onPressed: onPressed,
      radius: radius,
      textColor: textColor,
    );
  }

  // Text input design (used in dialoges)
  input(double height, String text, TextEditingController controller) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: SingleChildScrollView(
        child: TextField(
          autofocus: true,
          controller: controller,
          style: Theme.of(context).textTheme.bodyText1,
          decoration: InputDecoration(
            filled: false,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 10.0),
            border: InputBorder.none,
            hintText: text,
            counterText: "",
          ),
          maxLines: 3,
          minLines: 3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 6.0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : const Color(0xff1B2349),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  input(100.0, 'أضِف ذِكر...', mainContentController),
                  if (widget.enableSecondaryContent) const Divider(),
                  if (widget.enableSecondaryContent)
                    input(80.0, 'نص إضافي...', secondaryContentController),
                  if (widget.enableSecondaryContent) const SizedBox(height: 40)
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                constraints: const BoxConstraints.expand(height: 40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    button(
                      text: 'حفظ',
                      border: Border(
                        left: BorderSide(
                            width: 0.5, color: Theme.of(context).cardColor),
                      ),
                      radius: const BorderRadius.only(
                          bottomRight: Radius.circular(15)),
                      onPressed: !mainContentActive
                          ? null
                          : () =>
                              widget.onSave?.call(mainContentController.text),
                    ),
                    button(
                      text: 'إلغاء',
                      border: Border(
                        right: BorderSide(
                            width: 0.5, color: Theme.of(context).cardColor),
                      ),
                      textColor: Colors.white,
                      radius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15)),
                      onPressed: widget.onCancel,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    );
  }
}
