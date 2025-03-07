import 'package:elkosh/core/theme/themes.dart';
import 'package:flutter/material.dart';

class OrderSection extends StatelessWidget {
  final String sectionTitle;
  const OrderSection({super.key, required this.sectionTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            endIndent: 10,
            thickness: 2,
            color: ColorManager.primary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ColorManager.primary),
          ),
          child: Text(
            sectionTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            indent: 10,
            thickness: 2,
            color: ColorManager.primary,
          ),
        ),
      ],
    );
  }
}
