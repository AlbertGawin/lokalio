import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';
import 'package:lokalio/features/auth/presentation/cubit/profile_data_addition_state.dart';
import 'package:lokalio/features/auth/src/city.dart';
import 'package:lokalio/features/auth/src/phone_number.dart';
import 'package:lokalio/features/auth/src/username.dart';

class ProfileDataAdditionCubit extends Cubit<ProfileDataAdditionState> {
  final AuthRepository _repository;

  ProfileDataAdditionCubit(this._repository)
      : super(const ProfileDataAdditionState());

  void usernameChanged(String value) {
    final username = Username.dirty(value);
    emit(state.copyWith(
      username: username,
      isValid: Formz.validate([
        username,
        state.phoneNumber,
        state.city,
      ]),
    ));
  }

  void phoneNumberChanged(String value) {
    final phoneNumber = PhoneNumber.dirty(value);
    emit(state.copyWith(
      phoneNumber: phoneNumber,
      isValid: Formz.validate([
        state.username,
        phoneNumber,
        state.city,
      ]),
    ));
  }

  void cityChanged(String value) {
    final city = City.dirty(value);
    emit(state.copyWith(
      city: city,
      isValid: Formz.validate([
        state.username,
        state.phoneNumber,
        city,
      ]),
    ));
  }

  Future<void> formSubmitted() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _repository.addProfileData(
        username: state.username.value,
        phoneNumber: state.phoneNumber.value,
        city: state.city.value,
      );

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on AddProfileDataFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzSubmissionStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
