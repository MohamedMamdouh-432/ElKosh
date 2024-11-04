import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/general/shared/services/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models_repository/models_repository.dart';

part 'categorys_event.dart';
part 'categorys_state.dart';

class CategorysBloc extends Bloc<CategorysEvent, CategorysState> {
  CategorysBloc() : super(CategorysState.initial) {
    on<CategorysLoadingEvent>(_onCategorysLoading);
    on<CategorySelectedEvent>(_onCategorySelected);
    add(const CategorysLoadingEvent());
  }
  
  FutureOr<void> _onCategorysLoading(event, emit) async {
    try {
      emit(state.copyWith(status: LoadingStatus.inProgress));
      final results = await sl.get<DataRepository>().fetchCategories();
      results.fold(
        (l) => emit(state.copyWith(
          errMsg: l.message,
          status: LoadingStatus.failure,
        )),
        (r) => emit(state.copyWith(
          categorys: r,
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

  FutureOr<void> _onCategorySelected(CategorySelectedEvent event, emit) async {
    try {
      sl.get<DataRepository>().setCurCategory(event.category);
      emit(state.copyWith(
        curCategory: event.category,
        status: LoadingStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: LoadingStatus.failure,
      ));
    }
  }
}
