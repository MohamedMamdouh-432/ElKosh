import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/markets/controllers/markets_bloc/markets_bloc.dart';
import 'package:elkosh/shared/functions.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:elkosh/shared/services/time_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final timeService = TimeService();
    return InkWell(
      onTap: () {
        context.read<MarketsBloc>().add(MarketSelectedEvent(market));
        context.push(RouteManager.marketDetailsRoute);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: context.height * 0.12,
                width: context.width * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black38),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: CachedNetworkImageProvider(market.imgUrl),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: context.width * 0.6,
                    child: Text(
                      market.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StreamBuilder<DateTime>(
                    stream: timeService.curTimeStream,
                    builder: (_, timeValue) {
                      if (!timeValue.hasData) return const SizedBox.shrink();
                      bool isOpened = isMarketOpen(market, timeValue.data!);
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isOpened ? Colors.green : Colors.blueGrey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isOpened ? 'مفتوح' : 'مغلق',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: context.width * 0.5,
                    height: context.height * 0.05,
                    child: Text(
                      market.desc,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
