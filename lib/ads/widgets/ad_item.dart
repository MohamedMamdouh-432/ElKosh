import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/ads/controllers/ad_details_bloc/ad_details_bloc.dart';
import 'package:elkosh/ads/controllers/ads_bloc/ads_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';

class AdItem extends StatelessWidget {
  final Ad ad;
  const AdItem({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<AdsBloc>().add(AdSelectedEvent(ad));
        context.read<AdDetailsBloc>().add(AdDetailsLoadingEvent());
        context.push(RouteManager.adDetailsRoute);
      },
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        width: double.infinity,
        filterQuality: FilterQuality.high,
        imageUrl: ad.imgUrl,
      ),
    );
  }
}
