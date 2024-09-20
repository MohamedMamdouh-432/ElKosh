import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:models_repository/models_repository.dart';

class MarketItem extends StatelessWidget {
  final Market market;
  const MarketItem({
    super.key,
    required this.market,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        isThreeLine: true,
        leading: CachedNetworkImage(
          imageUrl: market.imgUrl,
          fit: BoxFit.cover,
        ),
        title: Text(
          market.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              market.scope,
              style: const TextStyle(
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              market.desc,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black38,
              ),
              // overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
