import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'offers_event.dart';
part 'offers_state.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  StreamSubscription? _subscription;
  OffersBloc() : super(OffersState.initial) {
    on<OffersLoadingEvent>(_onOffersLoading);
    on<OfferSelectedEvent>(_onOfferSelecting);
    on<OffersUpdatedEvent>(_onOffersUpdated);

    _subscription = sl.get<DataRepository>().offersStream().listen(
        (result) => result.fold(
              (l) => addError(l.message),
              (r) => add(OffersUpdatedEvent(r)),
            ),
        onError: (e) => addError(e.toString()));
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
  
  FutureOr<void> _onOffersUpdated(OffersUpdatedEvent event, emit) {
    emit(state.copyWith(
      offers: event.offers,
      status: LoadingStatus.success,
      curOffer: state.curOffer,
    ));
  }
  
  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
