import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkosh/admin/controllers/category_bloc/admin_category_bloc.dart';
import 'package:elkosh/admin/controllers/market_form_bloc/market_form_bloc.dart';
import 'package:elkosh/admin/controllers/markets_bloc/admin_markets_bloc.dart';
import 'package:elkosh/general/core/utils/utils.dart';
import 'package:elkosh/general/shared/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AdminMarketItem extends StatelessWidget {
  final Market market;
  const AdminMarketItem({
    super.key,
    required this.market,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<AdminMarketsBloc>().add(AdminMarketSelectedEvent(market));
        context.read<AdminCategoryBloc>().add(AdminCategorysLoadingEvent());
        context.push(RouteManager.adminCategorysRoute);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: context.height * 0.12,
              width: context.width * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black38),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(market.imgUrl),
                ),
              ),
            ),
            const Gap(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  market.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  market.hotline,
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: context.width * 0.5,
                  height: context.height * 0.03,
                  child: Text(
                    market.desc,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    context
                        .read<MarketFormBloc>()
                        .add(MarketFormPrepared(market));
                    context.push(RouteManager.editMarketRoute);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.green,
                    size: 25.sp,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title: 'هل تريد توقيف هذا المتجر ؟',
                      borderRadius: 25,
                      barrierDismissible: false,
                      showConfirmBtn: true,
                      showCancelBtn: true,
                      confirmBtnText: 'توقيف',
                      onConfirmBtnTap: () {
                        context.pop();
                        // context
                        //     .read<AdminMarketsBloc>()
                        //     .add(AdminMarketDeletingEvent(market.id));
                      },
                      confirmBtnColor: Colors.deepPurple,
                      cancelBtnText: 'رجوع',
                      onCancelBtnTap: () => context.pop(),
                    );
                  },
                  icon: Icon(
                    Icons.lock,
                    size: 25.sp,
                    color: Colors.deepPurple.shade600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title: 'هل تريد حذف هذا المتجر ؟',
                      borderRadius: 25,
                      barrierDismissible: false,
                      showConfirmBtn: true,
                      showCancelBtn: true,
                      confirmBtnText: 'حذف',
                      onConfirmBtnTap: () {
                        context.pop();
                        context
                            .read<AdminMarketsBloc>()
                            .add(AdminMarketDeletingEvent(market.id));
                      },
                      confirmBtnColor: Colors.red,
                      cancelBtnText: 'رجوع',
                      onCancelBtnTap: () => context.pop(),
                    );
                  },
                  icon: Icon(
                    Icons.delete_forever,
                    size: 25.sp,
                    color: Colors.red.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
