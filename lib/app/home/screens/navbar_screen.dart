import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/app/home/controllers/nav_provider/nav_provider.dart';
import 'package:elkosh/app/home/widgets/home_nav_item.dart';
import 'package:elkosh/app/home/widgets/nav_item.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBarScreen extends StatelessWidget {
  const NavBarScreen({super.key});

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
            builder: (context, navProvider, child) => Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 110,
                  child: ClipRRect(
                    child: ClipPath(
                      clipper: BottomNavClipper(),
                      child: Container(
                        width: ctx.width,
                        height: 110,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorManager.primary.withValues(alpha: 0.9),
                              ColorManager.primary.withValues(alpha: 0.9),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, height);
    path.lineTo(width, height);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(width, 40, width - 40, 40);
    path.lineTo(40, 40);
    path.quadraticBezierTo(0, 40, 0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
