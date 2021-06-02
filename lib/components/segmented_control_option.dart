import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noor/exports/components.dart' show SubtitleWithIcon;

class SegmentedControlOption extends StatelessWidget {
  const SegmentedControlOption({
    Key? key,
    required this.icon,
    required this.title,
    required this.onChanged,
    required this.value,
  }) : super(key: key);

  final String icon;
  final String title;
  final void Function(String?) onChanged;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SubtitleWithIcon(text: title, icon: icon),
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            width: 130,
            margin: EdgeInsets.symmetric(horizontal: 30.0),
            child: CupertinoSlidingSegmentedControl<String>(
              padding: EdgeInsets.all(3),
              thumbColor: Theme.of(context).primaryColor,
              children: <String, Widget>{
                'strong': Text(
                  'قوي',
                  style: TextStyle(
                    color: value == 'strong' ? Colors.white : Colors.grey,
                    fontSize: 11,
                  ),
                ),
                'light': Text(
                  'خفيف',
                  style: TextStyle(
                    color: value == 'light' ? Colors.white : Colors.grey,
                    fontSize: 11,
                  ),
                ),
                'none': Text(
                  'إيقاف',
                  style: TextStyle(
                    color: value == 'none' ? Colors.white : Colors.grey,
                    fontSize: 11,
                  ),
                )
              },
              groupValue: value,
              onValueChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
