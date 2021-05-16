import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    this.title,
    this.icon,
    this.onTap,
  }) : super(key: key);
  final String? title;
  final String? icon;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Material(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[100]
                : Color(0xff33477f).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            clipBehavior: Clip.hardEdge,
            child: ListTile(
              onTap: onTap as void Function()?,
              title: Text(
                title!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'SST Roman',
                  fontSize: 16,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 22,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[300]
                    : Color(0xff33477f),
              ),
              leading: Image.asset(
                icon!,
                width: 40,
              ),
            ),
          ),
          margin: EdgeInsets.only(
            top: 5.0,
            bottom: 5.0,
            left: 10.0,
            right: 10.0,
          ),
        ),
        Padding(
          child: Divider(),
          padding: EdgeInsets.symmetric(horizontal: 30.0),
        )
      ],
    );
  }
}
