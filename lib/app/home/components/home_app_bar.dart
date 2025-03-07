import 'package:badges/badges.dart' as badges;
import 'package:elkosh/app/cart/cart_cubit/cart_cubit.dart';
import 'package:elkosh/app/home/components/animated_search_bar.dart';
import 'package:elkosh/app/home/controllers/nav_provider/nav_provider.dart';
import 'package:elkosh/app/home/widgets/home_hi_item.dart';
import 'package:elkosh/app/settings/controllers/profile_provider.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget {
  final Animation appBarAnimation;
  const HomeAppBar({super.key, required this.appBarAnimation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: appBarAnimation,
        builder: (context, child) {
          return Consumer<ProfileProvider>(
            builder: (ctx, pp, child) {
              return Container(
                width: ctx.width,
                height: appBarAnimation.value,
                decoration: BoxDecoration(
                  color: ColorManager.primary.withValues(alpha: 0.9),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              width: ctx.width,
                              margin:
                                  EdgeInsets.only(top: ctx.viewPaddingTop + 15),
                              child: Row(
                                children: [
                                  HomeHiItem(name: pp.user.name),
                                  GestureDetector(
                                    onTap: () => context
                                        .read<NavProvider>()
                                        .animateToPage(2),
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: BlocBuilder<CartCubit, CartState>(
                                        builder: (context, state) =>
                                            badges.Badge(
                                          position:
                                              badges.BadgePosition.topStart(
                                            top: -20,
                                            start: -12,
                                          ),
                                          badgeStyle: const badges.BadgeStyle(
                                            badgeColor: Colors.green,
                                            padding: EdgeInsets.all(8),
                                          ),
                                          badgeContent: Text(
                                            state.shopping.length.toString(),
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: SvgPicture.asset(
                                              ImageManager.basketSvg,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Colors.white,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            AnimatedSearchBar(appBarAnimation: appBarAnimation),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
