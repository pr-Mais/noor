import 'package:flutter/material.dart';

extension ToColorFilter on Color? {
  ColorFilter? toColorFilter([BlendMode mode = BlendMode.srcIn]) {
    final color = this;
    if (color == null) return null;

    return ColorFilter.mode(color, mode);
  }
}
