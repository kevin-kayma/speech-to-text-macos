import 'dart:math';

import 'package:flutter/material.dart';
import 'package:transcribe/extension/context_extension.dart';

extension DoubleExtension on double {
  /// Leaves given height of space
  double height(BuildContext context) => context.height * (this / 100);

  /// Leaves given width of space
  double width(BuildContext context) => context.width * (this / 100);

  String get getFileSizeString {
    const suffixes = ['b', 'kb', 'mb', 'gb', 'tb'];
    var i = (log(this) / log(1024)).floor();
    return ((this / pow(1024, i)).toStringAsFixed(2)) + suffixes[i].toUpperCase();
  }
}
