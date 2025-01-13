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
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 247, 234, 250),
              Color.fromARGB(255, 250, 240, 236),
              Color.fromARGB(255, 235, 244, 251),
              Color.fromARGB(255, 246, 237, 233),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
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
                backgroundColor: const Color.fromARGB(255, 246, 237, 233),
                iconSize: 26,
                padding: const EdgeInsets.symmetric(vertical: 16),
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      ),
    );
  }
}
