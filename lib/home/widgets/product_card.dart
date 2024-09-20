import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
      onTap: () {},
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
