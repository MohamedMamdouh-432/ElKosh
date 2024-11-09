import 'package:formz/formz.dart';

enum DescValidationError {
  tooShort,
  empty,
}

class Desc extends FormzInput<String, DescValidationError> {
  const Desc.pure() : super.pure('');

  const Desc.dirty([super.value = '']) : super.dirty();

  @override
  DescValidationError? validator(String value) {
    if (value.isEmpty) {
      return DescValidationError.empty;
    }
    if (value.length < 10) {
      return DescValidationError.tooShort;
    }
    return null;
  }
}
