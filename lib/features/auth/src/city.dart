import 'package:formz/formz.dart';

enum CityValidationError { invalid }

class City extends FormzInput<String, CityValidationError> {
  const City.pure() : super.pure('');

  const City.dirty([super.value = '']) : super.dirty();

  static final RegExp _cityRegExp = RegExp(r'^[a-zA-Z ]{3,16}$');

  @override
  CityValidationError? validator(String? value) {
    return _cityRegExp.hasMatch(value ?? '')
        ? null
        : CityValidationError.invalid;
  }
}
