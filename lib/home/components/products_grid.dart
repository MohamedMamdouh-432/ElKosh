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
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    super.key,
  });

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "المنتجات",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GridView.extent(
                shrinkWrap: true,
                maxCrossAxisExtent: 110,
                crossAxisSpacing: 5,
                childAspectRatio: 2 / 2.3,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                children: [
                  for (int i = 0; i < min(state.products.length, 7); i++)
                    ProductCard(product: state.products[i]),
                  InkWell(
                    onTap: () {
                      context
                          .read<ProductsBloc>()
                          .add(const ProductsLoadingEvent());
                      context.push(RouteManager.productsRoute);
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
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            CupertinoIcons.square_grid_2x2,
                            size: 32,
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
        );
      },
    );
  }
}
