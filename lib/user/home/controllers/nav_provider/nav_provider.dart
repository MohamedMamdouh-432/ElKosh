import 'package:elkosh/general/settings/screens/setting_screen.dart';
import 'package:elkosh/user/cart/screens/cart_screen.dart';
import 'package:elkosh/user/home/screens/home_screen.dart';
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
