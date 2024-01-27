import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';
import 'package:lokalio/features/profile/domain/repositories/profile_repository.dart';

class ReadProfile implements UseCase<Profile, Params> {
  final ProfileRepository repository;

  const ReadProfile({required this.repository});

  @override
  Future<Either<Failure, Profile>> call(Params params) async {
    return await repository.readProfile(profileId: params.profileId);
  }
}

class Params extends Equatable {
  final String profileId;

  const Params({required this.profileId});

  @override
  List<Object?> get props => [profileId];
}
