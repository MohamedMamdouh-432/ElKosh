import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/cart/bloc/cart_bloc.dart';
import 'package:elkosh/cart/widgets/cart_product_quantity_counter.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:models_repository/models_repository.dart';

class CartCard extends StatelessWidget {
  final Product product;
  final int quantity;

  const CartCard({
    super.key,
    required this.product,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.8),
            spreadRadius: 5,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        spacing: context.width * 0.0015,
        children: [
          SizedBox(
            width: context.width * 0.19,
            height: context.height * 0.09,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: product.imgUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(
                child: Text(
                  product.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              Text(
                '${product.updatedPrice} جنيه',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => context
                    .read<CartBloc>()
                    .add(CartRemovingProductEvent(product)),
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 27.sp,
                ),
              ),
              CartProductQuantityCounter(quantity: quantity, product: product),
              Text(
                'الإجمالى: ${quantity * product.updatedPrice} جنيه',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
