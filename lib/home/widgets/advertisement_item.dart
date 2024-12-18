import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/home/controllers/ads_bloc/ads_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

class AdItem extends StatelessWidget {
  final Advertisment ad;
  const AdItem({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<AdsBloc>().add(AdSelectedEvent(ad)),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        width: double.infinity,
        filterQuality: FilterQuality.high,
        imageUrl: ad.imgUrl,
      ),
    );
  }
}
