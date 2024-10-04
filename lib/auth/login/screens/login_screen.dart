import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:elkosh/auth/login/bloc/login_bloc.dart';
import 'package:elkosh/cart/bloc/cart_bloc.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/settings/bloc/profile_bloc.dart';
import 'package:elkosh/shared/widgets/auth_form_field.dart';
import 'package:elkosh/shared/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/quickalert.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: SafeArea(
        child: Scaffold(
          body: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.submissionStatus.isFailure) {
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
                context.read<LoginBloc>().add(LoginStateReset());
              } else if (state.submissionStatus.isSuccess) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: 'نجاح',
                  text: "تم تسجيل الدخول بنجاح",
                  borderRadius: 20,
                  animType: QuickAlertAnimType.scale,
                );
                context.read<ProfileBloc>().add(ProfileLoadingEvent());
                context.read<CartBloc>().add(CartFetchingEvent());
                Future.delayed(
                  const Duration(seconds: 2),
                  () => context.go(RouteManager.navbarRoute),
                );
              } else if (state.submissionStatus.isCanceled) {
                context.read<ProfileBloc>().add(ProfileLoadingEvent());
                context.read<CartBloc>().add(CartFetchingEvent());
                context.go(RouteManager.navbarRoute);
              }
            },
            builder: (context, state) {
              return ConditionalBuilder(
                condition: state.submissionStatus.isCanceled,
                builder: (_) => const SizedBox(),
                fallback: (_) => ModalProgressHUD(
                  inAsyncCall: state.submissionStatus.isInProgress,
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
                            "تسجيل الدخول",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Gap(30),
                        AuthFormField(
                          onChange: (data) => context
                              .read<LoginBloc>()
                              .add(LoginEmailChanged(data)),
                          labelText: 'البريد الالكتروني',
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
                        AuthFormField(
                          obsecured: true,
                          labelText: 'كلمة المرور',
                          onChange: (data) => context
                              .read<LoginBloc>()
                              .add(LoginPasswordChanged(data)),
                          errorText: state.password.isPure
                              ? null
                              : state.password.error ==
                                      PasswordValidationError.empty
                                  ? "كلمة المرور فارغة"
                                  : state.password.error ==
                                          PasswordValidationError.tooShort
                                      ? "يجب الا تقل كلمة المرور عن ٥ حرف"
                                      : state.password.error ==
                                              PasswordValidationError.lacksDigit
                                          ? "يجب ان تحتوى كلمة المرور على الاقل على رقم واحد"
                                          : state.password.error ==
                                                  PasswordValidationError
                                                      .lacksLowercase
                                              ? "يجب ان تحتوى كلمة المرور على الاقل على حرف صغير واحد"
                                              : state.password.error ==
                                                      PasswordValidationError
                                                          .lacksUppercase
                                                  ? "يجب ان تحتوى كلمة المرور على الاقل على حرف كبير واحد"
                                                  : state.password.error ==
                                                          PasswordValidationError
                                                              .lacksSpecialChar
                                                      ? "يجب ان تحتوى كلمة المرور على الاقل على حرف خاص واحد"
                                                      : null,
                        ),
                        const Gap(40),
                        CustomButtom(
                          text: 'تسجيل الدخول',
                          ontap: state.inputStatus == FormStatus.valid
                              ? () => context
                                  .read<LoginBloc>()
                                  .add(FormLoginRequested())
                              : null,
                        ),
                        const Gap(15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('ليس لديك حساب؟'),
                            TextButton(
                              onPressed: () =>
                                  context.push(RouteManager.registerRoute),
                              child: Text(
                                'إنشاء حساب',
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
