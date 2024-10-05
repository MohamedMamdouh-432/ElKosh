import 'package:carousel_slider/carousel_slider.dart';
import 'package:elkosh/shared/dummy/products.dart';
import 'package:flutter/material.dart';

class ProductsSlider extends StatelessWidget {
  const ProductsSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.22,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 8,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.7,
      ),
      items: products
          .map(
            (product) => Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Image.network(product.imgUrl),
            ),
          )
          .toList(),
    );
  }
}
