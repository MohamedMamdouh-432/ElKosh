import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:elkosh/cart/bloc/cart_bloc.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/home/controllers/nav_provider/nav_provider.dart';
import 'package:elkosh/home/controllers/product_details_bloc/product_details_bloc.dart';
import 'package:elkosh/home/widgets/image_section.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsBloc(),
      child: SafeArea(
        child: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state.status == CartStatus.failure) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                title: 'خطأ',
                text: state.errorMessage,
                borderRadius: 25,
              );
            }
          },
          builder: (context, state) {
            return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
              builder: (context, productState) {
                bool isInCart =
                    state.shopping.containsKey(productState.product);
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
                      SliverImageSection(imageUrl: productState.product.imgUrl),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productState.product.name,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                productState.product.unitDesc,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                              const Gap(10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: !isInCart
                                            ? null
                                            : () => context.read<CartBloc>().add(
                                                CartDecreasingProductQuantityEvent(
                                                    productState.product)),
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
                                              ? (state.shopping[productState
                                                          .product] ??
                                                      0)
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
                                                    .product.quantity
                                                    .toInt() >=
                                                (state.shopping[productState
                                                            .product] ??
                                                        0) +
                                                    1
                                            ? context.read<CartBloc>().add(
                                                CartIncreasingProductQuantityEvent(
                                                    productState.product))
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
                                  const Gap(10),
                                  ConditionalBuilder(
                                    condition:
                                        productState.product.updatedPrice ==
                                                0 ||
                                            productState.product.updatedPrice ==
                                                productState.product.price,
                                    builder: (_) => Text(
                                      '${productState.product.updatedPrice} جنيه',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    fallback: (_) => Row(
                                      children: [
                                        Text(
                                          productState.product.updatedPrice
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        const Gap(10),
                                        Text(
                                          productState.product.updatedPrice
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Gap(10),
                                        const Text(
                                          'جنيه',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
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
                                productState.product.desc,
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
                      onPressed: () {
                        int steps = GoRouter.of(context).state?.extra as int;
                        context.read<NavProvider>().navToPage(1);
                        while (steps-- > 0) context.pop();
                      },
                      child: const Text(
                        "انتقل الى السلة",
                        textScaler: TextScaler.linear(1.6),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
