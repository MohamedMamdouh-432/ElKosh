import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:elkosh/admin/components/empty_products_view.dart';
import 'package:elkosh/admin/components/products_view.dart';
import 'package:elkosh/admin/controllers/products_bloc/admin_products_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ادارة المنتجات'),
        ),
        body: BlocConsumer<AdminProductsBloc, AdminProductsState>(
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
                      .read<AdminProductsBloc>()
                      .add(AdminProductsLoadingEvent());
                },
              );
            }
          },
          builder: (context, state) => Skeletonizer(
            enabled: state.status == LoadingStatus.inProgress,
            child: ConditionalBuilder(
              condition: state.products.isEmpty,
              builder: (_) => const EmptyProductsView(),
              fallback: (_) => AdminProductsView(products: state.products),
            ),
          ),
        ),
      ),
    );
  }
}
