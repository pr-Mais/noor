import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:noor/exports/components.dart' show SubtitleWithIcon;

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key? key,
    this.enabled = false,
    required this.title,
    required this.icon,
    required this.notificationTime,
    required this.onChanged,
    required this.onTimeTap,
  }) : super(key: key);

  final bool enabled;
  final String title;
  final String icon;
  final DateTime notificationTime;
  final GestureTapCallback? onTimeTap;
  final ValueChanged<bool>? onChanged;

  String formatTime(DateTime? dateTime) {
    return dateTime == null
        ? 'اختر وقت'
        : intl.DateFormat('h:mm a', 'ar').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SubtitleWithIcon(text: title, icon: icon),
        enabled
            ? SizedBox(
                width: 100,
                height: 30,
                child: GestureDetector(
                  onTap: onTimeTap,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5,
                        color: Theme.of(context).dividerColor,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      formatTime(notificationTime),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 12),
                    ),
                  ),
                ),
              )
            : Container(),
        Container(
          margin: EdgeInsets.only(left: 20.0),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Switch(
              value: enabled,
              activeColor: Theme.of(context).primaryColor,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
