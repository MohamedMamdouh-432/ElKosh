import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:elkosh/general/core/utils/utils.dart';
import 'package:elkosh/user/cart/bloc/cart_bloc.dart';
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
  final bool canEdit;

  const ProductItemCard({
    super.key,
    required this.product,
    required this.quantity,
    this.canEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120.h,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 2,
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
                  fit: BoxFit.cover,
                ),
              ),
              MaxGap(40.w),
              Expanded(
                child: Column(
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
                    const Gap(8),
                    Text(
                      '${product.price} جنيه',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ConditionalBuilder(
                condition: canEdit,
                builder: (_) => Column(
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
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Flexible(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: quantity <= 1
                                    ? null
                                    : () => context.read<CartBloc>().add(
                                        CartDecreasingProductQuantityEvent(
                                            product)),
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
                              Text(
                                '$quantity',
                                style: const TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                onPressed: () =>
                                    product.quantity.toInt() >= quantity + 1
                                        ? context.read<CartBloc>().add(
                                            CartIncreasingProductQuantityEvent(
                                                product))
                                        : QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.warning,
                                            title: 'تحذير',
                                            text:
                                                "الكمية الموجوده من المنتج حاليا لا تكفى",
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
                      ),
                    ),
                  ],
                ),
                fallback: (_) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    quantity.toString(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: ColorManager.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
