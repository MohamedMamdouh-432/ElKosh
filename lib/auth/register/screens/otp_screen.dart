import 'package:elkosh/auth/register/bloc/register_bloc.dart';
import 'package:elkosh/auth/widgets/auth_button.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:models_repository/models_repository.dart';
import 'package:pinput/pinput.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 247, 234, 250),
              Color.fromARGB(255, 250, 240, 236),
              Color.fromARGB(255, 235, 244, 251),
              Color.fromARGB(255, 246, 237, 233),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocConsumer<RegisterBloc, RegisterState>(
            buildWhen: (p, c) => p != c,
            listenWhen: (p, c) => p != c,
            listener: (context, state) {
              if (state.submitStatus.isFailure) {
                String msg = state.errMsg;
                if (msg.startsWith("Exception:"))
                  msg = msg.substring(msg.indexOf(":") + 1);
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: 'خطأ',
                  text: msg,
                  borderRadius: 20,
                  animType: QuickAlertAnimType.scale,
                );
                context.read<RegisterBloc>().add(RegisterStateReset());
              } else if (state.submitStatus.isSuccess) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: 'نجاح',
                  text: "تم إنشاء حسابك بنجاح! يمكنك الان تسجيل الدخول",
                  borderRadius: 20,
                  animType: QuickAlertAnimType.scale,
                );
                context.read<RegisterBloc>().add(RegisterFormReset());
                context.go(RouteManager.loginRoute);
              }
              if (state.verifyStatus == VerifyStatus.verified) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: 'نجاح',
                  text: "تم التحقق بنجاح",
                  borderRadius: 20,
                  animType: QuickAlertAnimType.scale,
                );
                context.read<RegisterBloc>().add(RegisterVerifyStateComplete());
              }
              if (state.verifyStatus == VerifyStatus.notVerified) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: 'خطأ',
                  text: "خطأ في التحقق",
                  borderRadius: 20,
                  animType: QuickAlertAnimType.scale,
                );
                context.read<RegisterBloc>().add(RegisterVerifyStateReset());
              }
            },
            builder: (context, state) {
              return ModalProgressHUD(
                inAsyncCall: state.submitStatus.isInProgress ||
                    state.verifyStatus == VerifyStatus.otpInProgress ||
                    state.verifyStatus == VerifyStatus.verifyingInProgress,
                child: SingleChildScrollView(
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        defaultPinTheme: ConstsManager.defaultPinTheme,
                        focusedPinTheme: ConstsManager.defaultPinTheme
                            .copyDecorationWith(
                                border:
                                    Border.all(color: ColorManager.primary)),
                        submittedPinTheme: ConstsManager.defaultPinTheme
                            .copyDecorationWith(color: Colors.grey.shade200),
                        validator: (s) => s == '000000' ? '✅✅✅' : '❌❌❌',
                        pinputAutovalidateMode: PinputAutovalidateMode.disabled,
                        showCursor: true,
                        onCompleted: (pin) => context
                            .read<RegisterBloc>()
                            .add(RegisterVerifyOTPEvent(pin)),
                      ),
                      Gap(50.h),
                      AuthButton(
                        text: 'التحقق و تسجيل الدخول',
                        color: state.verifyStatus != VerifyStatus.completed
                            ? Colors.grey
                            : null,
                        ontap: state.verifyStatus != VerifyStatus.completed
                            ? null
                            : () => context
                                .read<RegisterBloc>()
                                .add(FormRegisterRequested()),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
