import 'package:formz/formz.dart';

enum DescriptionValidationError { invalid }

class Description extends FormzInput<String, DescriptionValidationError> {
  const Description.pure() : super.pure('');

  const Description.dirty([super.value = '']) : super.dirty();

  static final RegExp _descriptionRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+',
  );

  @override
  DescriptionValidationError? validator(String? value) {
    return _descriptionRegExp.hasMatch(value ?? '')
        ? null
        : DescriptionValidationError.invalid;
  }
}
