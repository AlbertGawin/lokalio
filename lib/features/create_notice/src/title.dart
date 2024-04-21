import 'package:formz/formz.dart';

enum TitleValidationError { invalid }

class Title extends FormzInput<String, TitleValidationError> {
  const Title.pure() : super.pure('');

  const Title.dirty([super.value = '']) : super.dirty();

  static final RegExp _titleRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+',
  );

  @override
  TitleValidationError? validator(String? value) {
    return _titleRegExp.hasMatch(value ?? '')
        ? null
        : TitleValidationError.invalid;
  }
}
