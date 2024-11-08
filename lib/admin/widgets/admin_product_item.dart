import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/admin/controllers/product_form_bloc/product_form_bloc.dart';
import 'package:elkosh/admin/controllers/products_bloc/admin_products_bloc.dart';
import 'package:elkosh/general/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AdminProductItem extends StatelessWidget {
  final Product product;
  const AdminProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context
            .read<AdminProductsBloc>()
            .add(AdminProductSelectedEvent(product));
        context.push(RouteManager.adminProductDetailsRoute);
      },
      splashColor: Colors.transparent,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: product.imgUrl,
                  fit: BoxFit.fill,
                  width: 80,
                  height: 80,
                ),
                Text(product.name),
              ],
            ),
          ),
          const Gap(5),
          Row(
            children: [
              Expanded(
                child: FloatingActionButton.small(
                  heroTag: 'editTag',
                  onPressed: () {
                    context.push(RouteManager.editProductRoute);
                    context
                        .read<AdminProductsBloc>()
                        .add(AdminProductSelectedEvent(product));
                    context
                        .read<ProductFormBloc>()
                        .add(ProductFormPrepared(product));
                  },
                  backgroundColor: Colors.white70,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.green,
                  ),
                ),
              ),
              Expanded(
                child: FloatingActionButton.small(
                  heroTag: 'deleteTag',
                  onPressed: () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title: 'هل تريد حذف ${product.name} ؟',
                      borderRadius: 25,
                      barrierDismissible: false,
                      showConfirmBtn: true,
                      showCancelBtn: true,
                      confirmBtnText: 'حذف',
                      onConfirmBtnTap: () {
                        context.pop();
                        context
                            .read<AdminProductsBloc>()
                            .add(AdminProductDeletingEvent(product.id));
                      },
                      confirmBtnColor: Colors.red,
                      cancelBtnText: 'رجوع',
                      onCancelBtnTap: () => context.pop(),
                    );
                  },
                  backgroundColor: Colors.white70,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
