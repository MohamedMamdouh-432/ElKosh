import 'package:elkosh/shared/services/context_media.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageSection extends StatelessWidget {
  final bool isReady;
  final String imageUrl;
  const ImageSection({
    super.key,
    required this.isReady,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.height * 0.4,
      margin: const EdgeInsets.only(bottom: 10),
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
        child: isReady
            ? FancyShimmerImage(
                boxFit: BoxFit.fill,
                imageUrl: imageUrl,
                width: double.infinity,
                height: context.height * 0.4,
                errorWidget: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: Container(
                    width: double.infinity,
                    height: context.height * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              )
            : Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.white,
                child: Container(
                  width: double.infinity,
                  height: context.height * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
      ),
    );
  }
}
