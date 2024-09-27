import 'package:elkosh/cart/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';

class Cartlistview extends StatelessWidget {
  const Cartlistview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) => const CartItemWidget(),
        itemCount: 10,
      ),
    );
  }
}
