import 'package:formz/formz.dart';
import 'package:lokalio/features/create_notice/domain/entities/notice_category.dart';

enum CategoryValidationError { invalid }

class Category extends FormzInput<int, CategoryValidationError> {
  const Category.pure() : super.pure(0);

  const Category.dirty([super.value = 0]) : super.dirty();

  @override
  CategoryValidationError? validator(int? value) {
    return value != null &&
            value >= 0 &&
            value <= (NoticeCategory.values.length - 1)
        ? null
        : CategoryValidationError.invalid;
  }
}
