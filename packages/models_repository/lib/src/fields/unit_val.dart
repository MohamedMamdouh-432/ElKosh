import 'package:formz/formz.dart';

enum UnitValueValidationError { empty, invalidCharacters }

class UnitValue extends FormzInput<double, UnitValueValidationError> {
  const UnitValue.pure() : super.pure(0);

  const UnitValue.dirty([super.value = 0]) : super.dirty();

  @override
  UnitValueValidationError? validator(double? value) {
    if (value == null) return UnitValueValidationError.empty;
    if (!RegExp("^([0-9][0-9]*)(\\.)?([0-9]+)?\$").hasMatch(value.toString()))
      return UnitValueValidationError.invalidCharacters;

    return null;
  }
}
