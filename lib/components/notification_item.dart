import 'package:flutter/material.dart';
import 'package:noor/exports/components.dart' show SubtitleWithIcon;

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    Key? key,
    required this.text,
    required this.icon,
    required this.enabled,
    this.onTap,
    required this.onChanged,
    this.time,
  }) : super(key: key);

  final String text;
  final String icon;
  final bool enabled;
  final Function()? onTap;
  final Function(bool) onChanged;
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SubtitleWithIcon(
          text: text,
          icon: icon,
        ),
        enabled && time != null
            ? SizedBox(
                width: 100,
                height: 30,
                child: GestureDetector(
                  onTap: onTap,
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
                      time!,
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
