import 'package:elkosh/home/controllers/products_bloc/products_bloc.dart';
import 'package:elkosh/home/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

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
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(title: const Text("تصفح المنتجات")),
            body: GridView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                crossAxisSpacing: 5,
                maxCrossAxisExtent: 110,
                childAspectRatio: 2 / 2.3,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) =>
                  ProductCard(product: state.products[index]),
            ),
          ),
        );
      },
    );
  }
}
