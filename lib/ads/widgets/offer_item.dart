import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/shared/functions.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:models_repository/models_repository.dart';

class OfferItem extends StatelessWidget {
  final Offer offer;
  const OfferItem(this.offer, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            spreadRadius: 3,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.width * 0.18,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: offer.product.imgUrl,
                // width: 80,
                height: 80,
                fit: BoxFit.fill,
              ),
            ),
          ),
          const Gap(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 130.w,
                child: Text(
                  offer.product.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                toArNumber(offer.quantity.toString()),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "الإجمالى",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                '${toArNumber((offer.product.price * offer.quantity).toString())} جنيه',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.green,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Text(
                '${toArNumber((offer.price * offer.quantity).toString())} جنيه',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
