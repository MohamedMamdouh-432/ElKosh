import 'package:elkosh/markets/controllers/markets_bloc/markets_bloc.dart';
import 'package:elkosh/markets/widgets/market_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/quickalert.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MarketsView extends StatelessWidget {
  const MarketsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MarketsBloc(),
      child: BlocConsumer<MarketsBloc, MarketsState>(
        buildWhen: (p, c) => p != c,
        listenWhen: (p, c) => p != c,
        listener: (context, state) {
          if (state.status == LoadStatus.failure) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'حدث خطأ ما',
              text: 'حدث خطأ أثناء تحميل المتاجر',
              borderRadius: 25,
              barrierDismissible: false,
              confirmBtnText: "أعد المحاولة",
              onConfirmBtnTap: () {
                context.pop();
                context.read<MarketsBloc>().add(MarketsLoadingEvent());
              },
            );
          }
        },
        builder: (context, state) {
          return Skeletonizer(
            enabled: state.status == LoadStatus.inProgress,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.black12.withValues(alpha: 0.02),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "استكشف المتاجر",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(20),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.markets.length,
                    itemBuilder: (_, i) => MarketItem(market: state.markets[i]),
                    separatorBuilder: (_, __) => const Divider(
                      thickness: 0.5,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
