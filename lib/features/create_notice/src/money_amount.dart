import 'package:formz/formz.dart';

enum MoneyAmountValidationError { invalid }

class MoneyAmount extends FormzInput<String, MoneyAmountValidationError> {
  const MoneyAmount.pure() : super.pure('');

  const MoneyAmount.dirty([super.value = '']) : super.dirty();

  static final RegExp _moneyAmountRegExp = RegExp(r'^[0-9]+$');

  @override
  MoneyAmountValidationError? validator(String? value) {
    return _moneyAmountRegExp.hasMatch(value.toString())
        ? null
        : MoneyAmountValidationError.invalid;
  }
}
