import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/home/controllers/products_bloc/products_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ProductsBloc>().add(ProductSelectedEvent(product));
        context.push(RouteManager.productDetailsRoute);
      },
      splashColor: Colors.transparent,
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: product.imgUrl,
            fit: BoxFit.cover,
            width: 70,
            height: 70,
          ),
          Text(product.name),
        ],
      ),
    );
  }
}
