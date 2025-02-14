import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/orders/bloc/orders_bloc.dart';
import 'package:elkosh/settings/bloc/profile_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/quickalert.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      buildWhen: (p, c) => p != c,
      listenWhen: (p, c) => p != c,
      listener: (context, state) {
        if (state.status == ProfileStatus.userNotFound) {
          String msg = state.errMsg;
          if (msg.startsWith("Exception:"))
            msg = msg.substring(msg.indexOf(":") + 1);
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'حدث خطأ ما',
            text: msg,
            borderRadius: 25,
            barrierDismissible: false,
            confirmBtnText: "تسجيل الدخول",
            onConfirmBtnTap: () {
              context.pop();
              context.go(RouteManager.loginRoute);
            },
          );
        }
      },
      builder: (context, state) {
        return Skeletonizer(
          enabled: state.status == ProfileStatus.loading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        child: Center(
                          child: Text(
                            state.user.name[0],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Gap(16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.user.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              wordSpacing: 3,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone_enabled_rounded,
                                color: Colors.green,
                                size: 25,
                              ),
                              const Gap(10),
                              Text(
                                state.user.phone,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.lime,
                                size: 25,
                              ),
                              Gap(10),
                              Text(
                                'مصر',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 32, indent: 20, endIndent: 20),
                ListTile(
                  leading: const Icon(
                    Icons.assignment,
                    size: 35,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    'طلباتي',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    context.read<OrdersBloc>().add(OrdersFetchedEvent());
                    context.push(RouteManager.talabatyScreen);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.account_balance_wallet,
                    size: 35,
                    color: Colors.teal,
                  ),
                  title: const Text(
                    'الدفع',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    // Handle "talabat pay" tap
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    size: 35,
                    color: Colors.purple,
                  ),
                  title: const Text(
                    'عن التطبيق',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () => context.push(RouteManager.aboutAppRoute),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    size: 35,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () async {
                    QuickAlert.show(
                      confirmBtnText: 'حسنا',
                      cancelBtnText: ' لا ',
                      title: ' 😲 تحذير',
                      context: context,
                      type: QuickAlertType.warning,
                      text: "هل انت متاكد من  تسجيل الخرج",
                      onCancelBtnTap: () {
                        context.pop();
                      },
                      onConfirmBtnTap: () {
                        context
                            .read<ProfileBloc>()
                            .add(ProfileSigningOutEvent());
                        context.go(RouteManager.loginRoute);
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete,
                    size: 35,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'حذف الحساب',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () async {
                    QuickAlert.show(
                      confirmBtnText: 'حسنا',
                      cancelBtnText: '😍 لا ',
                      title: ' 😲 تحذير',
                      context: context,
                      type: QuickAlertType.warning,
                      text: "هل انت متاكد من حذف الحساب",
                      onCancelBtnTap: () {
                        context.pop();
                      },
                      onConfirmBtnTap: () {
                        context.read<ProfileBloc>().add(ProfileDeletingEvent());
                        context.go(RouteManager.loginRoute);
                      },
                    );
                  },
                ),
                const Gap(10),
                const Row(
                  children: [
                    Expanded(
                        child: Divider(height: 32, indent: 20, endIndent: 20)),
                    Text('تواصل معنا', style: TextStyle(fontSize: 18)),
                    Expanded(
                        child: Divider(height: 32, indent: 20, endIndent: 20)),
                  ],
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Card(
                      elevation: 5,
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: () async {
                          final Uri phoneUri = Uri(
                            scheme: 'tel',
                            path: "01063734753",
                          );
                          try {
                            await launchUrl(phoneUri);
                          } catch (e) {
                            AppLogs.error('Setting Phone Error: $e');
                          }
                        },
                        iconSize: 40,
                        color: Colors.green,
                        icon: const Icon(CupertinoIcons.phone),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: () async {
                          const String phoneNumber = "+201063734753";
                          final Uri whatsappUri =
                              Uri.parse('https://wa.me/$phoneNumber');
                          try {
                            await launchUrl(whatsappUri);
                          } catch (e) {
                            AppLogs.error('Setting Whatsapp Error: $e');
                          }
                        },
                        iconSize: 40,
                        color: Colors.green,
                        icon: const Icon(FontAwesomeIcons.whatsapp),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: () async {
                          final Uri facebookUri = Uri.parse(
                              "https://www.facebook.com/share/g/1DDTGTQz5R/");
                          try {
                            await launchUrl(facebookUri);
                          } catch (e) {
                            AppLogs.error('Setting Facebook Error: $e');
                          }
                        },
                        iconSize: 40,
                        color: Colors.indigo,
                        icon: const Icon(FontAwesomeIcons.facebook),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
