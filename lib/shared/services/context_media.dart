import 'package:flutter/material.dart';

extension ContextMedia on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
  double get bottomInsets => MediaQuery.viewInsetsOf(this).bottom;
}
