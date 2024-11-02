import 'dart:async';

import 'package:admin_repository/admin_repository.dart';
import 'package:elkosh/general/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'admin_markets_event.dart';
part 'admin_markets_state.dart';

class AdminMarketsBloc extends Bloc<AdminMarketsEvent, AdminMarketsState> {
  AdminMarketsBloc() : super(AdminMarketsState.initial) {
    on<AdminMarketsLoadingEvent>(_onMarketsLoading);
    on<AdminMarketSelectedEvent>(_onMarketSelected);
    on<AdminMarketDeletingEvent>(_onMarketDeleting);
  }

  FutureOr<void> _onMarketsLoading(AdminMarketsLoadingEvent event, emit) async {
    try {
      emit(state.copyWith(status: LoadingStatus.inProgress));
      final results = await sl.get<AdminRepository>().fetchMarkets(event.limit);
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

  FutureOr<void> _onMarketSelected(AdminMarketSelectedEvent event, emit) async {
    try {
      emit(state.copyWith(
        curMarket: event.market,
        status: LoadingStatus.inProgress,
      ));
      sl.get<AdminRepository>().setCurMarket(event.market);
      emit(state.copyWith(
        status: LoadingStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: LoadingStatus.failure,
      ));
    }
  }

  FutureOr<void> _onMarketDeleting(AdminMarketDeletingEvent event, emit) async {
    try {
      await sl.get<AdminRepository>().deleteMarket(event.marketId);
      final updatedMarkets = List<Market>.from(state.markets)
        ..removeWhere((m) => m.id == event.marketId);
      emit(state.copyWith(markets: updatedMarkets));
    } catch (e) {
      emit(state.copyWith(
        status: LoadingStatus.failure,
        errMsg: e.toString(),
      ));
    }
  }
}
