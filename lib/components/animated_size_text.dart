import 'package:flutter/material.dart';
import 'package:noor/exports/services.dart' show SharedPrefsService;

List<String> fonts = <String>['١٦', '١٨', '٢٠', '٢٢'];

TextStyle activeLabelStyle = const TextStyle(
  color: Color(0xff6db7e5),
  fontSize: 18,
  height: 1,
);
TextStyle inactiveLabelStyle = TextStyle(
  color: Colors.grey[400],
);

class AnimatedSizeText extends StatefulWidget {
  const AnimatedSizeText({
    Key? key,
    required this.index,
    required this.size,
  }) : super(key: key);

  final int index;
  final int size;

  @override
  _AnimatedSizeTextState createState() => _AnimatedSizeTextState();
}

class _AnimatedSizeTextState extends State<AnimatedSizeText>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      child: Text(
        fonts[widget.index],
        style: SharedPrefsService.getDouble('fontSize') * 16 == widget.size
            ? activeLabelStyle
            : inactiveLabelStyle,
      ),
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }
}
