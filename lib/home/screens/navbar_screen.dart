import 'package:elkosh/cart/screens/cart_screen.dart';
import 'package:elkosh/home/screens/home_screens.dart';
import 'package:elkosh/settings/screens/setting_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int currentIndex = 0;
  final PageController pageController = PageController(initialPage: 0);
  final List<Widget> pages = [
    const HomeScreen(),
    const CartScreen(),
    const SettingScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        children: [
          pages[currentIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home), label: "الرئيسيه"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.cart_fill), label: "الـسله"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings_solid), label: "الاعدادات"),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
