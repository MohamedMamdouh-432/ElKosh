import 'dart:async';
import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  StreamSubscription? _subscription;

  AdsCubit() : super(AdsState.initial) {
    _listenToAdsStream();
  }

  void _listenToAdsStream() {
    _subscription?.cancel();
    _subscription = sl.get<DataRepository>().adsStream().listen(
      (result) {
        result.fold(
          (l) => emit(
              state.copyWith(errMsg: l.message, status: LoadStatus.failure)),
          (r) => _onAdsUpdated(r),
        );
      },
      onError: (e) => emit(
          state.copyWith(errMsg: e.toString(), status: LoadStatus.failure)),
    );
  }

  Future<void> loadAds() async {
    try {
      emit(state.copyWith(status: LoadStatus.inProgress));
      final results = await sl.get<DataRepository>().fetchAds();
      results.fold(
        (l) =>
            emit(state.copyWith(errMsg: l.message, status: LoadStatus.failure)),
        (r) => emit(state.copyWith(ads: r, status: LoadStatus.success)),
      );
    } catch (e) {
      emit(state.copyWith(errMsg: e.toString(), status: LoadStatus.failure));
    }
  }

  void selectAd(Ad ad) {
    try {
      sl.get<DataRepository>().setCurAd(ad);
      emit(state.copyWith(curAd: ad));
    } catch (e) {
      emit(state.copyWith(errMsg: e.toString(), status: LoadStatus.failure));
    }
  }

  void _onAdsUpdated(List<Ad> ads) {
    emit(state.copyWith(status: LoadStatus.updated));
    emit(state.copyWith(ads: ads, status: LoadStatus.success));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
