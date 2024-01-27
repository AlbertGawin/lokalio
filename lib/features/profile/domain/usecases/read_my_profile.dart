import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';
import 'package:lokalio/features/profile/domain/repositories/profile_repository.dart';

class ReadMyProfile implements UseCase<Profile, NoParams> {
  final ProfileRepository repository;

  const ReadMyProfile({required this.repository});

  @override
  Future<Either<Failure, Profile>> call(NoParams params) async {
    return await repository.readMyProfile();
  }
}
