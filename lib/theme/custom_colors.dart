import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.selectedRowColor,
  });

  final Color? selectedRowColor;

  @override
  CustomColors copyWith({Color? selectedRowColor}) {
    return CustomColors(
      selectedRowColor: selectedRowColor,
    );
  }

  @override
  CustomColors lerp(CustomColors? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      selectedRowColor: Color.lerp(selectedRowColor, other.selectedRowColor, t),
    );
  }

  @override
  String toString() => 'CustomColors(selectedRowColor: $selectedRowColor)';
}
