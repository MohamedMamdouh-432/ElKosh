import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState.initial) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchQuerySubmitted>(_onSearchQuerySubmitted);
  }

  FutureOr<void> _onSearchQueryChanged(SearchQueryChanged event, emit) async {
    emit(state.copyWith(
      query: event.query,
      status: LoadStatus.inProgress,
    ));
    if (event.query.isEmpty)
      emit(state.copyWith(
        products: [],
        status: LoadStatus.success,
      ));
    try {
      final queryResults =
          await sl.get<DataRepository>().searchForProductByName(event.query);
      queryResults.fold(
        (l) => emit(state.copyWith(
          errMsg: l.message,
          status: LoadStatus.failure,
        )),
        (r) => emit(state.copyWith(
          products: r,
          status: LoadStatus.success,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: LoadStatus.failure,
      ));
    }
  }

  FutureOr<void> _onSearchQuerySubmitted(event, emit) async {
    emit(state.copyWith(status: LoadStatus.inProgress));
    if (event.query.isEmpty)
      emit(state.copyWith(
        products: [],
        status: LoadStatus.success,
      ));
    try {
      final queryResults =
          await sl.get<DataRepository>().searchForProductByName(state.query);
      queryResults.fold(
        (l) => emit(state.copyWith(
          errMsg: l.message,
          status: LoadStatus.failure,
        )),
        (r) => emit(state.copyWith(
          products: r,
          status: LoadStatus.success,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: LoadStatus.failure,
      ));
    }
  }
}
