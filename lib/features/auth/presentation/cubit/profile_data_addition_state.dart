import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:lokalio/features/auth/src/city.dart';
import 'package:lokalio/features/auth/src/phone_number.dart';
import 'package:lokalio/features/auth/src/username.dart';

final class ProfileDataAdditionState extends Equatable {
  final Username username;
  final PhoneNumber phoneNumber;
  final City city;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  const ProfileDataAdditionState({
    this.username = const Username.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.city = const City.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        username,
        phoneNumber,
        city,
        status,
        isValid,
        errorMessage,
      ];

  ProfileDataAdditionState copyWith({
    Username? username,
    PhoneNumber? phoneNumber,
    City? city,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return ProfileDataAdditionState(
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      city: city ?? this.city,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
