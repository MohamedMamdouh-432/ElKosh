import 'package:elkosh/core/theme/themes.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomeNavItem extends StatelessWidget {
  final int idx, curIdx;
  final Function() onTap;

  const HomeNavItem({
    super.key,
    required this.idx,
    required this.curIdx,
    required this.onTap,
  });

  @override
  Widget build(BuildContext ctx) {
    return CircleAvatar(
      radius: 18.r,
      backgroundColor: ColorManager.primary,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Center(
              child: SvgPicture.asset(
                ImageManager.homeNavSvg,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              top: 0,
              right: 0,
              left: 0,
              child: Center(
                child: SvgPicture.asset(
                  ImageManager.homeSvg,
                  colorFilter: const ColorFilter.mode(
                    Colors.black87,
                    BlendMode.srcIn,
                  ),
                  width: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
