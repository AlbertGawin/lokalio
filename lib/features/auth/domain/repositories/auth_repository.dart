import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> signIn({
    required String email,
    required String password,
  });
  Future<Either<Failure, bool>> signUp({
    required String email,
    required String password,
  });
  Future<Either<Failure, bool>> signOut();
}
