import 'package:elkosh/home/controllers/markets_bloc/markets_bloc.dart';
import 'package:elkosh/home/widgets/market_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/quickalert.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MarketsView extends StatelessWidget {
  const MarketsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarketsBloc, MarketsState>(
      listener: (context, state) {
        if (state.status == LoadingStatus.failure) {
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
          enabled: state.status == LoadingStatus.inProgress,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "المتاجر",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.markets.length,
                itemBuilder: (_, i) => MarketItem(market: state.markets[i]),
                separatorBuilder: (_, __) => const Divider(
                  thickness: 0.5,
                  color: Colors.black38,
                ),
                padding: const EdgeInsets.only(right: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}
