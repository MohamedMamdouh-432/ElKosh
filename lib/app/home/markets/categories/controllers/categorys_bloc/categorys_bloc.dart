import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/core/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'categorys_event.dart';
part 'categorys_state.dart';

class CategorysBloc extends Bloc<CategorysEvent, CategorysState> {
  StreamSubscription? _subscription;
  CategorysBloc() : super(CategorysState.initial) {
    on<CategorysLoadingEvent>(_onCategorysLoading);
    on<CategorySelectedEvent>(_onCategorySelected);
    on<CategorysUpdatedEvent>(_onCategorysUpdated);

    _subscription = sl.get<DataRepository>().categorysStream().listen(
          (result) => result.fold(
            (l) => addError(l.message),
            (r) => add(CategorysUpdatedEvent(r)),
          ),
          onError: (e) => addError(e.toString()),
        );
  }

  FutureOr<void> _onCategorysLoading(event, emit) async {
    try {
      emit(state.copyWith(status: LoadStatus.inProgress));
      final results = await sl.get<DataRepository>().fetchCategories();
      results.fold(
        (l) => emit(state.copyWith(
          errMsg: l.message,
          status: LoadStatus.failure,
        )),
        (r) => emit(state.copyWith(
          categorys: r,
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

  FutureOr<void> _onCategorySelected(CategorySelectedEvent event, emit) async {
    try {
      sl.get<DataRepository>().setCurCategory(event.category);
      emit(state.copyWith(
        curCategory: event.category,
        status: LoadStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: LoadStatus.failure,
      ));
    }
  }

  FutureOr<void> _onCategorysUpdated(CategorysUpdatedEvent event, emit) {
    emit(state.copyWith(
      categorys: event.categorys,
      status: LoadStatus.success,
      curCategory: state.curCategory,
    ));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
