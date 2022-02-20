import 'package:flutter/material.dart';

class TextFieldMaxLengthHighlighter extends TextEditingController {
  TextFieldMaxLengthHighlighter({String? text, this.maxLength})
      : super(text: text);

  final int? maxLength;

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    String allowedText = text;
    String nonAllowedText = '';

    if (maxLength != null && allowedText.length >= maxLength!) {
      allowedText = text.substring(0, maxLength!);
      nonAllowedText = text.substring(maxLength!);
    }

    return TextSpan(style: style, children: [
      TextSpan(text: allowedText),
      if (nonAllowedText.isNotEmpty)
        TextSpan(
          text: nonAllowedText,
          style: style?.copyWith(
            color: Colors.red,
          ),
        ),
    ]);
  }
}
