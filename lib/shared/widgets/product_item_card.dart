import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/cart/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ProductItemCard extends StatelessWidget {
  final Product product;
  final int quantity;

  const ProductItemCard({
    super.key,
    required this.product,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: product.imgUrl,
              width: 80,
              height: 80,
              fit: BoxFit.fill,
            ),
          ),
          MaxGap(15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                product.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                '${product.price} جنيه',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              IconButton(
                onPressed: () => context
                    .read<CartBloc>()
                    .add(CartRemovingProductEvent(product)),
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 30.sp,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: quantity <= 1
                          ? null
                          : () => context
                              .read<CartBloc>()
                              .add(CartDecreasingProductQuantityEvent(product)),
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.black,
                        size: 28,
                      ),
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () => product.quantity.toInt() >= quantity + 1
                          ? context
                              .read<CartBloc>()
                              .add(CartIncreasingProductQuantityEvent(product))
                          : QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              title: 'تحذير',
                              text: "الكمية الموجوده من المنتج حاليا لا تكفى",
                              borderRadius: 20,
                              animType: QuickAlertAnimType.scale,
                            ),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
