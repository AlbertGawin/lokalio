import 'package:dartz/dartz.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> signIn(
      {required String email, required String password}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signIn(email: email, password: password);

        return const Right(true);
      } on FirebaseException catch (e) {
        if (e.code == 'user-not-found') {
          return const Left(UserNotFoundFailure());
        } else if (e.code == 'wrong-password') {
          return const Left(WrongPasswordFailure());
        } else {
          return const Left(ServerFailure());
        }
      } on Exception {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> signUp(
      {required String email, required String password}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signUp(email: email, password: password);

        return const Right(true);
      } on FirebaseException catch (e) {
        if (e.code == 'email-already-in-use') {
          return const Left(EmailAlreadyInUseFailure());
        } else {
          return const Left(ServerFailure());
        }
      } on Exception {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signOut();

        return const Right(true);
      } on Exception {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NoConnectionFailure());
    }
  }
}
