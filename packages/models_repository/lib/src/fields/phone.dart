import 'package:formz/formz.dart';

enum PhoneValidationError { empty, invalid, notaNumber }

class Phone extends FormzInput<String, PhoneValidationError> {
  const Phone.pure() : super.pure('');
  const Phone.dirty([super.value = '']) : super.dirty();

  @override
  PhoneValidationError? validator(String? value) {
    if (value?.isEmpty == true) return PhoneValidationError.empty;
    if (int.tryParse(value!) == null)
      return PhoneValidationError.notaNumber;
    else if (value.length != 11) return PhoneValidationError.invalid;
    return null;
  }
}
