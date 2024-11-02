import 'package:elkosh/admin/widgets/admin_market_item.dart';
import 'package:elkosh/general/core/utils/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';

class AdminMarketsView extends StatelessWidget {
  final List<Market> markets;

  const AdminMarketsView({
    super.key,
    required this.markets,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ListView.separated(
          itemCount: markets.length,
          itemBuilder: (_, i) => AdminMarketItem(market: markets[i]),
          separatorBuilder: (_, __) => const Divider(
            thickness: 0.5,
            color: Colors.black38,
          ),
          padding: const EdgeInsets.only(right: 16, bottom: 80),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: ElevatedButton.icon(
            onPressed: () => context.push(RouteManager.addMarketRoute),
            icon: const Icon(Icons.add),
            label: Text(
              'أضف متجر',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
