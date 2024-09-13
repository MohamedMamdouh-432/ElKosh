import 'package:formz/formz.dart';

enum EmailValidationError {
  empty,
  invalidFormat,
}

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(String? value) {
    if (value?.isEmpty == true) return EmailValidationError.empty;
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value!)
        ? null
        : EmailValidationError.invalidFormat;
  }
}
