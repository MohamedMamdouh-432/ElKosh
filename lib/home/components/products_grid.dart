import 'package:elkosh/home/widgets/product_card.dart';
import 'package:elkosh/shared/dummy/dummy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "تصفح المنتجات",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.extent(
          shrinkWrap: true,
          maxCrossAxisExtent: 110,
          crossAxisSpacing: 5,
          childAspectRatio: 2 / 1.8,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          children: [
            for (int i = 0; i < 7; i++) ProductCard(product: products[i]),
            InkWell(
              onTap: () {},
              child: Column(
                children: [
                  const Gap(10),
                  Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      CupertinoIcons.square_grid_2x2,
                      size: 32,
                    ),
                  ),
                  const Text("عرض الكل"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
