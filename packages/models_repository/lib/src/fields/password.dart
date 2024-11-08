import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty,
  tooShort,
  lacksUppercase,
  lacksLowercase,
  lacksDigit,
  lacksSpecialChar,
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String? value) {
    if (value?.isEmpty == true) return PasswordValidationError.empty;
    if ((value?.length ?? 0) < 5) return PasswordValidationError.tooShort;
    if (!RegExp(r'[A-Z]').hasMatch(value ?? ''))
      return PasswordValidationError.lacksUppercase;
    if (!RegExp(r'[a-z]').hasMatch(value ?? ''))
      return PasswordValidationError.lacksLowercase;
    if (!RegExp(r'\d').hasMatch(value ?? ''))
      return PasswordValidationError.lacksDigit;
    return !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value ?? '')
        ? PasswordValidationError.lacksSpecialChar
        : null;
  }
}
