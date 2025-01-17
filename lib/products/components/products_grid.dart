import 'dart:math';

import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/products/controllers/products_bloc/products_bloc.dart';
import 'package:elkosh/products/widgets/product_grid_card.dart';
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
        if (state.status == LoadStatus.failure) {
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
          enabled: state.status == LoadStatus.inProgress,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.black12.withValues(alpha: 0.02),
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
                  maxCrossAxisExtent: 100,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 7 / 7.5,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: [
                    for (int i = 0; i < min(state.products.length, 10); i++)
                      ProductGridCard(product: state.products[i]),
                    Visibility(
                      visible: state.products.isNotEmpty,
                      child: InkWell(
                        onTap: () => context.push(
                          RouteManager.productsRoute,
                          extra: {
                            'isRelated': false,
                            'steps': 2,
                          },
                        ),
                        child: Column(
                          children: [
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
