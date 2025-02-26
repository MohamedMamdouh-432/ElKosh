import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'markets_state.dart';

class MarketsCubit extends Cubit<MarketsState> {
  StreamSubscription? _subscription;
  final DataRepository _dataRepository = sl.get<DataRepository>();

  MarketsCubit() : super(MarketsState.initial) {
    _subscription = _dataRepository.marketsStream().listen(
          (result) => result.fold(
            (l) => emit(
                state.copyWith(status: LoadStatus.failure, errMsg: l.message)),
            (r) => emit(state.copyWith(markets: r, status: LoadStatus.success)),
          ),
          onError: (e) => emit(
              state.copyWith(status: LoadStatus.failure, errMsg: e.toString())),
        );
  }

  Future<void> fetchMarkets() async {
    try {
      emit(state.copyWith(status: LoadStatus.inProgress));
      final results = await _dataRepository.fetchMarkets();
      results.fold(
        (l) =>
            emit(state.copyWith(status: LoadStatus.failure, errMsg: l.message)),
        (r) => emit(state.copyWith(markets: r, status: LoadStatus.success)),
      );
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, errMsg: e.toString()));
    }
  }

  void selectMarket(Market market) {
    try {
      _dataRepository.setCurMarket(market);
      emit(state.copyWith(curMarket: market, status: LoadStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, errMsg: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
