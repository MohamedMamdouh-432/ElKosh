import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:elkosh/app/cart/cart_cubit/cart_cubit.dart';
import 'package:elkosh/app/cart/components/cart_appbar.dart';
import 'package:elkosh/app/cart/components/place_order_bottom_sheet.dart';
import 'package:elkosh/app/cart/screens/empty_cart_screen.dart';
import 'package:elkosh/app/cart/widgets/cart_ad_card.dart';
import 'package:elkosh/app/cart/widgets/cart_item_card.dart';
import 'package:elkosh/app/home/products/controllers/products_cubit/products_cubit.dart';
import 'package:elkosh/core/theme/themes.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/quickalert.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state.status == LoadStatus.updated)
          context.read<CartCubit>().fetchCart();
      },
      child: BlocConsumer<CartCubit, CartState>(
        buildWhen: (p, c) => p != c,
        listenWhen: (p, c) => p != c,
        listener: (context, state) {
          if (state.status == CartStatus.placingfailure)
            QuickAlert.show(
              context: context,
              type: QuickAlertType.warning,
              title: 'خطأ',
              text: "حدث خطأ أثناء طلب الوردر. حاول مره اخرى",
              borderRadius: 20,
              animType: QuickAlertAnimType.scale,
            );
          else if (state.status == CartStatus.placingSuccess) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: 'نجاح',
              text: "تم تسجيل الطلب بنجاح",
              borderRadius: 20,
              animType: QuickAlertAnimType.scale,
            );
            context.read<CartCubit>().resetCart();
          } else if (state.status == CartStatus.failure)
            QuickAlert.show(
              context: context,
              type: QuickAlertType.warning,
              title: 'خطأ',
              text: state.errMsg,
              borderRadius: 20,
              animType: QuickAlertAnimType.scale,
            );
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state.status == CartStatus.loading ||
                state.status == CartStatus.onProgress,
            child: RefreshIndicator(
              displacement: 60,
              color: ColorManager.primary,
              backgroundColor: Colors.white,
              onRefresh: () async => context.read<CartCubit>().fetchCart(),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CartAppBar(),
                        ConditionalBuilder(
                          condition: state.items.isEmpty && state.ads.isEmpty,
                          builder: (context) => const EmptyCartView(),
                          fallback: (context) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 20,
                              children: [
                                Visibility(
                                  visible: state.items.isNotEmpty,
                                  child: ExpandablePanel(
                                    header: const Text('المشتريات',
                                        textScaler: TextScaler.linear(1.5)),
                                    collapsed: const SizedBox(),
                                    expanded: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Column(
                                        children: state.items.entries
                                            .map((entry) => CartItemCard(
                                                product: entry.key,
                                                quantity: entry.value))
                                            .toList(),
                                      ),
                                    ),
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToExpand: true,
                                      tapBodyToCollapse: true,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: state.ads.isNotEmpty,
                                  child: ExpandablePanel(
                                    header: const Text('العروض',
                                        textScaler: TextScaler.linear(1.5)),
                                    collapsed: const SizedBox(),
                                    expanded: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Column(
                                        children: state.ads.entries
                                            .map((entry) => CartAdCard(
                                                ad: entry.key,
                                                quantity: entry.value))
                                            .toList(),
                                      ),
                                    ),
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToExpand: true,
                                      tapBodyToCollapse: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 20,
                    right: 20,
                    child: ElevatedButton(
                      onPressed: state.items.isEmpty
                          ? null
                          : () async {
                              showModalBottomSheet(
                                context: context,
                                elevation: 20,
                                useSafeArea: true,
                                isScrollControlled: true,
                                showDragHandle: true,
                                builder: (context) =>
                                    const PlaceOrderBottomSheet(),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                      ),
                      child: const Text(
                        "أطلب الأن",
                        textScaler: TextScaler.linear(1.8),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
