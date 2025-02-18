import 'package:elkosh/products/controllers/products_bloc/products_bloc.dart';
import 'package:elkosh/products/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/quickalert.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_isBottom)
        context.read<ProductsBloc>().add(const ProductsFetchingEvent());
    });
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

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
              context.read<ProductsBloc>().add(const ProductsFetchingEvent());
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
              body: GridView.builder(
                cacheExtent: 20,
                controller: _scrollController,
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
                    : state.hasReachedMax
                        ? state.products.length
                        : state.products.length + 1,
                itemBuilder: (context, index) => index >= state.products.length
                    ? const Center(
                        child: CircularProgressIndicator(strokeWidth: 3))
                    : ProductCard(
                        product: params['isRelated'] as bool
                            ? state.relProducts[index]
                            : state.products[index],
                        steps: params['steps'] as int,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
