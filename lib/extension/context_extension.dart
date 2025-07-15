import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;

  double get height => MediaQuery.sizeOf(this).height;

  void get hideKeyboard => FocusScope.of(this).unfocus();

  void get nextField => FocusScope.of(this).nextFocus();
  Widget heightSize(double percentage) => SizedBox(height: height * percentage);

  Widget widthSize(double percentage) => SizedBox(width: width * percentage);
}
