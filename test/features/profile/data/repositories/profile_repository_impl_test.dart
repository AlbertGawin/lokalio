import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:lokalio/features/profile/data/models/profile.dart';
import 'package:lokalio/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock implements ProfileRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProfileRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;

  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();

    repository = ProfileRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tuserId = '1';
  final tProfile = ProfileModel.fromJson(
    json: json.decode(fixture(name: 'profile.json')),
  );

  void setUpFunctions() {
    when(() => mockRemoteDataSource.readProfile(userId: tuserId))
        .thenAnswer((_) async => tProfile);
  }

  test('should check if the device is online', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    setUpFunctions();

    await repository.readProfile(userId: tuserId);

    verify(() => mockNetworkInfo.isConnected);
  });

  group('device is online', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      setUpFunctions();
    });

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      final result = await repository.readProfile(userId: tuserId);

      verify(() => mockRemoteDataSource.readProfile(userId: tuserId));
      expect(result, equals(Right(tProfile)));
    });

    test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
      when(() => mockRemoteDataSource.readProfile(userId: tuserId))
          .thenThrow(ServerException());

      final result = await repository.readProfile(userId: tuserId);

      verify(() => mockRemoteDataSource.readProfile(userId: tuserId));
      expect(result, equals(const Left(ServerFailure())));
    });

    test('should return NoDataFailure when the profile is not found', () async {
      when(() => mockRemoteDataSource.readProfile(userId: tuserId))
          .thenThrow(NoDataException());

      final result = await repository.readProfile(userId: tuserId);

      verify(() => mockRemoteDataSource.readProfile(userId: tuserId));
      expect(result, equals(const Left(NoDataFailure())));
    });
  });

  group('device is offline', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('should return NoConnectionFailure when the device is offline',
        () async {
      final result = await repository.readProfile(userId: tuserId);

      verifyNever(() => mockRemoteDataSource.readProfile(userId: tuserId));
      expect(result, equals(const Left(NoConnectionFailure())));
    });
  });
}
