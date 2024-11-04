import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:elkosh/general/shared/services/context_media.dart';
import 'package:elkosh/user/home/controllers/offers_bloc/offers_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class OffersSlider extends StatelessWidget {
  const OffersSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OffersBloc(),
      child: BlocConsumer<OffersBloc, OffersState>(
        listener: (context, state) {
          if (state.status == LoadingStatus.failure) {
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
                context.read<OffersBloc>().add(OffersLoadingEvent());
              },
            );
          }
        },
        builder: (context, state) {
          return CarouselSlider(
            options: CarouselOptions(
              height: context.height * 0.22,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 8,
              viewportFraction: 0.7,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
            ),
            items: state.offers
                .map((offer) => InkWell(
                      onTap: () => context
                          .read<OffersBloc>()
                          .add(OfferSelectedEvent(offer)),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: double.infinity,
                        filterQuality: FilterQuality.high,
                        imageUrl: offer.imgUrl,
                      ),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
