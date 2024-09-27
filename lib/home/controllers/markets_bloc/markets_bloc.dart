import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'markets_event.dart';
part 'markets_state.dart';

class MarketsBloc extends Bloc<MarketsEvent, MarketsState> {
  MarketsBloc() : super(MarketsState.initial) {
    on<MarketsLoadingEvent>(_onMarketsLoading);
    on<MarketSelectedEvent>(_onMarketSelected);
    add(const MarketsLoadingEvent());
  }

  FutureOr<void> _onMarketsLoading(MarketsLoadingEvent event, emit) async {
    try {
      emit(state.copyWith(status: LoadingStatus.inProgress));
      final results = await sl.get<DataRepository>().fetchMarkets(event.limit);
      results.fold(
        (l) => emit(state.copyWith(
          errMsg: l.errorMessage,
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
      emit(state.copyWith(
        curMarket: event.market,
        status: LoadingStatus.inProgress,
      ));
      sl.get<DataRepository>().setCurMarket(event.market);
      final results = await sl.get<DataRepository>().fetchRelatedProducts();
      results.fold(
        (l) => emit(state.copyWith(
          errMsg: l.errorMessage,
          status: LoadingStatus.failure,
        )),
        (r) => emit(state.copyWith(
          relProducts: r,
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
}
