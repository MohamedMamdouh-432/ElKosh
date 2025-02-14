import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/products/controllers/products_bloc/products_bloc.dart';
import 'package:elkosh/shared/functions.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:super_banners/super_banners.dart';

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
        context.push(RouteManager.productDetailsRoute, extra: {
          'steps': steps,
          'isRelated': (GoRouter.of(context).state.extra
                  as Map<String, dynamic>)['isRelated'] ??
              false,
        });
      },
      splashColor: Colors.transparent,
      child: Card(
        elevation: 60,
        color: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 242, 240, 240),
                borderRadius: BorderRadius.circular(10),
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
                            height: context.height * 0.1,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 80.w,
                        child: Text(
                          product.name,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          textScaler: const TextScaler.linear(0.9),
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                      const Gap(5),
                      SizedBox(
                        width: 80.w,
                        child: Text(
                          '${toArNumber(product.updatedPrice.toStringAsFixed(2))} جنيه',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Visibility(
              visible: product.quantity.floor() == 0 ||
                  product.price != product.updatedPrice,
              child: Positioned(
                top: 0,
                left: 0,
                child: CornerBanner(
                  bannerColor:
                      product.quantity.floor() == 0 ? Colors.red : Colors.green,
                  child: Text(
                    product.quantity.floor() == 0
                        ? 'غير متوفر'
                        : '${toArNumber((((product.price - product.updatedPrice) / product.price) * 100).toStringAsFixed(0))} %',
                    style: product.quantity.floor() == 0
                        ? TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          )
                        : TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
