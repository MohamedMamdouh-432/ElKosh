import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/app/ads/controllers/ad_details_provider/ad_details_provider.dart';
import 'package:elkosh/app/ads/controllers/ads_cubit/ads_cubit.dart';
import 'package:elkosh/core/utils/utils.dart';
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
        context.read<AdsCubit>().selectAd(ad);
        context.read<AdDetailsProvider>().loadAdDetails();
        context.push(RouteManager.adDetailsRoute);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          useOldImageOnUrlChange: true,
          fit: BoxFit.fill,
          width: double.infinity,
          filterQuality: FilterQuality.high,
          imageUrl: ad.imgUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
              ),
            ),
          ),
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(ad.imgUrl),
                fit: BoxFit.fill,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/error_image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
