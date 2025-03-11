import 'package:formz/formz.dart';

enum NameValidationError { empty, tooShort, tooLong, invalidCharacters }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String value) {
    if (value.isEmpty) return NameValidationError.empty;
    if (value.length < 3) return NameValidationError.tooShort;
    if (value.length > 25) return NameValidationError.tooLong;
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')))
      return NameValidationError.invalidCharacters;
    return null;
  }
}
