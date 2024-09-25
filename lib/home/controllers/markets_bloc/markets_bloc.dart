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

  FutureOr<void> _onMarketsLoading(MarketsLoadingEvent event, emit) {}

  FutureOr<void> _onMarketSelected(MarketSelectedEvent event, emit) {
    sl.get<DataRepository>().setCurMarket(event.market);
    emit(state.copyWith(curMarket: event.market));
  }
}
