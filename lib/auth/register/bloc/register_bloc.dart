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
    on<RegisterSendOTPEvent>(_onRegisterSendOTP);
    on<RegisterVerifyOTPEvent>(_onRegisterVerifyOTP);
    on<RegisterStateReset>(_onRegisterStateReset);
    on<RegisterVerifyStateComplete>(_onRegisterVerifyStateCompleted);
    on<RegisterVerifyStateReset>(_onRegisterVerifyStateReset);
    on<RegisterFormReset>(_onRegisterFormReset);
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
    emit(state.copyWith(submitStatus: FormzSubmissionStatus.inProgress));
    try {
      await sl.get<AuthRepository>().registerWithEmailAndPassword(
            email: state.email.value,
            password: state.password.value,
            name: state.name.value,
            phone: state.phone.value,
          );
      emit(state.copyWith(submitStatus: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        submitStatus: FormzSubmissionStatus.failure,
      ));
    }
  }

  FutureOr<void> _onRegisterSendOTP(event, emit) async {
    try {
      emit(state.copyWith(verifyStatus: VerifyStatus.otpInProgress));
      final sentOtp =
          await sl.get<AuthRepository>().sendOTPMessage(state.phone.value);
      emit(state.copyWith(
        otp: sentOtp,
        verifyStatus: VerifyStatus.otpSent,
      ));
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        verifyStatus: VerifyStatus.otpNotSent,
      ));
    }
  }

  FutureOr<void> _onRegisterVerifyOTP(
      RegisterVerifyOTPEvent event, emit) async {
    try {
      emit(state.copyWith(verifyStatus: VerifyStatus.verifyingInProgress));
      emit(state.copyWith(
        verifyStatus: event.code == state.otp
            ? VerifyStatus.verified
            : VerifyStatus.notVerified,
      ));
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        verifyStatus: VerifyStatus.notVerified,
      ));
    }
  }

  FutureOr<void> _onRegisterVerifyStateCompleted(event, emit) {
    emit(state.copyWith(verifyStatus: VerifyStatus.completed));
  }

  FutureOr<void> _onRegisterStateReset(event, emit) {
    emit(state.copyWith(submitStatus: FormzSubmissionStatus.initial));
  }

  FutureOr<void> _onRegisterVerifyStateReset(event, emit) {
    emit(state.copyWith(verifyStatus: VerifyStatus.initial));
  }

  FutureOr<void> _onRegisterFormReset(event, emit) {
    emit(RegisterState.initial);
  }
}
