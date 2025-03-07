import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:models_repository/models_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial) {
    on<LoginRecognizeRequested>(_onRecognizeLogin);
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPsswordChanged);
    on<FormLoginRequested>(_onLoginWithEmailAndPassword);
    on<LoginStateReset>(_onLoginStateReset);
  }

  FutureOr<void> _onRecognizeLogin(event, emit) async {
    final userId = await sl.get<AuthRepository>().userId;
    emit(state.copyWith(
      submissionStatus: userId == null
          ? FormzSubmissionStatus.initial
          : FormzSubmissionStatus.canceled,
    ));
  }

  FutureOr<void> _onEmailChanged(LoginEmailChanged event, emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      inputStatus: Formz.validate([
        email,
        state.password,
      ])
          ? FormInputStatus.valid
          : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onPsswordChanged(LoginPasswordChanged event, emit) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      inputStatus: Formz.validate([
        state.email,
        password,
      ])
          ? FormInputStatus.valid
          : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onLoginWithEmailAndPassword(event, emit) async {
    if (state.inputStatus == FormInputStatus.invalid) return;
    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));
    try {
      await sl.get<AuthRepository>().logInWithEmailAndPassword(
            email: state.email.value,
            password: state.password.value,
          );
      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        submissionStatus: FormzSubmissionStatus.failure,
      ));
    }
  }

  FutureOr<void> _onLoginStateReset(event, emit) {
    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.initial));
  }
}
