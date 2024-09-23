import 'package:elkosh/home/widgets/market_item.dart';
import 'package:elkosh/shared/dummy/dummy.dart';
import 'package:flutter/material.dart';

class MarketsView extends StatelessWidget {
  const MarketsView({
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
        ),
      ],
    );
  }
}
