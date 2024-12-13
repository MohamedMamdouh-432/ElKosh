import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:elkosh/home/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageManager.shoppingCart,
            height: context.height * 0.2,
            width: double.infinity,
          ),
          const SubtitleTextWidget(
            label: "الـسـله فارغة",
            fontWeight: FontWeight.w600,
            fontSize: 35,
            color: Colors.red,
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: SubtitleTextWidget(
              label:
                  'من الواضح انك لم تقم بالتسوق بعد . لذا يمكنك الانتقال الى الصفحة الرئيسية لتتصفح المنتجات و المتاجر المتاحه',
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
