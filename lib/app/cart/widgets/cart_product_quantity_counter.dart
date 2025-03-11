import 'package:elkosh/app/cart/cart_cubit/cart_cubit.dart';
import 'package:elkosh/core/services/functions.dart';
import 'package:elkosh/repos/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: quantity <= 1
                ? null
                : () =>
                    context.read<CartCubit>().removeProductFromCart(product),
            icon: const Icon(
              Icons.remove,
              color: Colors.black,
              size: 25,
            ),
          ),
          Text(
            toArNumber(quantity.toString()),
            style: const TextStyle(fontSize: 20),
          ),
          IconButton(
            onPressed: () => product.quantity.toInt() >= quantity + 1
                ? context.read<CartCubit>().addProductToCart(product)
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
