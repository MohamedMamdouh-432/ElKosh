import 'package:elkosh/core/utils/route_manager.dart';
import 'package:elkosh/seller/widgets/seller_category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';

class SellerCategorysView extends StatelessWidget {
  final List<Category> categories;

  const SellerCategorysView({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GridView.builder(
          itemCount: categories.length,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 7 / 13,
          ),
          itemBuilder: (_, i) => SellerCategoryItem(categories[i]),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: ElevatedButton.icon(
            onPressed: () => context.push(RouteManager.addCategoryRoute),
            icon: const Icon(Icons.add),
            label: Text(
              'أضف صنف',
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
