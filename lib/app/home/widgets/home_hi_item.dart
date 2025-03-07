import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/core/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeHiItem extends StatelessWidget {
  final String name;
  const HomeHiItem({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext ctx) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 10,
                ),
                constraints: BoxConstraints(
                  maxWidth: ctx.width * .6,
                  minWidth: ctx.width * .1,
                ),
                child: Text(
                  'أهلا بك يا $name',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SvgPicture.asset(ImageManager.hiSvg),
            ],
          ),
          const Text(
            'ابدأ رحلة التسوق',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
