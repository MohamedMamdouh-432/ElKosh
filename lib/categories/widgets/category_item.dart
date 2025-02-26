import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/categories/controllers/categorys_bloc/categorys_bloc.dart';
import 'package:elkosh/core/utils/route_manager.dart';
import 'package:elkosh/products/controllers/products_cubit/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        context.push(
          RouteManager.productsRoute,
          extra: {
            'isRelated': true,
            'steps': 3,
          },
        );
        context.read<ProductsCubit>().fetchRelatedProducts();
      },
      child: Card(
        elevation: 40,
        color: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 242, 240, 240),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                category.name,
                textAlign: TextAlign.center,
                textScaler: const TextScaler.linear(1.2),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              CachedNetworkImage(
                useOldImageOnUrlChange: true,
                width: double.infinity,
                height: 80.h,
                imageUrl: category.imgUrl,
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
