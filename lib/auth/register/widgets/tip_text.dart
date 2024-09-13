import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TipText extends StatelessWidget {
  final String tip;

  const TipText({
    super.key,
    required this.tip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.circle,
          size: 8,
          color: Colors.blueGrey,
        ),
        const Gap(10),
        Text(
          tip,
          textScaler: const TextScaler.linear(1),
        ),
      ],
    );
  }
}
