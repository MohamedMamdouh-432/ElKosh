import 'dart:math';

import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/home/controllers/products_bloc/products_bloc.dart';
import 'package:elkosh/home/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/quickalert.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state.status == LoadingStatus.failure) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'حدث خطأ ما',
            text: 'حدث خطأ أثناء تحميل المنتجات',
            borderRadius: 25,
            barrierDismissible: false,
            confirmBtnText: "أعد المحاولة",
            onConfirmBtnTap: () {
              context.pop();
              context.read<ProductsBloc>().add(const ProductsLoadingEvent());
            },
          );
        }
      },
      builder: (context, state) {
        return Skeletonizer(
          enabled: state.status == LoadingStatus.inProgress,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.black12.withValues(alpha: 0.05),
              // borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  "تصفح اكثر المنتجات طلبا",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(10),
                GridView.extent(
                  shrinkWrap: true,
                  maxCrossAxisExtent: 110,
                  crossAxisSpacing: 5,
                  childAspectRatio: 2 / 2.3,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  children: [
                    for (int i = 0; i < min(state.products.length, 10); i++)
                      ProductCard(product: state.products[i], steps: 1),
                    InkWell(
                      onTap: () {
                        context
                            .read<ProductsBloc>()
                            .add(const ProductsLoadingEvent());
                        context.push(RouteManager.productsRoute, extra: 2);
                      },
                      child: Column(
                        children: [
                          const Gap(10),
                          Container(
                            width: 60,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 2,
                                color: Colors.blueGrey,
                              ),
                            ),
                            child: const Icon(
                              CupertinoIcons.square_grid_2x2,
                              size: 40,
                            ),
                          ),
                          const Text("عرض الكل"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
