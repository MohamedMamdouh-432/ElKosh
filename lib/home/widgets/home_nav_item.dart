import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

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
    return SizedBox(
      width: ctx.width * .18,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
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
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                      width: 20,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(8),
            AnimatedCrossFade(
              firstChild: SvgPicture.asset(
                ImageManager.navArrowSvg,
                height: 8,
              ),
              secondChild: const SizedBox(height: 5),
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
