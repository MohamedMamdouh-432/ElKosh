import 'package:flutter/material.dart';

import 'talbaty_ongoing.dart';

class TalabatyHistory extends StatelessWidget {
  const TalabatyHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, index) => const CustomHistoryListTile(
              text: 'تم التسليم',
            ),
        itemCount: 8);
  }
}
