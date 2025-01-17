import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/products/controllers/products_bloc/products_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:super_banners/super_banners.dart';

class ProductGridCard extends StatelessWidget {
  final Product product;
  const ProductGridCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ProductsBloc>().add(ProductSelectedEvent(product));
        context.push(
          RouteManager.productDetailsRoute, 
          extra: {
            'steps': 1,
            'isRelated': false,
          });
      },
      splashColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 242, 240, 240),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  spreadRadius: 3,
                  blurRadius: 2,
                  blurStyle: BlurStyle.inner,
                ),
              ],
              image: DecorationImage(
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
                image: CachedNetworkImageProvider(product.imgUrl),
              ),
            ),
          ),
          Visibility(
            visible: product.quantity.floor() == 0 ||
                product.price != product.updatedPrice,
            child: Positioned(
              top: 0,
              left: 0,
              child: CornerBanner(
                bannerColor: Colors.red,
                child: Text(
                  product.quantity.floor() == 0
                      ? 'غير متوفر'
                      : '${(((product.price - product.updatedPrice) / product.price) * 100).toStringAsFixed(0)} %',
                  style: TextStyle(fontSize: 10.sp, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
