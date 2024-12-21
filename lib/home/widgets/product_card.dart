import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/home/controllers/products_bloc/products_bloc.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int steps;

  const ProductCard({
    super.key,
    required this.product,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ProductsBloc>().add(ProductSelectedEvent(product));
        context.push(RouteManager.productDetailsRoute, extra: steps);
      },
      splashColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 242, 240, 240),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 3,
              blurRadius: 2,
              blurStyle: BlurStyle.inner,
            ),
          ],
        ),
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(
                  width: 80.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: product.imgUrl,
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                      height: context.height * 0.11,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  product.name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  textScaler: const TextScaler.linear(1.2),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
