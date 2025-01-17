import 'package:carousel_slider/carousel_slider.dart';
import 'package:elkosh/ads/controllers/ads_bloc/ads_bloc.dart';
import 'package:elkosh/ads/widgets/ad_item.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdsSlider extends StatelessWidget {
  const AdsSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdsBloc(),
      child: BlocConsumer<AdsBloc, AdsState>(
        listener: (context, state) {
          if (state.status == LoadStatus.failure) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'خطأ',
              text: 'حدث خطأ أثناء تحميل العروض',
              borderRadius: 25,
              barrierDismissible: false,
              confirmBtnText: "أعد المحاولة",
              onConfirmBtnTap: () {
                context.pop();
                context.read<AdsBloc>().add(AdsLoadingEvent());
              },
            );
          }
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.black12.withValues(alpha: 0.03),
            ),
            child: Skeletonizer(
              enabled: state.status == LoadStatus.inProgress,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: context.height * 0.22,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 8,
                  viewportFraction: 0.7,
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                ),
                items: state.ads.map((adv) => AdItem(ad: adv)).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
