import 'package:elkosh/cart/screens/cart_screen.dart';
import 'package:elkosh/home/screens/home_screen.dart';
import 'package:elkosh/settings/screens/setting_screen.dart';
import 'package:flutter/material.dart';

class NavProvider extends ChangeNotifier {
  int curIdx = 1;
  final PageController pageController = PageController(initialPage: 1);
  final List<Widget> pages = [
    const SettingScreen(),
    const HomeScreen(),
    const CartScreen(),
  ];

  void navToPage(int idx) {
    curIdx = idx;
    pageController.jumpToPage(idx);
    notifyListeners();
  }

  void animateToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    curIdx = index;
    notifyListeners();
  }
}
