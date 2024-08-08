import 'package:flutter/material.dart';
import 'package:noor/theme/custom_colors.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get themeData => Theme.of(this);

  CustomColors? get customColors => themeData.extension<CustomColors>();
}
