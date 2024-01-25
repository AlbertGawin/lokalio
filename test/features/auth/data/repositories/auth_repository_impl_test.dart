import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lokalio/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late AuthRepositoryImpl repository;

  late MockRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  const tEmail = 'test';
  const tPassword = 'test';

  void setUpFunctions() {
    when(() => remoteDataSource.signIn(email: tEmail, password: tPassword))
        .thenAnswer((_) async => true);
    when(() => remoteDataSource.signUp(email: tEmail, password: tPassword))
        .thenAnswer((_) async => true);
    when(() => remoteDataSource.signOut()).thenAnswer((_) async => true);
  }

  test('should check if the device is online', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    setUpFunctions();

    await repository.signIn(email: tEmail, password: tPassword);

    verify(() => networkInfo.isConnected);
  });

  group('device is online', () {
    setUp(() {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('should return true when sign in is successful', () async {
      when(() => remoteDataSource.signIn(email: tEmail, password: tPassword))
          .thenAnswer((_) async => true);

      final result = await repository.signIn(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Right(true));
    });

    test('should return true when sign up is successful', () async {
      when(() => remoteDataSource.signUp(email: tEmail, password: tPassword))
          .thenAnswer((_) async => true);

      final result = await repository.signUp(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Right(true));
    });

    test('should return true when sign out is successful', () async {
      when(() => remoteDataSource.signOut()).thenAnswer((_) async => true);

      final result = await repository.signOut();

      expect(result, const Right(true));
    });

    test('should return ServerFailure when sign in is unsuccessful', () async {
      when(() => remoteDataSource.signIn(email: tEmail, password: tPassword))
          .thenThrow(ServerException());

      final result = await repository.signIn(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Left(ServerFailure()));
    });

    test('should return ServerFailure when sign up is unsuccessful', () async {
      when(() => remoteDataSource.signUp(email: tEmail, password: tPassword))
          .thenThrow(ServerException());

      final result = await repository.signUp(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Left(ServerFailure()));
    });

    test('should return ServerFailure when sign out is unsuccessful', () async {
      when(() => remoteDataSource.signOut()).thenThrow(ServerException());

      final result = await repository.signOut();

      expect(result, const Left(ServerFailure()));
    });

    test('should return FirebaseFailure when sign in is unsuccessful',
        () async {
      when(() => remoteDataSource.signIn(email: tEmail, password: tPassword))
          .thenThrow(FirebaseException(plugin: '', code: 'user-not-found'));

      final result = await repository.signIn(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Left(FirebaseFailure(message: 'user-not-found')));
    });

    test('should return ServerFailure when sign in throws an exception',
        () async {
      when(() => remoteDataSource.signIn(email: tEmail, password: tPassword))
          .thenThrow(Exception());

      final result = await repository.signIn(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Left(ServerFailure()));
    });
  });

  group('device is offline', () {
    setUp(() {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('should return ConnectionFailure when sign in is unsuccessful',
        () async {
      when(() => remoteDataSource.signIn(email: tEmail, password: tPassword))
          .thenThrow(NoConnectionException());

      final result = await repository.signIn(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Left(NoConnectionFailure()));
    });

    test('should return ConnectionFailure when sign up is unsuccessful',
        () async {
      when(() => remoteDataSource.signUp(email: tEmail, password: tPassword))
          .thenThrow(NoConnectionException());

      final result = await repository.signUp(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Left(NoConnectionFailure()));
    });

    test('should return ConnectionFailure when sign out is unsuccessful',
        () async {
      when(() => remoteDataSource.signOut()).thenThrow(NoConnectionException());

      final result = await repository.signOut();

      expect(result, const Left(NoConnectionFailure()));
    });
  });
}
