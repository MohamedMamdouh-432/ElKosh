import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:elkosh/shared/dummy/products.dart';
import 'package:flutter/material.dart';

class SliderHomeScreen extends StatelessWidget {
  const SliderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 180.0,
        width: double.infinity,
        child: AnotherCarousel(
          overlayShadow: true,
          boxFit: BoxFit.fill,
          autoplay: true,
          animationCurve: Curves.fastOutSlowIn,
          dotSize: 6.0,
          dotIncreasedColor: const Color(0xFFFF335C),
          dotBgColor: Colors.yellow.withOpacity(0.0),
          dotPosition: DotPosition.bottomCenter,
          dotVerticalPadding: 7.0,
          showIndicator: true,
          indicatorBgPadding: 5.0,
          images:
              products.map((product) => NetworkImage(product.imgUrl)).toList(),
        ),
      ),
    );
  }
}
