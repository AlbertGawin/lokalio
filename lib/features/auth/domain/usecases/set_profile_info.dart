import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';

class SetProfileInfo implements UseCase<void, ProfileParams> {
  final AuthRepository authRepository;

  const SetProfileInfo({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(ProfileParams params) async {
    return await authRepository.setProfileInfo(
      name: params.name,
      phone: params.phone,
      smsCode: params.smsCode,
    );
  }
}

class ProfileParams extends Equatable {
  final String name;
  final String phone;
  final String smsCode;

  const ProfileParams({
    required this.name,
    required this.phone,
    required this.smsCode,
  });

  @override
  List<Object?> get props => [name, phone, smsCode];
}
