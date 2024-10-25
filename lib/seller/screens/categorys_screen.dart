import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:elkosh/seller/components/categories_view.dart';
import 'package:elkosh/seller/components/empty_categorys_view.dart';
import 'package:elkosh/seller/controllers/category_bloc/seller_category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategorysScreen extends StatelessWidget {
  const CategorysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ادارة اصناف المتجر'),
        ),
        body: BlocConsumer<SellerCategoryBloc, SellerCategoryState>(
          listener: (context, state) {
            if (state.loadingStatus == LoadingStatus.failure) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: 'حدث خطأ ما',
                text: 'حدث خطأ أثناء تحميل الاصناف',
                borderRadius: 25,
                barrierDismissible: false,
                confirmBtnText: "أعد المحاولة",
                onConfirmBtnTap: () {
                  context.pop();
                  context
                      .read<SellerCategoryBloc>()
                      .add(SellerCategorysLoadingEvent());
                },
              );
            }
          },
          builder: (context, state) => Skeletonizer(
            enabled: state.loadingStatus == LoadingStatus.inProgress,
            child: ConditionalBuilder(
              condition: state.categorys.isEmpty,
              builder: (_) => const EmptyCategorysView(),
              fallback: (_) =>
                  SellerCategorysView(categories: state.categorys),
            ),
          ),
        ),
      ),
    );
  }
}
