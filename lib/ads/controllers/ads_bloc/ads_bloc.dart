import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'ads_event.dart';
part 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  StreamSubscription? _subscription;
  AdsBloc() : super(AdsState.initial) {
    on<AdsLoadingEvent>(_onAdsLoading);
    on<AdSelectedEvent>(_onAdSelecting);
    on<AdsUpdatedEvent>(_onAdsUpdated);

    _subscription?.cancel();
    _subscription = sl.get<DataRepository>().adsStream().listen(
        (result) => result.fold(
              (l) => addError(l.message),
              (r) => add(AdsUpdatedEvent(r)),
            ),
        onError: (e) => addError(e.toString()));
  }

  FutureOr<void> _onAdsLoading(event, emit) async {
    try {
      emit(state.copyWith(status: LoadStatus.inProgress));
      final results = await sl.get<DataRepository>().fetchAds();
      results.fold(
          (l) => emit(state.copyWith(
                errMsg: l.message,
                status: LoadStatus.failure,
              )),
          (r) => emit(state.copyWith(
                ads: r,
                status: LoadStatus.success,
              )));
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: LoadStatus.failure,
      ));
    }
  }

  FutureOr<void> _onAdSelecting(AdSelectedEvent event, emit) async {
    try {
      sl.get<DataRepository>().setCurAd(event.ad);
      emit(state.copyWith(curAd: event.ad));
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: LoadStatus.failure,
      ));
    }
  }

  FutureOr<void> _onAdsUpdated(AdsUpdatedEvent event, emit) {
    emit(state.copyWith(status: LoadStatus.updated));
    emit(state.copyWith(
      ads: event.ads,
      status: LoadStatus.success,
    ));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
