import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/home/components/animated_search_bar.dart';
import 'package:elkosh/home/controllers/nav_provider/nav_provider.dart';
import 'package:elkosh/home/widgets/home_hi_item.dart';
import 'package:elkosh/settings/bloc/profile_bloc.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomeAppBar extends StatelessWidget {
  final Animation appBarAnimation;
  const HomeAppBar({super.key, required this.appBarAnimation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: appBarAnimation,
        builder: (context, child) {
          return BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (p, c) => p != c,
            builder: (ctx, state) {
              return Container(
                width: ctx.width,
                height: appBarAnimation.value,
                decoration: BoxDecoration(
                  color: ColorManager.primary.withValues(alpha: 0.75),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(28),
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
                                  HomeHiItem(name: state.user.name),
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
                                      child: Stack(
                                        children: [
                                          Align(
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
                                        ],
                                      ),
                                    ),
                                  )
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
