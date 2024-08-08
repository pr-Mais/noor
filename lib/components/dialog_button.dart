import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.radius,
    this.border,
    this.textColor,
  }) : super(key: key);

  final Function()? onPressed;
  final String label;
  final BorderRadiusGeometry? radius;
  final BoxBorder? border;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(border: border),
        child: ElevatedButton(
          style: radius == null
              ? null
              : ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: radius!),
                ),
          onPressed: onPressed,
          child: DefaultTextStyle.merge(
            child: Text(
              label,
              textScaler: const TextScaler.linear(1),
              style: TextStyle(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
