import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:elkosh/admin/components/empty_markets_view.dart';
import 'package:elkosh/admin/components/markets_view.dart';
import 'package:elkosh/admin/controllers/markets_bloc/admin_markets_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/quickalert.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MarketsPage extends StatelessWidget {
  const MarketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminMarketsBloc, AdminMarketsState>(
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
              context
                  .read<AdminMarketsBloc>()
                  .add(AdminMarketsLoadingEvent());
            },
          );
        }
      },
      builder: (context, state) => Skeletonizer(
        enabled: state.status == LoadingStatus.inProgress,
        child: ConditionalBuilder(
          condition: state.markets.isEmpty,
          builder: (_) => const EmptyMarketsView(),
          fallback: (_) => AdminMarketsView(markets: state.markets),
        ),
      ),
    );
  }
}
