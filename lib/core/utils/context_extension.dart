import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navkey = GlobalKey<NavigatorState>();

extension ContextExtension on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
  double get bottomInsets => MediaQuery.viewInsetsOf(this).bottom;
  double get viewPaddingTop => MediaQuery.of(this).viewPadding.top;
}
