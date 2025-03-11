import 'package:elkosh/app/cart/cart_cubit/cart_cubit.dart';
import 'package:elkosh/core/services/functions.dart';
import 'package:elkosh/repos/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartAdQuantityCounter extends StatelessWidget {
  final int quantity;
  final Ad ad;

  const CartAdQuantityCounter({
    super.key,
    required this.quantity,
    required this.ad,
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
                : () => context.read<CartCubit>().removeAdFromCart(ad),
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
            onPressed: () => context.read<CartCubit>().addAdToCart(ad),
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
