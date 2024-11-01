import 'package:elkosh/user/cart/screens/cart_screen.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/user/home/screens/home_screen.dart';
import 'package:elkosh/settings/screens/setting_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: (value) => setState(() => currentIndex = value),
          children: pages,
        ),
        bottomNavigationBar: GNav(
          selectedIndex: currentIndex,
          activeColor: ColorManager.primary,
          color: Colors.blueGrey,
          backgroundColor: ColorManager.primary.withOpacity(0.07),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          onTabChange: (index) {
            pageController.animateToPage(
              index,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 500),
            );
            setState(() => currentIndex = index);
          },
          tabs: const [
            GButton(
              text: "الرئيسية",
              icon: CupertinoIcons.home,
            ),
            GButton(
              icon: CupertinoIcons.cart_fill,
              text: "السلة",
            ),
            GButton(
              icon: CupertinoIcons.settings_solid,
              text: "الاعدادات",
            ),
          ],
        ),
      ),
    );
  }
}
