import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key key,
    this.onDelete,
  }) : super(key: key);

  final Function onDelete;

  // TODO(Mais): Refactor 
  button({String text, BoxBorder border, BorderRadiusGeometry radius, Color textColor, Function onPress}) {
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 6.0,
      child: Container(
        constraints: BoxConstraints(maxHeight: 130),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Text(
                    'تأكيد الحذف',
                    style: TextStyle(
                        color: Colors.lightBlue[300],
                        fontSize: 18,
                        fontFamily: 'SST'),
                  ),
                  Text('هل أنت مُتأكد من رغبتك في الحذف؟')
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
                          text: 'حذف',
                          border: Border(
                              left:
                                  BorderSide(width: 0.5, color: Colors.white)),
                          radius: BorderRadius.only(
                              bottomRight: Radius.circular(15)),
                          textColor: Colors.lightBlue[100],
                          onPress: () async {
                            onDelete();
                            Navigator.of(context).pop();
                          }),
                      button(
                          text: 'إلغاء',
                          border: Border(
                              right:
                                  BorderSide(width: 0.5, color: Colors.white)),
                          radius: BorderRadius.only(
                              bottomLeft: Radius.circular(15)),
                          textColor: Colors.white,
                          onPress: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                ))
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    );
  }
}
