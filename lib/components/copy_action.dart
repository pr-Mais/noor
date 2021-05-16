import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:noor/exports/constants.dart' show Images;

class CopyAction extends StatelessWidget {
  const CopyAction(this.text, {Key? key}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.asset(Images.copyIcon),
      onTap: () => onCopy(text, context),
    );
  }

  static void onCopy(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    showGeneralDialog(
      barrierLabel: 'Label',
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.2),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            alignment: Alignment.center,
            height: 60,
            child: Text(
              'تم النسخ بنجاح',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'SST Light',
                fontSize: 17,
                decoration: TextDecoration.none,
              ),
            ),
            margin: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
            decoration: BoxDecoration(
              color: const Color(0xff6f85d5),
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: <BoxShadow>[
                BoxShadow(blurRadius: 5, color: Colors.black26),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (_, Animation<double> anim1, __, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 0.6), end: Offset(0, 0))
              .animate(CurvedAnimation(
            parent: anim1,
            curve: Curves.easeOutCirc,
            reverseCurve: Curves.easeIn,
          )),
          child: child,
        );
      },
    );
    Future<void>.delayed(Duration(milliseconds: 1000)).then((_) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    });
  }
}
