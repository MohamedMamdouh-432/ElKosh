import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/settings/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/quickalert.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: BlocConsumer<ProfileBloc, ProfileState>(
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
                  onTap: () => context.push(RouteManager.talabatyScreen),
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
                const Divider(height: 5, indent: 100, endIndent: 100),
                Visibility(
                  visible: state.user.userType != UserType.admin,
                  child: ListTile(
                    leading: Icon(
                      Icons.store,
                      size: 35,
                      color: ColorManager.primary,
                    ),
                    title: const Text(
                      'إدارة متاجرى',
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () => context.push(RouteManager.sellerRoute),
                  ),
                ),
                Visibility(
                  visible: state.user.userType == UserType.admin,
                  child: ListTile(
                    leading: const Icon(
                      Icons.settings,
                      size: 35,
                      color: Colors.cyan,
                    ),
                    title: const Text(
                      'إدارة التطبيق',
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {},
                  ),
                ),
                const Divider(height: 5, indent: 100, endIndent: 100),
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
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    size: 35,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'الـخروج',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () async {
                    context.read<ProfileBloc>().add(ProfileSigningOutEvent());
                    context.go(RouteManager.loginRoute);
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
                    context.read<ProfileBloc>().add(ProfileDeletingEvent());
                    context.go(RouteManager.loginRoute);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
