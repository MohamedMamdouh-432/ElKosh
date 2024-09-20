import 'package:elkosh/home/widgets/market_item.dart';
import 'package:elkosh/home/widgets/product_card.dart';
import 'package:elkosh/shared/dummy/dummy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
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
            childAspectRatio: 2 / 2.3,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            children: [
              for (int i = 0; i < 7; i++) ProductCard(product: products[i]),
              InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "المتاجر",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: markets.length,
            itemBuilder: (_, i) => MarketItem(market: markets[i]),
            separatorBuilder: (_, __) => const Divider(
              thickness: 0.5,
              color: Colors.black38,
            ),
            padding: const EdgeInsets.only(right: 16),
          )
        ],
      ),
    );
  }
}
