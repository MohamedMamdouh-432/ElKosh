import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/home/controllers/markets_bloc/markets_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';

class MarketItem extends StatelessWidget {
  final Market market;
  const MarketItem({
    super.key,
    required this.market,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<MarketsBloc>().add(MarketSelectedEvent(market));
        context.push(RouteManager.marketDetailsRoute);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black38,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: CachedNetworkImageProvider(market.imgUrl),
                    )),
              ),
              const Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    market.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    market.hotline,
                    style: const TextStyle(fontSize: 16),
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
            ],
          )),
    );
  }
}
