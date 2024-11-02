import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:elkosh/general/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.initial) {
    on<ProfileLoadingEvent>(_onProfileLoading);
    on<ProfileSigningOutEvent>(_onProfileSignOut);
    on<ProfileDeletingEvent>(_onProfileDeleting);
  }

  FutureOr<void> _onProfileLoading(event, emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    var user = await sl.get<UserRepository>().getUser();
    user.fold(
      (l) => emit(state.copyWith(
        user: User.empty,
        errMsg: l.message,
        status: ProfileStatus.userNotFound,
      )),
      (r) => emit(state.copyWith(
        user: r,
        status: ProfileStatus.userExists,
      )),
    );
  }

  Future<void> _onProfileSignOut(event, emit) async {
    await sl.get<AuthRepository>().logOut();
    await sl.get<UserRepository>().signOut();
    emit(ProfileState.initial);
  }

  FutureOr<void> _onProfileDeleting(event, emit) async {
    await sl.get<AuthRepository>().deleteAccount();
    await sl.get<UserRepository>().deleteAccount();
    emit(ProfileState.initial);
  }
}
