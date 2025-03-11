import 'dart:async';

import 'package:elkosh/core/services/service_locator.dart';
import 'package:elkosh/repos/data_repo.dart';
import 'package:elkosh/repos/enums/enums.dart';
import 'package:elkosh/repos/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'categorys_event.dart';
part 'categorys_state.dart';

class CategorysBloc extends Bloc<CategorysEvent, CategorysState> {
  StreamSubscription? _subscription;
  CategorysBloc() : super(CategorysState.initial) {
    on<CategorysLoadingEvent>(_onCategorysLoading);
    on<CategorySelectedEvent>(_onCategorySelected);
    on<CategorysUpdatedEvent>(_onCategorysUpdated);

    _subscription = sl.get<DataRepo>().categorysStream().listen(
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
      final results = await sl.get<DataRepo>().fetchCategories();
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
      sl.get<DataRepo>().setCurCategory(event.category);
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
