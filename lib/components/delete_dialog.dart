// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'dialog_button.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog(
    this.context, {
    Key? key,
  }) : super(key: key);
  final BuildContext context;

  static DeleteConfirmationDialog of(BuildContext context) {
    return DeleteConfirmationDialog(context);
  }

  Future<bool?> show() async {
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
          child: DeleteConfirmationDialog(context),
        );
      },
      pageBuilder: (_, __, ___) => const SizedBox(),
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
                    'تأكيد الحذف',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('هل أنت مُتأكد من رغبتك في الحذف؟')
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
                      label: 'حذف',
                      border: Border(
                        left: BorderSide(
                            width: 0.5, color: Theme.of(context).cardColor),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                      },
                      radius: const BorderRadius.only(
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    DialogButton(
                      label: 'إلغاء',
                      textColor: Colors.white,
                      border: Border(
                        right: BorderSide(
                            width: 0.5, color: Theme.of(context).cardColor),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop(false);
                      },
                      radius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
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
