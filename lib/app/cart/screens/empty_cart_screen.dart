import 'package:elkosh/core/utils/utils.dart';
import 'package:flutter/material.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Images.shoppingCart,
            height: context.height * 0.2,
            width: double.infinity,
          ),
          const Text(
            "الـسـله فارغة",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              color: Colors.red,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.none,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'من الواضح انك لم تقم بالتسوق بعد . لذا يمكنك الانتقال الى الصفحة الرئيسية لتتصفح المنتجات و المتاجر المتاحه',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
