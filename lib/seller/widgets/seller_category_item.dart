import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/seller/controllers/category_bloc/seller_category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class SellerCategoryItem extends StatelessWidget {
  final dynamic category;

  const SellerCategoryItem(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: category is Category
                ? null
                : () {
                    QuickAlert.show(
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
                            .read<SellerCategoryBloc>()
                            .add(SellerCategoryAddingEvent(category));
                      },
                      cancelBtnText: 'رجوع',
                      onCancelBtnTap: () => context.pop(),
                    );
                  },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffFAEFD9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: Text(
                      category is Category ? category.name : category.key,
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1.2),
                    ),
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
                        .read<SellerCategoryBloc>()
                        .add(SellerCategoryDeletingEvent(category.id));
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
