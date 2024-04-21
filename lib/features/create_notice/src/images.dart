import 'package:formz/formz.dart';

enum ImagesValidationError { invalid }

class Images extends FormzInput<List<String>, ImagesValidationError> {
  const Images.pure() : super.pure(const []);

  const Images.dirty([super.value = const []]) : super.dirty();

  @override
  ImagesValidationError? validator(List<String>? value) {
    return value != null && value.isNotEmpty && value.length <= 4
        ? null
        : ImagesValidationError.invalid;
  }
}
