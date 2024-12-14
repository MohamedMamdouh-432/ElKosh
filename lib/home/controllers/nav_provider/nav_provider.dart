import 'package:elkosh/cart/screens/cart_screen.dart';
import 'package:elkosh/home/screens/home_screen.dart';
import 'package:elkosh/settings/screens/setting_screen.dart';
import 'package:flutter/material.dart';

class NavProvider extends ChangeNotifier {
  int curIdx = 0;
  final PageController pageController = PageController(initialPage: 0);
  final List<Widget> pages = [
    const HomeScreen(),
    const CartScreen(),
    const SettingScreen()
  ];

  void navToPage(int idx) {
    curIdx = idx;
    pageController.jumpToPage(idx);
    notifyListeners();
  }

  void animateToPage(idx) {
    curIdx = idx;
    pageController.animateToPage(
      idx,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 500),
    );
    notifyListeners();
  }
}
