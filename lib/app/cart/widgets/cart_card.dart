import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/app/cart/cart_cubit/cart_cubit.dart';
import 'package:elkosh/app/cart/widgets/cart_product_quantity_counter.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
            color: Colors.grey.withValues(alpha: 0.4),
            spreadRadius: 5,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.width * 0.17,
            height: context.height * 0.11,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                useOldImageOnUrlChange: true,
                imageUrl: product.imgUrl,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(width: 10.sp),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100.sp,
                child: Text(
                  product.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () =>
                    context.read<CartCubit>().removeProductFromCart(product),
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 23.sp,
                ),
              ),
              CartProductQuantityCounter(quantity: quantity, product: product),
              const Gap(10),
              Text(
                '${quantity * product.updatedPrice} جنيه',
                style: TextStyle(fontSize: 12.sp, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
