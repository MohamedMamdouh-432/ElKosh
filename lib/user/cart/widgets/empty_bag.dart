import 'package:elkosh/user/home/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';

class EmptyBagWidget extends StatelessWidget {
  final String imagePath, title, subtitle, buttonText;

  const EmptyBagWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: size.height * 0.2,
              width: double.infinity,
            ),
            SubtitleTextWidget(
              label: title,
              fontWeight: FontWeight.w600,
              fontSize: 35,
              color: Colors.red,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SubtitleTextWidget(
                label: subtitle,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
