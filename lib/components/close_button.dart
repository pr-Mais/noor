import 'package:flutter/material.dart';

class NoorCloseButton extends StatelessWidget {
  const NoorCloseButton({
    Key key,
    this.size,
    this.color,
  }) : super(key: key);
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.close_rounded,
        color: color ?? Colors.white,
        size: size,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
