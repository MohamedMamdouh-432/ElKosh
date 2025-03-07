import 'package:elkosh/app/settings/components/settings_appbar.dart';
import 'package:elkosh/app/settings/controllers/profile_provider.dart';
import 'package:elkosh/app/settings/orders/bloc/orders_cubit.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, pp, child) {
        return Skeletonizer(
          enabled: pp.status == ProfileStatus.loading,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SettingsAppBar(),
                const Gap(40),
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
                    context.read<OrdersCubit>().fetchOngoingOrders();
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
                      animType: QuickAlertAnimType.rotate,
                      confirmBtnText: 'حسنا',
                      cancelBtnText: ' لا ',
                      title: ' 😲 تحذير',
                      context: context,
                      type: QuickAlertType.warning,
                      text: "هل انت متاكد من  تسجيل الخرج",
                      showCancelBtn: true,
                      cancelBtnTextStyle: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 18),
                      onCancelBtnTap: () {
                        context.pop();
                      },
                      onConfirmBtnTap: () {
                        context.read<ProfileProvider>().signOut();
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
                      showCancelBtn: true,
                      type: QuickAlertType.warning,
                      text: "هل انت متاكد من حذف الحساب",
                      onCancelBtnTap: () {
                        context.pop();
                      },
                      onConfirmBtnTap: () {
                        context.read<ProfileProvider>().deleteProfile();
                        context.go(RouteManager.loginRoute);
                      },
                    );
                  },
                ),
                const Gap(40),
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
