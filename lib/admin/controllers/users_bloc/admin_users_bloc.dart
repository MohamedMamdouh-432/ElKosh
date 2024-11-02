import 'dart:async';

import 'package:admin_repository/admin_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'admin_users_event.dart';
part 'admin_users_state.dart';

class AdminUsersBloc extends Bloc<AdminUsersEvent, AdminUsersState> {
  AdminUsersBloc() : super(AdminUsersState.initial) {
    on<AdminUsersLoadingEvent>(_onUsersLoading);
    on<AdminUserBlockingEvent>(_onUserBlocking);
    on<AdminUserUnBlockingEvent>(_onUserUnBlocking);
    add(AdminUsersLoadingEvent());
  }

  FutureOr<void> _onUsersLoading(event, emit) async {
    try {
      emit(state.copyWith(status: LoadingStatus.inProgress));
      final results = await sl.get<AdminRepository>().fetchUsers();
      results.fold(
        (l) => emit(state.copyWith(
          errMsg: l.message,
          status: LoadingStatus.failure,
        )),
        (r) => emit(state.copyWith(
          users: r,
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

  FutureOr<void> _onUserBlocking(AdminUserBlockingEvent event, emit) {}

  FutureOr<void> _onUserUnBlocking(AdminUserUnBlockingEvent event, emit) {}
}
