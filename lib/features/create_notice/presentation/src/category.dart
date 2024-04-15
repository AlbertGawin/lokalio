import 'package:formz/formz.dart';

enum CategoryValidationError { invalid }

class Category extends FormzInput<int, CategoryValidationError> {
  const Category.pure() : super.pure(0);

  const Category.dirty([super.value = 0]) : super.dirty();

  @override
  CategoryValidationError? validator(int? value) {
    return value != null && value >= 0 ? CategoryValidationError.invalid : null;
  }
}
