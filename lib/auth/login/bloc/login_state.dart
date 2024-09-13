part of 'login_bloc.dart';

class LoginState extends Equatable {
  final Email email;
  final Password password;
  final String errMsg;
  final FormStatus inputStatus;
  final FormzSubmissionStatus submissionStatus;

  const LoginState({
    required this.email,
    required this.password,
    required this.errMsg,
    required this.inputStatus,
    required this.submissionStatus,
  });
  
  static LoginState initial = const LoginState(
    errMsg: '',
    email: Email.pure(),
    password: Password.pure(),
    inputStatus: FormStatus.initial,
    submissionStatus: FormzSubmissionStatus.initial,
  );

  LoginState copyWith({
    Email? email,
    Password? password,
    String? errMsg,
    FormStatus? inputStatus,
    FormzSubmissionStatus? submissionStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      errMsg: errMsg ?? this.errMsg,
      inputStatus: inputStatus ?? this.inputStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }
  
    @override
  String toString() {
    return 'LoginState\nEmail: ${email.value}\npassword: ${password.value}\nError: $errMsg\nInput Status: ${inputStatus.name}\nSubmission Status: ${submissionStatus.name}';
  }

  @override
  List<Object> get props {
    return [
      email,
      password,
      errMsg,
      inputStatus,
      submissionStatus,
    ];
  }
}
