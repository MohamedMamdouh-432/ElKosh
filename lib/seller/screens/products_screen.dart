import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:elkosh/seller/components/empty_products_view.dart';
import 'package:elkosh/seller/components/products_view.dart';
import 'package:elkosh/seller/controllers/products_bloc/seller_products_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SellerProductsScreen extends StatelessWidget {
  const SellerProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ادارة المنتجات'),
        ),
        body: BlocConsumer<SellerProductsBloc, SellerProductsState>(
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
                  context
                      .read<SellerProductsBloc>()
                      .add(SellerProductsLoadingEvent());
                },
              );
            }
          },
          builder: (context, state) => Skeletonizer(
            enabled: state.status == LoadingStatus.inProgress,
            child: ConditionalBuilder(
              condition: state.products.isEmpty,
              builder: (_) => const EmptyProductsView(),
              fallback: (_) => SellerProductsView(products: state.products),
            ),
          ),
        ),
      ),
    );
  }
}
