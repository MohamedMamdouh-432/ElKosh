import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/general/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'offers_event.dart';
part 'offers_state.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  OffersBloc() : super(OffersState.initial) {
    on<OffersLoadingEvent>(_onOffersLoading);
    on<OfferSelectedEvent>(_onOfferSelecting);
    add(OffersLoadingEvent());
  }

  FutureOr<void> _onOffersLoading(event, emit) async {
    try {
      emit(state.copyWith(status: LoadingStatus.inProgress));
      final results = await sl.get<DataRepository>().fetchOffers();
      results.fold(
          (l) => emit(state.copyWith(
                errMsg: l.message,
                status: LoadingStatus.failure,
              )),
          (r) => emit(state.copyWith(
                offers: r,
                status: LoadingStatus.success,
              )));
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: LoadingStatus.failure,
      ));
    }
  }

  FutureOr<void> _onOfferSelecting(OfferSelectedEvent event, emit) async {
    try {
      sl.get<DataRepository>().setCurOffer(event.offer);
      emit(state.copyWith(
        curOffer: event.offer,
        status: LoadingStatus.inProgress,
      ));
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: LoadingStatus.failure,
      ));
    }
  }
}
