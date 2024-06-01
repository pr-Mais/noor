import 'package:flutter/material.dart';

import 'dialog_button.dart';

class NoorAlertDialog extends StatelessWidget {
  const NoorAlertDialog(
    this.context, {
    Key? key,
    this.title = '',
    this.content = '',
  }) : super(key: key);
  final String title;
  final String content;
  final BuildContext context;

  static NoorAlertDialog of(BuildContext context) {
    return NoorAlertDialog(context);
  }

  Future<bool?> show({
    required String title,
    required String content,
  }) async {
    return await showGeneralDialog(
      transitionDuration: const Duration(milliseconds: 600),
      barrierColor: Colors.black.withOpacity(0.75),
      barrierLabel: '',
      barrierDismissible: true,
      context: context,
      transitionBuilder: (_, Animation<double> a1, Animation<double> a2, __) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 800, 0.0),
          child: NoorAlertDialog(
            context,
            title: title,
            content: content,
          ),
        );
      },
      pageBuilder: (_, __, ___) => const SizedBox(),
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
    return Dialog(
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 130),
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(content)
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
                      label: 'إلغاء',
                      textColor: Colors.white,
                      onPressed: () async {
                        Navigator.of(context).pop(false);
                      },
                      radius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
