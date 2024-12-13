import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:elkosh/shared/widgets/product_item_card.dart';
import 'package:elkosh/cart/bloc/cart_bloc.dart';
import 'package:elkosh/cart/components/place_order_bottom_sheet.dart';
import 'package:elkosh/cart/screens/empty_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/quickalert.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
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
            text: "تم طلب الاوردر بنجاح",
            borderRadius: 20,
            animType: QuickAlertAnimType.scale,
          );
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          context.read<CartBloc>().add(CartResetEvent());
        } else if (state.status == CartStatus.failure)
          QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            title: 'خطأ',
            text: state.errorMessage,
            borderRadius: 20,
            animType: QuickAlertAnimType.scale,
          );
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state.status == CartStatus.onProgress,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  AppBar(
                    title: const Text("سلة التسوق"),
                    leading: const Icon(Icons.shopping_bag_outlined, size: 35),
                    actions: [
                      IconButton(
                        padding: const EdgeInsets.only(left: 20),
                        onPressed: state.shopping.isEmpty
                            ? null
                            : () =>
                                context.read<CartBloc>().add(CartResetEvent()),
                        icon: const Icon(
                          Icons.cleaning_services_sharp,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ConditionalBuilder(
                      condition: state.shopping.isEmpty,
                      builder: (context) => const EmptyCartView(),
                      fallback: (context) => ListView.builder(
                        padding: const EdgeInsets.only(bottom: 60),
                        itemCount: state.shopping.length,
                        itemBuilder: (context, index) => ProductItemCard(
                          product: state.shopping.keys.elementAt(index),
                          quantity: state.shopping.values.elementAt(index),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: state.shopping.isEmpty
                      ? null
                      : () {
                          showModalBottomSheet(
                            context: context,
                            elevation: 20,
                            useSafeArea: true,
                            showDragHandle: true,
                            builder: (context) => const PlaceOrderBottomSheet(),
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
        );
      },
    );
  }
}
