part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final Name name;
  final Email email;
  final Phone phone;
  final Password password;
  final String errMsg;
  final String otp;
  final FormInputStatus inputStatus;
  final FormzSubmissionStatus submitStatus;
  final VerifyStatus verifyStatus;

  const RegisterState({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.errMsg,
    required this.otp,
    required this.inputStatus,
    required this.submitStatus,
    required this.verifyStatus,
  });

  static RegisterState initial = const RegisterState(
    errMsg: '',
    name: Name.pure(),
    email: Email.pure(),
    phone: Phone.pure(),
    password: Password.pure(),
    otp: '',
    inputStatus: FormInputStatus.initial,
    submitStatus: FormzSubmissionStatus.initial,
    verifyStatus: VerifyStatus.notVerified,
  );

  RegisterState copyWith({
    Name? name,
    Email? email,
    Phone? phone,
    Password? password,
    String? errMsg,
    String? otp,
    FormInputStatus? inputStatus,
    FormzSubmissionStatus? submitStatus,
    VerifyStatus? verifyStatus,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      password: password ?? this.password,
      errMsg: errMsg ?? this.errMsg,
      inputStatus: inputStatus ?? this.inputStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      verifyStatus: verifyStatus ?? this.verifyStatus,
    );
  }

  @override
  String toString() {
    return '''RegisterState ::
      Name: ${name.value}
      Email: ${email.value}
      Phone: ${phone.value}
      Password: ${password.value}
      OTP: $otp
      Error: $errMsg
      Input Status: ${inputStatus.name}
      Verify Status: ${verifyStatus.name}
      Submission Status: ${submitStatus.name}
    ''';
  }

  @override
  List<Object> get props {
    return [
      name,
      email,
      phone,
      password,
      otp,
      errMsg,
      inputStatus,
      submitStatus,
      verifyStatus,
    ];
  }
}
