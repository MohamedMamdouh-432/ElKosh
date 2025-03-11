import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/app/cart/cart_cubit/cart_cubit.dart';
import 'package:elkosh/app/cart/widgets/cart_product_quantity_counter.dart';
import 'package:elkosh/core/services/functions.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/repos/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CartItemCard extends StatelessWidget {
  final Product product;
  final int quantity;

  const CartItemCard({
    super.key,
    required this.product,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95.h,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
            height: context.height * 0.1,
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
                width: 120.sp,
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
                '${toArNumber(product.updatedPrice.toString())} جنيه',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => context
                    .read<CartCubit>()
                    .removeProductFromCart(product, true),
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 23.sp,
                ),
              ),
              CartProductQuantityCounter(quantity: quantity, product: product),
              const Gap(5),
              Text(
                '${toArNumber((quantity * product.updatedPrice).toString())} جنيه',
                style: TextStyle(fontSize: 14.sp, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
