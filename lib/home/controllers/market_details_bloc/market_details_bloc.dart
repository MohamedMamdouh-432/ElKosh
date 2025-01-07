import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'market_details_event.dart';
part 'market_details_state.dart';

class MarketDetailsBloc extends Bloc<MarketDetailsEvent, MarketDetailsState> {
  StreamSubscription? _subscription;
  MarketDetailsBloc() : super(MarketDetailsState.initial) {
    on<MarketDetailsLoadingEvent>(_onMarketDetailsLoaded);
    on<MarketDetailsUpdatingEvent>(_onMarketDetailsUpdated);

    _subscription = sl.get<DataRepository>().marketDetailsStream().listen(
          (result) => result.fold((l) => addError(l.message),
              (r) => add(MarketDetailsUpdatingEvent(r))),
        );
  }

  FutureOr<void> _onMarketDetailsLoaded(MarketDetailsLoadingEvent event, emit) {
    emit(state.copyWith(status: LoadStatus.inProgress));
    emit(state.copyWith(
      status: LoadStatus.success,
      market: sl.get<DataRepository>().getCurMarket(),
    ));
  }

  FutureOr<void> _onMarketDetailsUpdated(
      MarketDetailsUpdatingEvent event, emit) {
    emit(state.copyWith(
      market: event.market,
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
