part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterNameChanged extends RegisterEvent {
  final String name;
  const RegisterNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;
  const RegisterEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;
  const RegisterPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class RegisterPhoneChanged extends RegisterEvent {
  final String phone;
  const RegisterPhoneChanged(this.phone);

  @override
  List<Object> get props => [phone];
}

class RegisterSendOTPEvent extends RegisterEvent {}

class RegisterVerifyOTPEvent extends RegisterEvent {
  final String code;
  const RegisterVerifyOTPEvent(this.code);
  
  @override
  List<Object> get props => [code];
}

class FormRegisterRequested extends RegisterEvent {}

class RegisterStateReset extends RegisterEvent {}

class RegisterVerifyStateComplete extends RegisterEvent {}

class RegisterVerifyStateReset extends RegisterEvent {}

class RegisterFormReset extends RegisterEvent {}