import 'package:fpdart/fpdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lokalio/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthCredential extends Mock implements AuthCredential {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late AuthRepositoryImpl repository;

  late MockRemoteDataSource remoteDataSource;
  late MockAuthCredential mockAuthCredential;
  late MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    mockAuthCredential = MockAuthCredential();
    networkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  const tEmail = 'test';
  const tPassword = 'test';

  void setUpFunctions() {
    when(() => remoteDataSource.signIn(credential: mockAuthCredential))
        .thenAnswer((_) async => true);
    when(() => remoteDataSource.signUp(email: tEmail, password: tPassword))
        .thenAnswer((_) async => true);
    when(() => remoteDataSource.signOut()).thenAnswer((_) async => true);
  }

  test('should check if the device is online', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    setUpFunctions();

    await repository.signIn(credential: mockAuthCredential);

    verify(() => networkInfo.isConnected);
  });

  group('device is online', () {
    setUp(() {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('should return null when SignIn is successful', () async {
      when(() => remoteDataSource.signIn(credential: mockAuthCredential))
          .thenAnswer((_) async {});

      final result = await repository.signIn(credential: mockAuthCredential);

      expect(result, const Right(null));
    });

    test('should return null when SignInAnonymously is successful', () async {
      when(() => remoteDataSource.signInAnonymously())
          .thenAnswer((_) async => {});

      final result = await repository.signInAnonymously();

      expect(result, const Right(null));
    });

    test('should return null when SignUp is successful', () async {
      when(() => remoteDataSource.signUp(email: tEmail, password: tPassword))
          .thenAnswer((_) async => {});

      final result = await repository.signUp(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Right(null));
    });

    test('should return null when SignOut is successful', () async {
      when(() => remoteDataSource.signOut()).thenAnswer((_) async => true);

      final result = await repository.signOut();

      expect(result, const Right(null));
    });

    test('should return ServerFailure when SignIn is unsuccessful', () async {
      when(() => remoteDataSource.signIn(credential: mockAuthCredential))
          .thenThrow(ServerException());

      final result = await repository.signIn(credential: mockAuthCredential);

      expect(result, const Left(ServerFailure()));
    });

    test('should return ServerFailure when SignInAnonymously is unsuccessful',
        () async {
      when(() => remoteDataSource.signInAnonymously())
          .thenThrow(ServerException());

      final result = await repository.signInAnonymously();

      expect(result, const Left(ServerFailure()));
    });

    test('should return ServerFailure when SignUp is unsuccessful', () async {
      when(() => remoteDataSource.signUp(email: tEmail, password: tPassword))
          .thenThrow(ServerException());

      final result = await repository.signUp(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Left(ServerFailure()));
    });

    test('should return ServerFailure when SignOut is unsuccessful', () async {
      when(() => remoteDataSource.signOut()).thenThrow(ServerException());

      final result = await repository.signOut();

      expect(result, const Left(ServerFailure()));
    });

    test('should return FirebaseFailure when SignIn is unsuccessful', () async {
      when(() => remoteDataSource.signIn(credential: mockAuthCredential))
          .thenThrow(FirebaseException(plugin: '', code: 'user-not-found'));

      final result = await repository.signIn(credential: mockAuthCredential);

      expect(result, const Left(FirebaseFailure(message: 'user-not-found')));
    });

    test('should return FirebaseFailure when SignInAnonymously is unsuccessful',
        () async {
      when(() => remoteDataSource.signInAnonymously())
          .thenThrow(FirebaseException(plugin: '', code: 'user-not-found'));

      final result = await repository.signInAnonymously();

      expect(result, const Left(FirebaseFailure(message: 'user-not-found')));
    });

    test('should return FirebaseFailure when SignUp is unsuccessful', () async {
      when(() => remoteDataSource.signUp(email: tEmail, password: tPassword))
          .thenThrow(FirebaseException(plugin: '', code: 'user-not-found'));

      final result = await repository.signUp(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Left(FirebaseFailure(message: 'user-not-found')));
    });

    test('should return FirebaseFailure when SignOut is unsuccessful',
        () async {
      when(() => remoteDataSource.signOut())
          .thenThrow(FirebaseException(plugin: '', code: 'user-not-found'));

      final result = await repository.signOut();

      expect(result, const Left(FirebaseFailure(message: 'user-not-found')));
    });
  });

  group('device is offline', () {
    setUp(() {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
    });

    test(
        'should return NoConnectionFailure when the device is offline for SignIn',
        () async {
      final result = await repository.signIn(credential: mockAuthCredential);

      expect(result, const Left(NoConnectionFailure()));
    });

    test(
        'should return NoConnectionFailure when the device is offline for SignInAnonymously',
        () async {
      final result = await repository.signInAnonymously();

      expect(result, const Left(NoConnectionFailure()));
    });

    test(
        'should return NoConnectionFailure when the device is offline for SignUp',
        () async {
      final result = await repository.signUp(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Left(NoConnectionFailure()));
    });

    test(
        'should return NoConnectionFailure when the device is offline for SignOut',
        () async {
      final result = await repository.signOut();

      expect(result, const Left(NoConnectionFailure()));
    });
  });
}
