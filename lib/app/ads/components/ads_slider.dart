import 'package:carousel_slider/carousel_slider.dart';
import 'package:elkosh/app/ads/controllers/ad_details_provider/ad_details_provider.dart';
import 'package:elkosh/app/ads/controllers/ads_cubit/ads_cubit.dart';
import 'package:elkosh/app/ads/widgets/ad_item.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/repos/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdsSlider extends StatelessWidget {
  const AdsSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdsCubit(),
      child: ChangeNotifierProvider(
        create: (context) => AdDetailsProvider(),
        child: BlocConsumer<AdsCubit, AdsState>(
          buildWhen: (p, c) => p != c,
          listenWhen: (p, c) => p != c,
          listener: (context, state) {
            if (state.status == LoadStatus.failure) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: 'خطأ',
                text: 'حدث خطأ أثناء تحميل العروض',
                borderRadius: 25.sp,
                barrierDismissible: false,
                confirmBtnText: "أعد المحاولة",
                onConfirmBtnTap: () {
                  context.pop();
                  context.read<AdsCubit>().fetchAds();
                },
              );
            }
          },
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10.sp),
              decoration: BoxDecoration(
                color: Colors.black12.withValues(alpha: 0.02),
              ),
              child: Skeletonizer(
                enabled: state.status == LoadStatus.inProgress,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: context.height * 0.2,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 8,
                    viewportFraction: 0.8,
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                  ),
                  items: state.ads.map((adv) => AdItem(ad: adv)).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
