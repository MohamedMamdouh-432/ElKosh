import 'package:elkosh/widgets/custom_buttom.dart';
import 'package:elkosh/widgets/custom_textform_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email, password;

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
                    const Gap(70),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'هــلا بــك',
                            style: TextStyle(
                              fontSize: 32,
                              fontFamily: 'pacifico',
                              color: Colors.white,
                            ),
                          ),
                        ]),
                    const SizedBox(
                      height: 75,
                    ),
                    const Row(
                      children: [
                        Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Gap(15),
                    CustomTextformField(
                      onChange: (data) {
                        email = data;
                      },
                      hintText: 'Email',
                    ),
                    const Gap(10),
                    CustomTextformField(
                      onChange: (data) {
                        password = data;
                      },
                      hintText: 'Password',
                    ),
                    const Gap(15),
                    CustomButtom(
                      Ontap: () async {
                        if (formkey.currentState!.validate()) {
                          isLoaded = true;
                          setState(() {});
                          try {
                            await SignInUser();
                            //navigate to home page
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.warning,
                                text: 'user-not-found',
                              );
                            } else if (e.code == 'wrong-password') {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Oops...',
                                text: 'Wrong password provided for that user',
                              );
                            }
                          } catch (e) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: 'Oops...',
                              text: 'There was an error',
                            );
                          }
                          isLoaded = false;
                          setState(() {});
                        }
                      },
                      text: 'Sign In',
                    ),
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text(
                            'Don\'t have an account?',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push('/signUp');
                          },
                          child: const Text(
                            ' Register',
                            style: TextStyle(
                              color: Colors.blue,
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

  Future<void> SignInUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
