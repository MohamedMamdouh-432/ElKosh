import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/core/utils/route_manager.dart';
import 'package:elkosh/home/controllers/categorys_bloc/categorys_bloc.dart';
import 'package:elkosh/home/controllers/products_bloc/products_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<CategorysBloc>().add(CategorySelectedEvent(category));
        context.push(RouteManager.productsRoute, extra: 3);
        context.read<ProductsBloc>().add(ProductsRelatedLoadingEvent());
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
                category.name,
                textAlign: TextAlign.center,
                textScaler: const TextScaler.linear(1.2),
              ),
            ),
            const Spacer(),
            CachedNetworkImage(
              imageUrl: category.imgUrl,
              fit: BoxFit.fitWidth,
              filterQuality: FilterQuality.high,
            ),
          ],
        ),
      ),
    );
  }
}
