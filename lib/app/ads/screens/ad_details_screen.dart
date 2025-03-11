import 'package:elkosh/app/ads/controllers/ad_details_provider/ad_details_provider.dart';
import 'package:elkosh/app/ads/widgets/offer_item.dart';
import 'package:elkosh/app/cart/cart_cubit/cart_cubit.dart';
import 'package:elkosh/app/home/controllers/nav_provider/nav_provider.dart';
import 'package:elkosh/app/home/widgets/image_section.dart';
import 'package:elkosh/core/services/functions.dart';
import 'package:elkosh/core/theme/color_manager.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/repos/enums/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdDetailsScreen extends StatelessWidget {
  const AdDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdDetailsProvider(),
      child: BlocConsumer<CartCubit, CartState>(
        buildWhen: (p, c) => p != c,
        listenWhen: (p, c) => p != c,
        listener: (context, cartState) {
          if (cartState.status == CartStatus.failure)
            QuickAlert.show(
              context: context,
              type: QuickAlertType.warning,
              title: 'خطأ',
              text: cartState.errMsg,
              borderRadius: 20,
              animType: QuickAlertAnimType.scale,
            );
        },
        builder: (context, cartState) {
          return Consumer<AdDetailsProvider>(
            builder: (context, state, _) {
              bool isInCart = cartState.ads.containsKey(state.ad);
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
                  child: ModalProgressHUD(
                    inAsyncCall: cartState.status == CartStatus.loading ||
                        cartState.status == CartStatus.onProgress,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Skeletonizer(
                        enabled: state.status == LoadStatus.inProgress,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 60, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Stack(children: [
                                  ImageSection(
                                    isReady:
                                        state.status != LoadStatus.inProgress,
                                    imageUrl: state.ad.imgUrl,
                                  ),
                                  Positioned(
                                    right: 2,
                                    top: 5,
                                    child: IconButton(
                                      onPressed: () => context.pop(),
                                      icon: const Icon(
                                        CupertinoIcons.back,
                                        size: 35,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  state.ad.title,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    '${toArNumber(state.ad.total.toStringAsFixed(2))} جنيه',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Gap(10),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: !isInCart
                                            ? null
                                            : () => context
                                                .read<CartCubit>()
                                                .removeAdFromCart(
                                                    state.ad, false),
                                        icon: Icon(
                                          Icons.remove,
                                          size: 35,
                                          color: isInCart
                                              ? ColorManager.primary
                                              : Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Text(
                                          isInCart
                                              ? (cartState.ads[state.ad] ?? 0)
                                                  .toString()
                                              : "0",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => context
                                            .read<CartCubit>()
                                            .addAdToCart(state.ad),
                                        icon: Icon(
                                          Icons.add,
                                          size: 35,
                                          color: ColorManager.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Gap(10),
                              ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                itemCount: state.ad.offers.length,
                                itemBuilder: (_, i) =>
                                    OfferItem(state.ad.offers[i]),
                                separatorBuilder: (_, i) => const Gap(10),
                              ),
                            ],
                          ),
                        ),
                      ),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.centerFloat,
                      floatingActionButton: Visibility(
                        visible: state.ad.offers.isNotEmpty,
                        child: SizedBox(
                          width: context.width * 0.8,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<NavProvider>().navToPage(2);
                              context.pop();
                            },
                            child: const Text(
                              "إذهب للسلة",
                              textScaler: TextScaler.linear(1.8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
