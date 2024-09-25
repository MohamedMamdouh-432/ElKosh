import 'package:elkosh/core/utils/utils.dart' show ColorManager;
import 'package:flutter/material.dart';

class ProductQuantityCounter extends StatelessWidget {
  final int quantity = 1;
  const ProductQuantityCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            // if counter is 1 then do nothing
            // decrease quantity counter by 1
          },
          icon: const Icon(
            Icons.remove,
            size: 35,
            // if counter is 1 then set color to grey
            // color: ColorManager.primary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey),
          ),
          child: Text(
            quantity.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            // increase quantity counter by 1
          },
          icon: Icon(
            Icons.add,
            size: 35,
            color: ColorManager.primary,
          ),
        ),
      ],
    );
  }
}
