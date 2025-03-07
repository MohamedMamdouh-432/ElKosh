import 'package:elkosh/app/cart/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CartProductQuantityCounter extends StatelessWidget {
  final int quantity;
  final Product product;

  const CartProductQuantityCounter({
    super.key,
    required this.quantity,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    .read<CartCubit>()
                    .decreaseProductCartQuantity(product),
            icon: const Icon(
              Icons.remove,
              color: Colors.black,
              size: 25,
            ),
          ),
          Text(
            '$quantity',
            style: const TextStyle(fontSize: 18),
          ),
          IconButton(
            onPressed: () => product.quantity.toInt() >= quantity + 1
                ? context
                    .read<CartCubit>()
                    .increaseProductCartQuantity(product)
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
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
