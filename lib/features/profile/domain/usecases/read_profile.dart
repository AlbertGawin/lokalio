import 'package:fpdart/fpdart.dart';
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
    return await repository.readProfile(userId: params.userId);
  }
}

class Params extends Equatable {
  final String userId;

  const Params({required this.userId});

  @override
  List<Object?> get props => [userId];
}
