import 'package:elkosh/user/cart/widgets/empty_bag.dart';
import 'package:elkosh/core/utils/image_manager.dart';
import 'package:flutter/material.dart';

class EmptyBageWidgetScreen extends StatelessWidget {
  const EmptyBageWidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyBagWidget(
      imagePath: ImageManager.shoppingCart,
      title: "الـسـله فارغة",
      subtitle:
          'من الواضح انك لم تقم بالتسوق بعد . لذا يمكنك الانتقال الى الصفحة الرئيسية لتتصفح المنتجات و المتاجر المتاحه',
      buttonText: 'تسـوق الان',
    );
  }
}
