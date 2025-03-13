import 'package:elkosh/app/settings/orders/bloc/orders_cubit.dart';
import 'package:elkosh/app/settings/orders/screens/talabaty_history.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'talbaty_ongoing.dart';

class TalabtyScreen extends StatelessWidget {
  const TalabtyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
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
            appBar: AppBar(
              title: const Text("الطلبات"),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () => context.pop(),
              ),
              bottom: TabBar(
                tabs: const [
                  Tab(
                    text: "الطلبات",
                    icon: Icon(Icons.list),
                  ),
                  Tab(
                    text: "السجلات",
                    icon: Icon(Icons.list),
                  ),
                ],
                onTap: (value) async{
                  await context.read<OrdersCubit>().listenToOrders();
                  if (value == 0)
                    await context.read<OrdersCubit>().fetchOngoingOrders();
                  else
                    await context.read<OrdersCubit>().fetchHistoryOrders();
                },
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
      ),
    );
  }
}
