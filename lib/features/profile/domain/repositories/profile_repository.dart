import 'package:fpdart/fpdart.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile({required String userId});
}
