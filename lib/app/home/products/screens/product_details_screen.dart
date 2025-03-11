import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:elkosh/app/cart/cart_cubit/cart_cubit.dart';
import 'package:elkosh/app/home/controllers/nav_provider/nav_provider.dart';
import 'package:elkosh/app/home/products/controllers/product_details_provider/product_details_provider.dart';
import 'package:elkosh/app/home/widgets/image_section.dart';
import 'package:elkosh/core/services/functions.dart';
import 'package:elkosh/core/theme/themes.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/repos/enums/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:super_banners/super_banners.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductDetailsProvider(),
      child: SafeArea(
        child: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Consumer<ProductDetailsProvider>(
              builder: (context, productState, _) {
                bool isInCart = state.items.containsKey(productState.product);
                return Container(
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
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Skeletonizer(
                      enabled: productState.status == LoadStatus.inProgress,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Stack(
                                children: [
                                  ImageSection(
                                    isReady:
                                        productState.product.imgUrl.isNotEmpty,
                                    imageUrl: productState.product.imgUrl,
                                  ),
                                  Visibility(
                                    visible: productState.product.quantity
                                                .floor() >
                                            0 &&
                                        productState.product.price !=
                                            productState.product.updatedPrice,
                                    child: Positioned(
                                      top: 0,
                                      left: 0,
                                      child: CornerBanner(
                                        bannerColor: Colors.green,
                                        child: Text(
                                          productState.product.quantity
                                                      .floor() ==
                                                  0
                                              ? 'غير متوفر'
                                              : '${toArNumber((((productState.product.price - productState.product.updatedPrice) / productState.product.price) * 100).toStringAsFixed(0))} %',
                                          style: TextStyle(
                                            fontSize: 25.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 2,
                                    child: IconButton(
                                      onPressed: () => context.pop(),
                                      icon: const Icon(
                                        CupertinoIcons.back,
                                        size: 35,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 200.sp,
                                      child: Text(
                                        productState.product.name,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: productState.product.quantity
                                              .floor() ==
                                          0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          "غير متوفر",
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  productState.product.unitDesc,
                                  style: TextStyle(
                                    fontSize: 16.sp,
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
                                              : () => context
                                                  .read<CartCubit>()
                                                  .removeProductFromCart(
                                                      productState.product,
                                                      false),
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
                                                ? (state.items[productState
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
                                                  (state.items[productState
                                                              .product] ??
                                                          0) +
                                                      1
                                              ? context
                                                  .read<CartCubit>()
                                                  .addProductToCart(
                                                      productState.product)
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
                                      condition: productState
                                                  .product.updatedPrice ==
                                              0 ||
                                          productState.product.updatedPrice ==
                                              productState.product.price,
                                      builder: (_) => Text(
                                        '${toArNumber(productState.product.updatedPrice.toStringAsFixed(2))} جنيه',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      fallback: (_) => Row(
                                        children: [
                                          Text(
                                            productState.product.price
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                          const Gap(10),
                                          Text(
                                            productState.product.updatedPrice
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Gap(10),
                                          Text(
                                            'جنيه',
                                            style: TextStyle(
                                              fontSize: 15.sp,
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
                          ],
                        ),
                      ),
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat,
                    floatingActionButton: SizedBox(
                      width: context.width * 0.8,
                      child: ElevatedButton(
                        onPressed: () {
                          int steps = (GoRouter.of(context).state.extra
                              as Map<String, dynamic>)['steps'] as int;
                          context.read<NavProvider>().navToPage(2);
                          while (steps-- > 0) context.pop();
                        },
                        child: const Text(
                          "انتقل الى السلة",
                          textScaler: TextScaler.linear(1.6),
                        ),
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
