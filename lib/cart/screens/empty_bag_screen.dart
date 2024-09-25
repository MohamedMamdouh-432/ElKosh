import 'package:elkosh/cart/widgets/empty_bag.dart';
import 'package:elkosh/core/utils/image_manager.dart';
import 'package:flutter/material.dart';

class EmptyBageWidgetScreen extends StatelessWidget {
  const EmptyBageWidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyBagWidget(
      imagePath: ImageManager.shoppingCart,
      title: "الـسـله فارغة",
      subtitle: 'من الواضح انك لسه مضـفتش حاجه للسله يلا املاها دلوقت ',
      buttonText: 'تسـوق الان',
    );
  }
}
