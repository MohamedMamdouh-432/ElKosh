import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';

class ImageSection extends StatelessWidget {
  final String imageUrl;
  const ImageSection({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.height * 0.4,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 20),
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.fill,
          filterQuality: FilterQuality.high,
          width: double.infinity,
          height: context.height * 0.4,
        ),
      ),
    );
  }
}
