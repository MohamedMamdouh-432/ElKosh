import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';

class AdminImageItem extends StatelessWidget {
  final String imageUrl;
  const AdminImageItem({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        height: context.height * 0.4,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(30),
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xffF2F3F2),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            width: double.infinity,
            height: context.height * 0.4,
          ),
        ),
      ),
    );
  }
}
