import 'package:elkosh/admin/screens/markets_page.dart';
import 'package:elkosh/admin/screens/notifications_page.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('إدارة المتاجر و المنتجات'),
            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2,
              tabs: [
                Tab(
                  icon: Icon(Icons.store_outlined, size: 26),
                  child: Text("المتاجر", textScaler: TextScaler.linear(1.4)),
                ),
                Tab(
                  icon: Icon(Icons.notifications_outlined, size: 26),
                  child: Text("الإشعارات", textScaler: TextScaler.linear(1.4)),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              MarketsPage(),
              NotificationsPage(),
            ],
          ),
        ),
      ),
    );
  }
}
