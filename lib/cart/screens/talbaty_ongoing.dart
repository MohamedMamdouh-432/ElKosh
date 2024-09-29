import 'package:elkosh/core/utils/image_manager.dart';
import 'package:elkosh/shared/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TalbatyOngoing extends StatelessWidget {
  const TalbatyOngoing({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 15,
            itemBuilder: (ctx, index) => const CustomHistoryListTile(
              text: 'الكميه 30',
            ),
          ),
        ),
        RichText(
          text: const TextSpan(
              style: TextStyle(
                color: Colors.orange,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(text: ' المجموع  : '),
                TextSpan(
                    text: '  155 جنيه', style: TextStyle(color: Colors.black)),
              ]),
        ),
        const Gap(30),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomButtom(text: ' تاكيد الطلب  ', ontap: () {}),
        ),
        const Gap(20),
      ],
    );
  }
}

class CustomHistoryListTile extends StatelessWidget {
  const CustomHistoryListTile({
    super.key,
    this.text,
  });
  final String? text;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: FittedBox(
            child: Image.asset(
              ImageManager.shoppingBasket,
              width: 70,
              height: 70,
            ),
          ),
        ),
      ),
      title: const Text('الاسم'),
      subtitle: const Text('السعر 55 جنيه'),
      trailing: Text(text!),
    );
  }
}
