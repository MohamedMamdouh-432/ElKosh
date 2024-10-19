import 'package:formz/formz.dart';

enum HotlineValidationError { invalid, tooShort, empty }

class Hotline extends FormzInput<String, HotlineValidationError> {
  const Hotline.pure() : super.pure('');

  const Hotline.dirty([super.value = '']) : super.dirty();

  @override
  HotlineValidationError? validator(String value) {
    if (value.isEmpty) {
      return HotlineValidationError.empty;
    }
    if (value.length < 3) {
      return HotlineValidationError.tooShort;
    }
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return HotlineValidationError.invalid;
    }
    return null;
  }
}
