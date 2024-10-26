import 'package:formz/formz.dart';

enum QuantityValidationError { empty, tooShort, tooLong, invalidCharacters }

class Quantity extends FormzInput<double, QuantityValidationError> {
  const Quantity.pure() : super.pure(0);

  const Quantity.dirty([super.value = 0]) : super.dirty();

  @override
  QuantityValidationError? validator(double? value) {
    if (value == null) return QuantityValidationError.empty;
    if (!RegExp("^([0-9][0-9]*)(\\.)?([0-9]+)?\$").hasMatch(value.toString()))
      return QuantityValidationError.invalidCharacters;
    if (value < 1) return QuantityValidationError.tooShort;
    if (value > 999999) return QuantityValidationError.tooLong;
    return null;
  }
}
