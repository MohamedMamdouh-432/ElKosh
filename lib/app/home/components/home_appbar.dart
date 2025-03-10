import 'package:badges/badges.dart' as badges;
import 'package:elkosh/app/cart/cart_cubit/cart_cubit.dart';
import 'package:elkosh/app/home/controllers/nav_provider/nav_provider.dart';
import 'package:elkosh/app/home/widgets/home_hi_item.dart';
import 'package:elkosh/app/settings/controllers/profile_provider.dart';
import 'package:elkosh/core/services/context_media.dart';
import 'package:elkosh/core/theme/themes.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (ctx, pp, child) {
        return Container(
          width: ctx.width,
          height: 150,
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
                        margin: EdgeInsets.only(top: ctx.viewPaddingTop + 15),
                        child: Row(
                          children: [
                            HomeHiItem(name: pp.user.name),
                            GestureDetector(
                              onTap: () =>
                                  context.read<NavProvider>().animateToPage(2),
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: BlocBuilder<CartCubit, CartState>(
                                  builder: (context, state) => badges.Badge(
                                    position: badges.BadgePosition.topStart(
                                      top: -20,
                                      start: -12,
                                    ),
                                    badgeStyle: const badges.BadgeStyle(
                                      badgeColor: Colors.green,
                                      padding: EdgeInsets.all(8),
                                    ),
                                    badgeContent: Text(
                                      (state.items.length + state.ads.length)
                                          .toString(),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                        ImageManager.basketSvg,
                                        colorFilter: const ColorFilter.mode(
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
                      SearchBar(
                        hintText: 'ابحث من هنا',
                        leading: const Icon(Icons.search, size: 26),
                        elevation: const WidgetStatePropertyAll(0),
                        hintStyle: WidgetStatePropertyAll(
                          TextStyle(
                            color: Colors.black54,
                            fontSize: 10.sp,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 10)),
                        onTap: () => ctx.push(RouteManager.searchRoute),
                      ),
                      const Gap(15),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
