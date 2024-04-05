import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Future<Either<Failure, void>> signIn(
      {required AuthCredential credential}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signIn(credential: credential);

        return const Right(null);
      } on FirebaseException catch (e) {
        return Left(FirebaseFailure(message: e.code));
      } on Exception {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signInAnonymously() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signInAnonymously();

        return const Right(null);
      } on FirebaseException catch (e) {
        return Left(FirebaseFailure(message: e.code));
      } on Exception {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signUp(
      {required String email, required String password}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signUp(email: email, password: password);

        return const Right(null);
      } on FirebaseException catch (e) {
        return Left(FirebaseFailure(message: e.code));
      } on Exception {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signOut();

        return const Right(null);
      } on FirebaseException catch (e) {
        return Left(FirebaseFailure(message: e.code));
      } on Exception {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NoConnectionFailure());
    }
  }
}
