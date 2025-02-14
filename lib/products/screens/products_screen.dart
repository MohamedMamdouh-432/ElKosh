import 'package:elkosh/products/controllers/products_bloc/products_bloc.dart';
import 'package:elkosh/products/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/quickalert.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
      buildWhen: (p, c) => p != c,
      listenWhen: (p, c) => p != c,
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
        final params = GoRouter.of(context).state.extra as Map<String, dynamic>;
        return SafeArea(
          child: Container(
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
              appBar: AppBar(title: const Text("تصفح المنتجات")),
              body: Skeletonizer(
                enabled: state.status == LoadStatus.inProgress,
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 10.w,
                  ),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 120,
                    crossAxisSpacing: 10.sp,
                    mainAxisSpacing: 10.sp,
                    childAspectRatio: 2.sp / 3.5.sp,
                  ),
                  itemCount: params['isRelated'] as bool
                      ? state.relProducts.length
                      : state.products.length,
                  itemBuilder: (context, index) => ProductCard(
                    product: params['isRelated'] as bool
                        ? state.relProducts[index]
                        : state.products[index],
                    steps: params['steps'] as int,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
