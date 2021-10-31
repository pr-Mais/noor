import 'package:flutter/material.dart';

class AddDialog extends StatefulWidget {
  const AddDialog(
    this.context, {
    Key? key,
    this.mainContent = '',
    this.secondaryContent = '',
    this.onSave,
    this.onCancel,
    this.enableSecondaryContent = false,
  }) : super(key: key);
  final BuildContext context;
  final String mainContent;
  final String secondaryContent;
  final Function()? onSave;
  final Function()? onCancel;
  final bool enableSecondaryContent;

  static AddDialog of(BuildContext context) {
    return AddDialog(context);
  }

  Future<bool?> show({
    String mainContent = '',
    String secondaryContent = '',
    Function()? onSave,
    Function()? onCancel,
    bool enableSecondaryContent = false,
  }) async {
    return await showGeneralDialog(
      transitionDuration: const Duration(milliseconds: 600),
      barrierColor: Colors.black.withOpacity(0.75),
      barrierLabel: '',
      context: context,
      transitionBuilder: (_, Animation<double> a1, Animation<double> a2, __) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 800, 0.0),
          child: AddDialog(
            context,
            mainContent: mainContent,
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
  late TextEditingController mainContentController;
  late TextEditingController secondaryContentController;

  @override
  void initState() {
    super.initState();
    mainContentController = TextEditingController(text: widget.mainContent);
    secondaryContentController =
        TextEditingController(text: widget.secondaryContent);
  }

  button(
      {required String text,
      BoxBorder? border,
      required BorderRadiusGeometry radius,
      Color? textColor,
      Function? onPress}) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(border: border),
        // ignore: deprecated_member_use
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: radius),
          elevation: 0.0,
          focusElevation: 0.0,
          highlightElevation: 0.0,
          hoverElevation: 0.0,
          splashColor: Colors.white24,
          highlightColor: Colors.white24,
          onPressed: onPress as void Function()?,
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
          ),
          keyboardType: TextInputType.multiline,
          maxLines: 20,
          minLines: 1,
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
        //constraints: BoxConstraints(maxHeight: 360, minHeight: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  input(150.0, 'أضِف ذِكر...', mainContentController),
                  if (widget.enableSecondaryContent) const Divider(),
                  if (widget.enableSecondaryContent)
                    input(100.0, 'نص إضافي...', secondaryContentController),
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
                      border: const Border(
                          left: BorderSide(width: 0.5, color: Colors.white)),
                      radius: const BorderRadius.only(
                          bottomRight: Radius.circular(15)),
                      textColor: Colors.lightBlue[100],
                      onPress: () => widget.onSave,
                    ),
                    button(
                      text: 'إلغاء',
                      border: const Border(
                          right: BorderSide(width: 0.5, color: Colors.white)),
                      radius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15)),
                      textColor: Colors.white,
                      onPress: widget.onCancel,
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
