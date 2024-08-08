import 'package:flutter/material.dart';

/// Used in [AddDialog].
class DialogTextInput extends StatelessWidget {
  const DialogTextInput({
    Key? key,
    required this.controller,
    this.maxHeight,
    this.minHeight,
    this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final double? maxHeight;
  final double? minHeight;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? double.infinity,
        minHeight: minHeight ?? 0,
      ),
      child: SingleChildScrollView(
        child: TextField(
          controller: controller,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            filled: false,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 10.0),
            border: InputBorder.none,
            hintText: hintText,
          ),
          keyboardType: TextInputType.multiline,
          maxLines: 20,
          minLines: 1,
        ),
      ),
    );
  }
}
