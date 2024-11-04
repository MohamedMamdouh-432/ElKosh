import 'package:elkosh/general/core/utils/utils.dart';
import 'package:elkosh/general/shared/services/context_media.dart';
import 'package:elkosh/user/cart/bloc/cart_bloc.dart';
import 'package:elkosh/user/home/controllers/products_bloc/products_bloc.dart';
import 'package:elkosh/user/home/widgets/image_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, productState) {
              bool isInCart =
                  state.shopping.containsKey(productState.curProduct);
              return Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: const Color(0xffF2F3F2),
                      leading: IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          CupertinoIcons.back,
                          size: 35,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SliverImageSection(
                        imageUrl: productState.curProduct.imgUrl),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productState.curProduct.name,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${productState.curProduct.unitVal} ${productState.curProduct.unit}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                            const Gap(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: !isInCart
                                          ? null
                                          : () => context.read<CartBloc>().add(
                                              CartDecreasingProductQuantityEvent(
                                                  productState.curProduct)),
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
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Text(
                                        isInCart
                                            ? state.shopping[
                                                    productState.curProduct]!
                                                .toString()
                                            : "0",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => productState
                                                  .curProduct.quantity
                                                  .toInt() >=
                                              state.shopping[
                                                  productState.curProduct]! + 1
                                          ? context.read<CartBloc>().add(
                                              CartIncreasingProductQuantityEvent(
                                                  productState.curProduct))
                                          : QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.warning,
                                              title: 'تحذير',
                                              text:
                                                  "الكمية الموجوده من المنتج حاليا لا تكفى",
                                              borderRadius: 20,
                                              animType:
                                                  QuickAlertAnimType.scale,
                                            ),
                                      icon: Icon(
                                        Icons.add,
                                        size: 35,
                                        color: ColorManager.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${productState.curProduct.price} جنيه',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(10),
                            const Divider(),
                            const Gap(10),
                            const Text(
                              "الوصف",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Gap(5),
                            Text(
                              productState.curProduct.desc,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const Gap(10),
                            const Divider(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: SizedBox(
                  width: context.width * 0.8,
                  child: ElevatedButton(
                    onPressed: isInCart
                        ? null
                        : () => context.read<CartBloc>().add(
                            CartAddingProductEvent(productState.curProduct)),
                    child: const Text(
                      "أضف الى السلة",
                      textScaler: TextScaler.linear(1.6),
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
