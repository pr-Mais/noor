import 'dart:math';

import 'package:flutter/material.dart';
import 'package:noor/components/dialog_button.dart';

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

class _AddDialogState extends State<AddDialog>
    with SingleTickerProviderStateMixin {
  late TextFieldMaxLengthHighlighter mainContentController;
  late TextEditingController secondaryContentController;
  bool mainContentActive = false;

  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  late Animation<double> curve;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    mainContentController = TextFieldMaxLengthHighlighter(
      text: widget.mainContent,
      maxLength: widget.mainContentMaxLength,
    );

    secondaryContentController =
        TextEditingController(text: widget.secondaryContent);
    if (widget.mainContentMaxLength != null) {
      curve = Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ),
      );

      mainContentController.addListener(() async {
        if (mainContentController.text.length > widget.mainContentMaxLength! &&
            mainContentActive) {
          _controller.forward(from: 0.0);
        }

        setState(() {
          if (mainContentController.text.isEmpty ||
              mainContentController.text.length >
                  widget.mainContentMaxLength!) {
            mainContentActive = false;
          } else {
            mainContentActive = true;
          }
        });
      });
    }
  }

  // Text input design (used in dialoges)
  input(double height, String text, TextEditingController controller) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: SingleChildScrollView(
        child: TextField(
          autofocus: true,
          controller: controller,
          style: Theme.of(context).textTheme.bodyLarge,
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
    return AnimatedBuilder(
      animation: curve,
      builder: (BuildContext context, Widget? child) {
        final dx = sin(_controller.value * 2 * pi) * 10.0;
        return Transform.translate(
          offset: Offset(dx, 0),
          child: child,
        );
      },
      child: Dialog(
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
                    if (widget.enableSecondaryContent)
                      const SizedBox(height: 40)
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
                      DialogButton(
                        label: 'حفظ',
                        border: Border(
                          left: BorderSide(
                            width: 0.5,
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                        radius: const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                        ),
                        onPressed: !mainContentActive
                            ? null
                            : () =>
                                widget.onSave?.call(mainContentController.text),
                        textColor: Colors.lightBlue[100],
                      ),
                      DialogButton(
                        label: 'إلغاء',
                        border: Border(
                          right: BorderSide(
                            width: 0.5,
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                        onPressed: widget.onCancel,
                        radius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                        ),
                        textColor: Colors.white,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }
}
