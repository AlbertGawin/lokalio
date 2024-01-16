import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/read_notice/data/datasources/read_notice_local_data_source.dart';
import 'package:lokalio/features/read_notice/data/datasources/read_notice_remote_data_source.dart';
import 'package:lokalio/features/read_notice/data/models/notice_details.dart';
import 'package:lokalio/features/read_notice/data/repositories/read_notice_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock implements ReadNoticeRemoteDataSource {}

class MockLocalDataSource extends Mock implements ReadNoticeLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ReadNoticeRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = ReadNoticeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tNoticeId = '1';
  final tNoticeDetails = NoticeDetailsModel.fromJson(
    json: json.decode(fixture(name: 'notice_details.json')),
  );

  void setUpFunctions() {
    when(() => mockRemoteDataSource.readNotice(noticeId: tNoticeId))
        .thenAnswer((_) async => tNoticeDetails);
    when(() => mockLocalDataSource.cacheNotice(noticeDetails: tNoticeDetails))
        .thenAnswer((_) async => {});
  }

  test('should check if the device is online', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    setUpFunctions();

    await repository.readNotice(noticeId: tNoticeId);

    verify(() => mockNetworkInfo.isConnected);
  });

  group('device is online', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      setUpFunctions();

      final result = await repository.readNotice(noticeId: tNoticeId);

      verify(() => mockRemoteDataSource.readNotice(noticeId: tNoticeId));
      verify(
          () => mockLocalDataSource.cacheNotice(noticeDetails: tNoticeDetails));
      expect(result, equals(Right(tNoticeDetails)));
    });

    test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
      setUpFunctions();

      await repository.readNotice(noticeId: tNoticeId);

      verify(() => mockRemoteDataSource.readNotice(noticeId: tNoticeId));
      verify(
          () => mockLocalDataSource.cacheNotice(noticeDetails: tNoticeDetails));
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      when(() => mockRemoteDataSource.readNotice(noticeId: tNoticeId))
          .thenThrow(ServerException());

      final result = await repository.readNotice(noticeId: tNoticeId);

      verify(() => mockRemoteDataSource.readNotice(noticeId: tNoticeId));
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, equals(const Left(ServerFailure())));
    });
  });

  group('device is offline', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test(
        'should return last locally cached data when the cached data is present',
        () async {
      when(() => mockLocalDataSource.readCachedNotice(noticeId: tNoticeId))
          .thenAnswer((_) async => tNoticeDetails);

      final result = await repository.readNotice(noticeId: tNoticeId);

      verifyZeroInteractions(mockRemoteDataSource);
      verify(() => mockLocalDataSource.readCachedNotice(noticeId: tNoticeId));
      expect(result, equals(Right(tNoticeDetails)));
    });

    test('should return CacheFailure when there is no cached data present',
        () async {
      when(() => mockLocalDataSource.readCachedNotice(noticeId: tNoticeId))
          .thenThrow(CacheException());

      final result = await repository.readNotice(noticeId: tNoticeId);

      verifyZeroInteractions(mockRemoteDataSource);
      verify(() => mockLocalDataSource.readCachedNotice(noticeId: tNoticeId));
      expect(result, equals(const Left(CacheFailure())));
    });
  });
}
