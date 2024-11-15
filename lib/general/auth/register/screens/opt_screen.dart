import 'dart:developer';

import 'package:elkosh/general/core/utils/utils.dart';
import 'package:elkosh/general/shared/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';

class OptScreen extends StatelessWidget {
  const OptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Image.asset('assets/opt.png'),
              Text(
                "تم إرسال رمز التحقق الى رقم الهاتف !\n ادخل الرمز من فضلك لاستكمال تسجيل الدخول",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              Gap(30.h),
              Pinput(
                length: 6,
                defaultPinTheme: ConstsManager.defaultPinTheme,
                focusedPinTheme: ConstsManager.defaultPinTheme
                    .copyDecorationWith(
                        border: Border.all(color: ColorManager.primary)),
                submittedPinTheme: ConstsManager.defaultPinTheme
                    .copyDecorationWith(color: Colors.grey.shade200),
                validator: (s) {
                  return s == '000000' ? '✅✅✅' : '❌❌❌';
                },
                pinputAutovalidateMode: PinputAutovalidateMode.disabled,
                showCursor: true,
                onCompleted: (pin) => log(pin),
              ),
              Gap(50.h),
              CustomButtom(
                text: 'التحقق و تسجيل الدخول',
                ontap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
