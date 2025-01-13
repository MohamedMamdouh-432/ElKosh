part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final Name name;
  final Email email;
  final Phone phone;
  final Password password;
  final String errMsg;
  final FormInputStatus inputStatus;
  final FormzSubmissionStatus submissionStatus;
  final String verifyCode;
  final VerificationStatus verificationStatus;

  const RegisterState({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.errMsg,
    required this.inputStatus,
    required this.submissionStatus,
    required this.verifyCode,
    required this.verificationStatus,
  });

  static RegisterState initial = const RegisterState(
    errMsg: '',
    name: Name.pure(),
    email: Email.pure(),
    phone: Phone.pure(),
    password: Password.pure(),
    inputStatus: FormInputStatus.initial,
    submissionStatus: FormzSubmissionStatus.initial,
    verifyCode: '',
    verificationStatus: VerificationStatus.notVerified,
  );

  RegisterState copyWith({
    Name? name,
    Email? email,
    Phone? phone,
    Password? password,
    String? errMsg,
    FormInputStatus? inputStatus,
    FormzSubmissionStatus? submissionStatus,
    String? verifyCode,
    VerificationStatus? verificationStatus,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      errMsg: errMsg ?? this.errMsg,
      inputStatus: inputStatus ?? this.inputStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      verifyCode: verifyCode ?? this.verifyCode,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }

  @override
  String toString() {
    return '''RegisterState ::
      Name: ${name.value}
      Email: ${email.value}
      Phone: ${phone.value}
      Password: ${password.value}
      Error: $errMsg
      Input Status: ${inputStatus.name}
      Submission Status: ${submissionStatus.name}
    ''';
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
      verifyCode,
      verificationStatus,
    ];
  }
}
