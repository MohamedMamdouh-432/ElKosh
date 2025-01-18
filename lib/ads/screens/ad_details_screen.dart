import 'package:elkosh/ads/components/place_ad_order_bottom_sheet.dart';
import 'package:elkosh/ads/controllers/ad_details_bloc/ad_details_bloc.dart';
import 'package:elkosh/ads/widgets/offer_item.dart';
import 'package:elkosh/cart/bloc/cart_bloc.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:elkosh/shared/widgets/image_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdDetailsScreen extends StatelessWidget {
  const AdDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, cartState) {
        if (cartState.status == CartStatus.placingfailure)
          QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            title: 'خطأ',
            text: "حدث خطأ أثناء طلب العرض. حاول مره اخرى",
            borderRadius: 20,
            animType: QuickAlertAnimType.scale,
          );
        else if (cartState.status == CartStatus.placingSuccess) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'نجاح',
            text: "تم تسجيل العرض بنجاح",
            borderRadius: 20,
            animType: QuickAlertAnimType.scale,
          );
          // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          context.read<CartBloc>().add(CartResetEvent());
          context.pop();
        } else if (cartState.status == CartStatus.failure)
          QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            title: 'خطأ',
            text: cartState.errorMessage,
            borderRadius: 20,
            animType: QuickAlertAnimType.scale,
          );
      },
      builder: (context, cartState) {
        return BlocBuilder<AdDetailsBloc, AdDetailsState>(
          builder: (context, state) {
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
                    appBar: AppBar(
                      leading: IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          CupertinoIcons.back,
                          size: 35,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    body: Skeletonizer(
                      enabled: state.status == LoadStatus.inProgress,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ImageSection(
                                isReady: state.status != LoadStatus.inProgress,
                                imageUrl: state.ad.imgUrl,
                              ),
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
                            const Gap(10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                itemCount: state.ad.offers.length,
                                itemBuilder: (_, i) =>
                                    OfferItem(state.ad.offers[i]),
                                separatorBuilder: (_, i) => const Gap(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    floatingActionButton: SizedBox(
                      width: context.width * 0.8,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            elevation: 20,
                            useSafeArea: true,
                            showDragHandle: true,
                            builder: (context) =>
                                PlaceAdOrderBottomSheet(state.ad),
                          );
                        },
                        child: const Text(
                          "أطلب العرض",
                          textScaler: TextScaler.linear(1.8),
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
    );
  }
}
