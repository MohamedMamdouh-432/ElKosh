import 'dart:async';

import 'package:admin_repository/admin_repository.dart';
import 'package:elkosh/general/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'admin_category_event.dart';
part 'admin_category_state.dart';

class AdminCategoryBloc extends Bloc<AdminCategoryEvent, AdminCategoryState> {
  AdminCategoryBloc() : super(AdminCategoryState.initial) {
    on<AdminCategorysLoadingEvent>(_onCategorysLoading);
    on<AdminCategorySelectedEvent>(_onCategorySelected);
    on<AdminCategoryAddingEvent>(_onCategoryAdding);
    on<AdminCategoryDeletingEvent>(_onCategoryDeleting);
    on<AdminCategoryResetEvent>(_onCategoryReset);
  }

  FutureOr<void> _onCategorysLoading(
      AdminCategorysLoadingEvent event, emit) async {
    try {
      emit(state.copyWith(loadingStatus: LoadingStatus.inProgress));
      final results = await sl.get<AdminRepository>().fetchCategories();
      results.fold(
        (l) => emit(state.copyWith(
          errMsg: l.message,
          loadingStatus: LoadingStatus.failure,
        )),
        (r) => emit(state.copyWith(
          categorys: r,
          loadingStatus: LoadingStatus.success,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        loadingStatus: LoadingStatus.failure,
      ));
    }
  }

  FutureOr<void> _onCategorySelected(AdminCategorySelectedEvent event, emit) {
    try {
      emit(state.copyWith(
        curCategory: event.category,
        loadingStatus: LoadingStatus.inProgress,
      ));
      sl.get<AdminRepository>().setCurCategory(event.category);
      emit(state.copyWith(
        loadingStatus: LoadingStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        loadingStatus: LoadingStatus.failure,
      ));
    }
  }

  FutureOr<void> _onCategoryAdding(AdminCategoryAddingEvent event, emit) async {
    emit(state.copyWith(addingStatus: AddingStatus.inProgress));
    final res = await sl.get<AdminRepository>().addCategory(event.categoryItem);

    res.fold((left) {
      emit(state.copyWith(
        errMsg: left.message,
        addingStatus: AddingStatus.failure,
      ));
    }, (right) {
      emit(state.copyWith(addingStatus: AddingStatus.success));
    });
  }

  FutureOr<void> _onCategoryDeleting(
      AdminCategoryDeletingEvent event, emit) async {
    try {
      await sl.get<AdminRepository>().deleteCategory(event.categoryId);
      final updatedCategorys = List<Category>.from(state.categorys)
        ..removeWhere((m) => m.id == event.categoryId);
      emit(state.copyWith(categorys: updatedCategorys));
    } catch (e) {
      emit(state.copyWith(
        loadingStatus: LoadingStatus.failure,
        errMsg: e.toString(),
      ));
    }
  }

  FutureOr<void> _onCategoryReset(AdminCategoryResetEvent event, emit) {
    emit(state.copyWith(addingStatus: AddingStatus.initial));
  }
}
