import 'package:auth_repository/auth_repository.dart';
import 'package:elkosh/core/utils/route_manager.dart';
import 'package:elkosh/widgets/custom_buttom.dart';
import 'package:elkosh/widgets/custom_textform_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quickalert/quickalert.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;
  String? password;
  String? PhoneNumber;
  String? firstName;
  String? lastName;
  GlobalKey<FormState> formkey = GlobalKey();
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isLoaded,
          child: Scaffold(
            backgroundColor: const Color(0xff2B475E),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Form(
                key: formkey,
                child: ListView(
                  children: [
                    const Gap(35),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const Gap(32),
                    const Row(
                      children: [
                        Text(
                          'REGISTER',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    CustomTextformField(
                      hintText: 'First Name',
                      onChange: (data) {
                        firstName = data;
                      },
                    ),
                    const Gap(10),
                    CustomTextformField(
                      hintText: 'Last Name',
                      onChange: (data) => lastName = data,
                    ),
                    const Gap(10),
                    CustomTextformField(
                      onChange: (data) {
                        email = data;
                      },
                      hintText: 'Email',
                    ),
                    const Gap(10),
                    CustomTextformField(
                      hintText: 'Phone Number',
                      onChange: (data) {
                        PhoneNumber = data;
                      },
                    ),
                    const Gap(10),
                    CustomTextformField(
                      obsecured: true,
                      hintText: 'Password',
                      onChange: (data) {
                        password = data;
                      },
                    ),
                    const Gap(15),
                    CustomButtom(
                      text: 'Register',
                      Ontap: () async {
                        if (formkey.currentState!.validate()) {
                          isLoaded = true;
                          setState(() {});
                          try {
                            await RegisterUser();
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              title: 'Sucessfully Registered',
                              text: 'You can now login',
                            );

                            // Navigate to another page after successful registration.
                            // Navigator.pushNamed(context, LoginPage.id);
                          } on SignUpWithEmailAndPasswordFailure catch (e) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: 'Oops...',
                              text: e.message.isNotEmpty
                                  ? e.message
                                  : 'An unknown error occurred. Please try again.',
                            );
                          } catch (e) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: 'Oops...',
                              text: 'There was an error. Please try again.',
                            );
                          }

                          isLoaded = false;
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text(
                            'Already have an account',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push(RouteManager.signInRoute);
                          },
                          child: const Text(
                            ' LOGIN',
                            style: TextStyle(
                              color: Colors.yellowAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> RegisterUser() async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }
}
