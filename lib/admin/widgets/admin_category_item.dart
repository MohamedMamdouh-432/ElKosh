import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/admin/controllers/category_bloc/admin_category_bloc.dart';
import 'package:elkosh/admin/controllers/products_bloc/admin_products_bloc.dart';
import 'package:elkosh/general/core/utils/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AdminCategoryItem extends StatelessWidget {
  final dynamic category;

  const AdminCategoryItem(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: category is Category
                ? () {
                    context
                        .read<AdminCategoryBloc>()
                        .add(AdminCategorySelectedEvent(category));
                    context.push(RouteManager.adminProductsRoute);
                    context
                        .read<AdminProductsBloc>()
                        .add(AdminProductsLoadingEvent());
                  }
                : () => QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title:
                          'هل تريد اضافة صنف ${category is Category ? category.name : category.key} ؟',
                      borderRadius: 25,
                      barrierDismissible: false,
                      showConfirmBtn: true,
                      showCancelBtn: true,
                      confirmBtnText: 'اضافة',
                      onConfirmBtnTap: () {
                        context.pop();
                        context
                            .read<AdminCategoryBloc>()
                            .add(AdminCategoryAddingEvent(category));
                      },
                      cancelBtnText: 'رجوع',
                      onCancelBtnTap: () => context.pop(),
                    ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffFAEFD9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Gap(5),
                  Text(
                    category is Category ? category.name : category.key,
                    textAlign: TextAlign.center,
                    textScaler: const TextScaler.linear(1.2),
                  ),
                  const Spacer(),
                  CachedNetworkImage(
                    imageUrl:
                        category is Category ? category.imgUrl : category.value,
                    fit: BoxFit.fitWidth,
                    filterQuality: FilterQuality.high,
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: category is Category,
          child: Container(
            height: 30,
            margin: const EdgeInsets.only(top: 5),
            child: ElevatedButton.icon(
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  title: 'هل تريد حذف صنف ${category.name} ؟',
                  borderRadius: 25,
                  barrierDismissible: false,
                  showConfirmBtn: true,
                  showCancelBtn: true,
                  confirmBtnText: 'حذف',
                  onConfirmBtnTap: () {
                    context.pop();
                    context
                        .read<AdminCategoryBloc>()
                        .add(AdminCategoryDeletingEvent(category.id));
                  },
                  confirmBtnColor: Colors.red,
                  cancelBtnText: 'رجوع',
                  onCancelBtnTap: () => context.pop(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffFAEFD9),
              ),
              label: const Text('حذف'),
              icon: const Icon(Icons.delete),
            ),
          ),
        ),
      ],
    );
  }
}
