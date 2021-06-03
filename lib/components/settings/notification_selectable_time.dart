import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationSelectableTime extends StatelessWidget {
  const NotificationSelectableTime({
    Key? key,
    required this.onDateTimeChanged,
    required this.initialDateTime,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final DateTime initialDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        children: <Widget>[
          Container(
            height: 35,
            color: Theme.of(context).dialogTheme.backgroundColor,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 60,
                  child: TextButton(
                    child: Text(
                      'حفظ',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor,
                          fontSize: 12),
                    ),
                    onPressed: onPressed,
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: TextButton(
                    child: Text(
                      'إلغاء',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor,
                          fontSize: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      locale: Locale('ar'),
                      fontFamily: 'SST Arabic',
                      fontSize: 16,
                      color: Theme.of(context).textTheme.body1!.color,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  backgroundColor: Theme.of(context).cardColor,
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initialDateTime,
                  onDateTimeChanged: onDateTimeChanged,
                  minuteInterval: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
