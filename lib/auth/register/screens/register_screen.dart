import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elkosh/auth/register/bloc/register_bloc.dart';
import 'package:elkosh/auth/widgets/auth_button.dart';
import 'package:elkosh/auth/widgets/tip_text.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/shared/widgets/auth_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class RegisterScreen extends StatelessWidget {
  final ValueNotifier<bool> isPasswordObscured = ValueNotifier<bool>(true);
  RegisterScreen({super.key});

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
              if (state.verifyStatus == VerifyStatus.otpSent) {
                context.push(RouteManager.otpRoute);
                context.read<RegisterBloc>().add(RegisterVerifyStateReset());
              }
            },
            builder: (context, state) {
              return ModalProgressHUD(
                inAsyncCall: state.verifyStatus == VerifyStatus.otpInProgress,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const Gap(50),
                      Text(
                        'أهلا بك فى خير بلدنا',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.primary,
                        ),
                      ),
                      const Gap(50),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'إنشاء حساب',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Gap(20),
                      InputFormField(
                        isObscured: isPasswordObscured,
                        labelText: 'الأسم',
                        onChange: (data) => context
                            .read<RegisterBloc>()
                            .add(RegisterNameChanged(data)),
                        errorText: state.name.isPure
                            ? null
                            : state.name.error == NameValidationError.empty
                                ? "الأسم فارغ"
                                : state.name.error ==
                                        NameValidationError.tooShort
                                    ? "يجب ان يحتوى الاسم على اكثر من حرفين"
                                    : state.name.error ==
                                            NameValidationError.tooLong
                                        ? "يجب الا يزيد الاسم عن ٢٥ حرف"
                                        : state.name.error ==
                                                NameValidationError
                                                    .invalidCharacters
                                            ? "يجب الا يحتوى الاسم على اى من العلامات الخاصه"
                                            : null,
                      ),
                      const Gap(15),
                      InputFormField(
                        isObscured: isPasswordObscured,
                        labelText: 'رقم الهاتف',
                        inputType: TextInputType.phone,
                        onChange: (data) => context
                            .read<RegisterBloc>()
                            .add(RegisterPhoneChanged(data)),
                        errorText: state.phone.isPure
                            ? null
                            : state.phone.error == PhoneValidationError.empty
                                ? "رقم الهاتف فارغ"
                                : state.phone.error ==
                                        PhoneValidationError.invalid
                                    ? "رقم الهاتف غير صالح"
                                    : state.phone.error ==
                                            PhoneValidationError.notaNumber
                                        ? "يجب ان يحتوى رقم الهاتف على ارقام فقط"
                                        : null,
                      ),
                      const Gap(15),
                      InputFormField(
                        isObscured: isPasswordObscured,
                        onChange: (data) => context
                            .read<RegisterBloc>()
                            .add(RegisterEmailChanged(data)),
                        labelText: 'البريد الإلكترونى',
                        errorText: state.email.isPure
                            ? null
                            : state.email.error == EmailValidationError.empty
                                ? "البريد الإلكترونى فارغ"
                                : state.email.error ==
                                        EmailValidationError.invalidFormat
                                    ? "البريد الإلكترونى غير صالح"
                                    : null,
                      ),
                      const Gap(15),
                      InputFormField(
                        isObscured: isPasswordObscured,
                        obsecured: true,
                        labelText: 'كلمة المرور',
                        onChange: (data) => context
                            .read<RegisterBloc>()
                            .add(RegisterPasswordChanged(data)),
                        errorText: state.password.isPure
                            ? null
                            : state.password.error ==
                                    PasswordValidationError.empty
                                ? "كلمة المرور فارغة"
                                : state.password.error ==
                                        PasswordValidationError.tooShort
                                    ? "يجب الا تقل كلمة المرور عن ٥ حرف"
                                    : null,
                      ),
                      const Gap(10),
                      const TipText(
                          tip: "يجب ان تتكون كلمة المرور من ٥ احرف فأكثر"),
                      const Gap(40),
                      AuthButton(
                        text: 'تسجيل الحساب',
                        ontap: state.inputStatus != FormInputStatus.valid ||
                                state.verifyStatus == VerifyStatus.otpInProgress
                            ? null
                            : () async {
                                Future<bool> isUserBlockedByEmailOrPhone(
                                    String email, String phoneNumber) async {
                                  final firestore = FirebaseFirestore.instance;
                                  try {
                                    // Check if the email is blocked
                                    final emailQuery = await firestore
                                        .collection('blockedUsers')
                                        .where('email', isEqualTo: email)
                                        .get();

                                    // Check if the phone number is blocked
                                    final phoneQuery = await firestore
                                        .collection('blockedUsers')
                                        .where('phoneNumber',
                                            isEqualTo: phoneNumber)
                                        .get();

                                    // If either email or phone number is blocked, return true
                                    return emailQuery.docs.isNotEmpty ||
                                        phoneQuery.docs.isNotEmpty;
                                  } catch (e) {
                                    print('Error checking blocked user: $e');
                                    throw Exception(
                                        "حدث خطأ أثناء التحقق من حالة الحظر");
                                  }
                                }

                                if (await isUserBlockedByEmailOrPhone(
                                    state.email.value, state.phone.value)) {
                                  print("User is blocked");
                                  QuickAlert.show(
                                    confirmBtnText: 'حسنا',
                                    title: ' خطأ',
                                    context: context,
                                    type: QuickAlertType.warning,
                                    text:
                                        "الحساب محظور بسبب البريد الإلكتروني أو رقم الهاتف",
                                  );
                                } else {
                                  if (state.verifyStatus ==
                                      VerifyStatus.otpInProgress) return;
                                  context
                                      .read<RegisterBloc>()
                                      .add(RegisterSendOTPEvent());
                                }
                              },
                      ),
                      const Gap(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('لدى حساب بالفعل'),
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                color: ColorManager.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('بتسجيل الحساب فانك توافق علي ',
                              style: TextStyle(fontSize: 10.sp)),
                          TextButton(
                            onPressed: () =>
                                context.push(RouteManager.privacyPolicyRoute),
                            child: Text(
                              "سياسة الخصوصية",
                              style: TextStyle(
                                color: ColorManager.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
