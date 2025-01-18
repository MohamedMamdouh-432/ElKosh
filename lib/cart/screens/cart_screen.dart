import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:elkosh/cart/bloc/cart_bloc.dart';
import 'package:elkosh/cart/components/place_order_bottom_sheet.dart';
import 'package:elkosh/cart/screens/empty_cart_screen.dart';
import 'package:elkosh/cart/widgets/cart_card.dart';
import 'package:elkosh/core/utils/color_manager.dart';
import 'package:elkosh/notifications/notific2/send_notification_service.dart';
import 'package:elkosh/products/controllers/products_bloc/products_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/quickalert.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state.status == LoadStatus.updated)
          context.read<CartBloc>().add(CartFetchingEvent());
      },
      child: BlocConsumer<CartBloc, CartState>(
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
            // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
            inAsyncCall: state.status == CartStatus.loading ||
                state.status == CartStatus.onProgress,
            child: RefreshIndicator(
              displacement: 60,
              color: ColorManager.primary,
              backgroundColor: Colors.white,
              onRefresh: () async =>
                  context.read<CartBloc>().add(CartFetchingEvent()),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Column(
                    children: [
                      AppBar(
                        title: const Text("سلة التسوق"),
                        leading:
                            const Icon(Icons.shopping_bag_outlined, size: 35),
                        actions: [
                          IconButton(
                            padding: const EdgeInsets.only(left: 20),
                            onPressed: state.shopping.isEmpty
                                ? null
                                : () => context
                                    .read<CartBloc>()
                                    .add(CartResetEvent()),
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
                            itemBuilder: (context, index) => CartCard(
                              product: state.shopping.keys.elementAt(index),
                              quantity: state.shopping.values.elementAt(index),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 5,
                    left: 20,
                    right: 20,
                    child: ElevatedButton(
                      onPressed: state.shopping.isEmpty
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
                              Future<List<String?>> getAdminTokens() async {
                                QuerySnapshot querySnapshot =
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .where('userType', isEqualTo: 'admin')
                                        .get();

                                List<String> adminTokens = [];
                                for (var doc in querySnapshot.docs) {
                                  String? token = doc['token'];
                                  if (token != null) {
                                    adminTokens.add(token);
                                  }
                                }

                                return adminTokens;
                              }

                              Future<void> sendNotificationsToAdmins() async {}

                              List<String?> adminTokens =
                                  await getAdminTokens();

                              await SendNotificationService
                                  .sendNotificationUsingApi(
                                      title: 'طلب جديد',
                                      token: adminTokens[0],
                                      body: 'طلب جديد ادخل شوفه ',
                                      data: {'type': 'orders'});
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
