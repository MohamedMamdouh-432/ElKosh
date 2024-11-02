import 'dart:developer';

import 'package:elkosh/admin/controllers/orders_bloc/admin_orders_bloc.dart';
import 'package:elkosh/admin/widgets/admin_order_list_tile.dart';
import 'package:elkosh/core/utils/color_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:models_repository/models_repository.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int idx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AdminOrdersBloc, AdminOrdersState>(
        listener: (context, state) {},
        builder: (context, state) {
          log(state.ongoingOrders.length.toString());
          return ModalProgressHUD(
            inAsyncCall: state.status == OrdersStatus.onProgress,
            child: ListView.builder(
              itemCount: idx == 0
                  ? state.ongoingOrders.length
                  : state.historyOrders.length,
              itemBuilder: (_, i) => AdminOrderListTile(
                  order: idx == 0
                      ? state.ongoingOrders[i]
                      : state.historyOrders[i]),
            ),
          );
        },
      ),
      bottomNavigationBar: GNav(
        selectedIndex: idx,
        activeColor: ColorManager.primary,
        color: Colors.blueGrey,
        backgroundColor: ColorManager.primary.withOpacity(0.07),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        onTabChange: (index) => setState(() => idx = index),
        style: GnavStyle.oldSchool,
        tabs: const [
          GButton(
            text: "الأوردرات الحاليه",
            icon: Icons.arrow_outward_rounded,
          ),
          GButton(
            icon: CupertinoIcons.arrow_down_left,
            text: "الأوردرات السابقه",
          ),
        ],
      ),
    );
  }
}
