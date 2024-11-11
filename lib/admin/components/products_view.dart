import 'package:elkosh/admin/widgets/admin_product_item.dart';
import 'package:elkosh/general/core/utils/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';

class AdminProductsView extends StatelessWidget {
  final List<Product> products;

  const AdminProductsView({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GridView.builder(
          itemCount: products.length,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 130,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 6 / 9,
          ),
          itemBuilder: (_, i) => AdminProductItem(products[i]),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: ElevatedButton.icon(
            onPressed: () => context.push(RouteManager.addProductRoute),
            icon: const Icon(Icons.add),
            label: Text(
              'أضف منتج',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
