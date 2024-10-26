import 'package:formz/formz.dart';

enum PriceValidationError { empty, tooShort, tooLong, invalidCharacters }

class Price extends FormzInput<double, PriceValidationError> {
  const Price.pure() : super.pure(0);

  const Price.dirty([super.value = 0]) : super.dirty();

  @override
  PriceValidationError? validator(double? value) {
    if (value == null) return PriceValidationError.empty;
    if (!RegExp("^([0-9][0-9]*)(\\.)?([0-9]+)?\$").hasMatch(value.toString()))
      return PriceValidationError.invalidCharacters;
    if (value < 1) return PriceValidationError.tooShort;
    if (value > 999999) return PriceValidationError.tooLong;
    return null;
  }
}
