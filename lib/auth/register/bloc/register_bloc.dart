import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:models_repository/models_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState.initial) {
    on<RegisterNameChanged>(_onNameChanged);
    on<RegisterPhoneChanged>(_onPhoneChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPsswordChanged);
    on<FormRegisterRequested>(_onRegisterWithEmailAndPassword);
    on<RegisterStateReset>(_onRegisterStateReset);
  }

  FutureOr<void> _onNameChanged(RegisterNameChanged event, emit) {
    final name = Name.dirty(event.name);
    emit(state.copyWith(
      name: name,
      inputStatus: Formz.validate([
        name,
        state.phone,
        state.email,
        state.password,
      ])
          ? FormInputStatus.valid
          : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onPhoneChanged(RegisterPhoneChanged event, emit) {
    final phone = Phone.dirty(event.phone);
    emit(state.copyWith(
      phone: phone,
      inputStatus: Formz.validate([
        state.name,
        phone,
        state.email,
        state.password,
      ])
          ? FormInputStatus.valid
          : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onEmailChanged(RegisterEmailChanged event, emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      inputStatus: Formz.validate([
        state.name,
        state.phone,
        email,
        state.password,
      ])
          ? FormInputStatus.valid
          : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onPsswordChanged(RegisterPasswordChanged event, emit) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      inputStatus: Formz.validate([
        state.name,
        state.phone,
        state.email,
        password,
      ])
          ? FormInputStatus.valid
          : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onRegisterWithEmailAndPassword(event, emit) async {
    if (state.inputStatus == FormInputStatus.invalid) return;
    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));
    try {
      await sl.get<AuthRepository>().registerWithEmailAndPassword(
            email: state.email.value,
            password: state.password.value,
            name: state.name.value,
            phone: state.phone.value,
          );
      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        submissionStatus: FormzSubmissionStatus.failure,
      ));
    }
  }

  FutureOr<void> _onRegisterStateReset(event, emit) {
    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.initial));
  }
}
