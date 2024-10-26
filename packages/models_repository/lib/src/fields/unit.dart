import 'package:formz/formz.dart';

enum UnitValidationError { empty, inValidUnit }

class Unit extends FormzInput<String, UnitValidationError> {
  const Unit.pure() : super.pure('كيلو');

  const Unit.dirty([super.value = 'كيلو']) : super.dirty();

  @override
  UnitValidationError? validator(String? value) {
    if (value == null || value == '') return UnitValidationError.empty;
    if (!units.contains(value)) return UnitValidationError.inValidUnit;
    return null;
  }
}

List<String> units = [
  'جرام',
  'كيلو',
  'إبريق',
  'برطمان',
  'كوب',
  'صندوق',
  'رغيف',
  'قطعة',
  'لتر',
  'حزمة',
  'زجاج',
  'كرتون',
  'زجاجة',
  'دلو',
  'علبة',
  'عبوة',
];
