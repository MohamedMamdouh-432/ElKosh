import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'markets_event.dart';
part 'markets_state.dart';

class MarketsBloc extends Bloc<MarketsEvent, MarketsState> {
  StreamSubscription? _subscription;
  MarketsBloc() : super(MarketsState.initial) {
    on<MarketsLoadingEvent>(_onMarketsLoading);
    on<MarketSelectedEvent>(_onMarketSelected);
    on<MarketsUpdatedEvent>(_onMarketsUpdated);

    _subscription = sl.get<DataRepository>().marketsStream().listen(
          (result) => result.fold(
            (l) => addError(l.message),
            (r) => add(MarketsUpdatedEvent(r)),
          ),
          onError: (e) => addError(e.toString()),
        );
  }

  FutureOr<void> _onMarketsLoading(event, emit) async {
    try {
      emit(state.copyWith(status: LoadingStatus.inProgress));
      final results = await sl.get<DataRepository>().fetchMarkets();
      results.fold(
        (l) => emit(state.copyWith(
          errMsg: l.message,
          status: LoadingStatus.failure,
        )),
        (r) => emit(state.copyWith(
          markets: r,
          status: LoadingStatus.success,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: LoadingStatus.failure,
      ));
    }
  }

  FutureOr<void> _onMarketSelected(MarketSelectedEvent event, emit) async {
    try {
      sl.get<DataRepository>().setCurMarket(event.market);
      emit(state.copyWith(
        curMarket: event.market,
        status: LoadingStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: LoadingStatus.failure,
      ));
    }
  }

  FutureOr<void> _onMarketsUpdated(MarketsUpdatedEvent event, emit) {
    emit(state.copyWith(
      markets: event.markets,
      status: LoadingStatus.success,
      curMarket: state.curMarket,
    ));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
