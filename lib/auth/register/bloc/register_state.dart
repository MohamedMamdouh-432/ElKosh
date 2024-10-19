part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final Name name;
  final Email email;
  final Phone phone;
  final Password password;
  final String errMsg;
  final FormInputStatus inputStatus;
  final FormzSubmissionStatus submissionStatus;

  const RegisterState({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.errMsg,
    required this.inputStatus,
    required this.submissionStatus,
  });

  static RegisterState initial = const RegisterState(
    errMsg: '',
    name: Name.pure(),
    email: Email.pure(),
    phone: Phone.pure(),
    password: Password.pure(),
    inputStatus: FormInputStatus.initial,
    submissionStatus: FormzSubmissionStatus.initial,
  );

  RegisterState copyWith({
    Name? name,
    Email? email,
    Phone? phone,
    Password? password,
    String? errMsg,
    FormInputStatus? inputStatus,
    FormzSubmissionStatus? submissionStatus,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      errMsg: errMsg ?? this.errMsg,
      inputStatus: inputStatus ?? this.inputStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  @override
  String toString() {
    return 'RegisterState\nName: ${name.value}\nEmail: ${email.value}\nPhone: ${phone.value}\npassword: ${password.value}\nError: $errMsg\nInput Status: ${inputStatus.name}\nSubmission Status: ${submissionStatus.name}';
  }

  @override
  List<Object> get props {
    return [
      name,
      email,
      phone,
      password,
      errMsg,
      inputStatus,
      submissionStatus,
    ];
  }
}
