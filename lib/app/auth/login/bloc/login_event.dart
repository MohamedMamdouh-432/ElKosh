part of 'login_bloc.dart';

@immutable
sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginRecognizeRequested extends LoginEvent {}

class LoginEmailChanged extends LoginEvent {
  final String email;
  const LoginEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  const LoginPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class FormLoginRequested extends LoginEvent {}

class GoogleLoginRequested extends LoginEvent {}

class AnonymousLoginRequested extends LoginEvent {}

class LoginStateReset extends LoginEvent {}