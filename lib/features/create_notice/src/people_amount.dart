import 'package:formz/formz.dart';

enum PeopleAmountValidationError { invalid }

class PeopleAmount extends FormzInput<String, PeopleAmountValidationError> {
  const PeopleAmount.pure() : super.pure('');

  const PeopleAmount.dirty([super.value = '']) : super.dirty();

  static final RegExp _peopleAmountRegExp = RegExp(r'^[0-9]+$');

  @override
  PeopleAmountValidationError? validator(String? value) {
    return _peopleAmountRegExp.hasMatch(value.toString())
        ? null
        : PeopleAmountValidationError.invalid;
  }
}
