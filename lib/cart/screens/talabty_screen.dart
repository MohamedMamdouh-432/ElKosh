import 'package:elkosh/cart/screens/talabaty_history.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/utils.dart';
import 'talbaty_ongoing.dart';

class TalabtyScreen extends StatelessWidget {
  const TalabtyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("الطلبات"),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () => context.go(RouteManager.navbarRoute),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "الطلبات  ",
                  icon: Icon(Icons.list),
                ),
                Tab(
                  text: "السجلات  ",
                  icon: Icon(Icons.list),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              TalbatyOngoing(),
              TalabatyHistory(),
            ],
          ),
        ),
      ),
    );
  }
}
