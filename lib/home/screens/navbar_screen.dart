import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/home/controllers/nav_provider/nav_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class NavBarScreen extends StatelessWidget {
  const NavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: context.read<NavProvider>().pageController,
          onPageChanged: context.read<NavProvider>().animateToPage,
          children: context.read<NavProvider>().pages,
        ),
        bottomNavigationBar: Consumer<NavProvider>(
          builder: (context, navProvider, child) {
            return GNav(
              selectedIndex: navProvider.curIdx,
              activeColor: ColorManager.primary,
              color: Colors.blueGrey,
              backgroundColor: ColorManager.primary.withOpacity(0.07),
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 15,
              ),
              onTabChange: navProvider.navToPage,
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
            );
          },
        ),
      ),
    );
  }
}
