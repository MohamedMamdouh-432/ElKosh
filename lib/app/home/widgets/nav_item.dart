import 'package:elkosh/core/theme/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NavItem extends StatelessWidget {
  final int idx, curIdx;
  final String label, icon;
  final Function() onTap;

  const NavItem({
    super.key,
    required this.idx,
    required this.curIdx,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext ctx) {
    return CircleAvatar(
      radius: 14.r,
      backgroundColor: ColorManager.primary,
      child: InkWell(
        onTap: onTap,
        child: SvgPicture.asset(
          icon,
          width: 28,
          height: 28,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
