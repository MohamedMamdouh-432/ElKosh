import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/core/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

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
    return SizedBox(
      width: ctx.width * .18,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            const Gap(6),
            AnimatedCrossFade(
              firstChild: SvgPicture.asset(
                ImageManager.navArrowSvg,
                height: 8,
              ),
              secondChild: const SizedBox(),
              crossFadeState: idx == curIdx
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            )
          ],
        ),
      ),
    );
  }
}
