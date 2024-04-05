import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lokalio/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> signIn({required AuthCredential credential});
  Future<Either<Failure, void>> signInAnonymously();
  Future<Either<Failure, void>> signUp(
      {required String email, required String password});
  Future<Either<Failure, void>> signOut();
}
