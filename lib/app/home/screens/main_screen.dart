import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:elkosh/app/home/controllers/nav_provider/nav_provider.dart';
import 'package:elkosh/app/home/widgets/home_nav_item.dart';
import 'package:elkosh/app/home/widgets/nav_item.dart';
import 'package:elkosh/core/theme/themes.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
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
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: PageView(
              controller: ctx.read<NavProvider>().pageController,
              children: ctx.read<NavProvider>().pages,
            ),
          ),
          bottomNavigationBar: Consumer<NavProvider>(
            builder: (context, navProvider, child) => CurvedNavigationBar(
              height: 45.sp,
              index: navProvider.curIdx,
              color: ColorManager.primary,
              backgroundColor: Colors.transparent,
              onTap: navProvider.animateToPage,
              items: [
                NavItem(
                  idx: 0,
                  curIdx: navProvider.curIdx,
                  label: 'الإعدادات',
                  icon: ImageManager.settingsSvg,
                  onTap: () => navProvider.animateToPage(0),
                ),
                HomeNavItem(
                  idx: 1,
                  curIdx: navProvider.curIdx,
                  onTap: () => navProvider.animateToPage(1),
                ),
                NavItem(
                  idx: 2,
                  curIdx: navProvider.curIdx,
                  label: 'السله',
                  icon: ImageManager.basketSvg,
                  onTap: () => navProvider.animateToPage(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
