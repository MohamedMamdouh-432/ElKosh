import 'package:auth_repository/auth_repository.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[300],
                child: Image.asset('assets/Kheer_Splash.png'),
                // const Text('H',
                //     style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.email}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12,
                      ),
                      SizedBox(width: 8),
                      Text('مصر'),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.settings),
              )
            ],
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('طلباتي'),
            onTap: () {
              // Handle "Your orders" tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('الدفع'),
            onTap: () {
              // Handle "talabat pay" tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('عن التطبيق'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('الـخروج'),
            onTap: () async{
              await sl.get<AuthRepository>().logOut();
              context.go(RouteManager.loginRoute);
            },
          ),
        ],
      ),
    );
  }
}
