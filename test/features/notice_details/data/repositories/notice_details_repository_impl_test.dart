import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/notice_details/data/datasources/notice_details_local_data_source.dart';
import 'package:lokalio/features/notice_details/data/datasources/notice_details_remote_data_source.dart';
import 'package:lokalio/features/notice_details/data/models/notice_details.dart';
import 'package:lokalio/features/notice_details/data/repositories/notice_details_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock
    implements NoticeDetailsRemoteDataSource {}

class MockLocalDataSource extends Mock
    implements NoticeDetailsLocalDataSourceImpl {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NoticeDetailsRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = NoticeDetailsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getNoticeDetails', () {
    const tId = '1';
    final tNoticeDetails = NoticeDetailsModel.fromJson(
      json: json.decode(fixture(name: 'notice_details.json')),
    );

    void setUpFunctions() {
      when(() => mockRemoteDataSource.getNoticeDetails(id: tId))
          .thenAnswer((_) async => tNoticeDetails);
      when(() => mockLocalDataSource.cacheNoticeDetails(
          noticeDetails: tNoticeDetails)).thenAnswer((_) async => {});
    }

    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      setUpFunctions();

      await repository.getNoticeDetails(id: tId);

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

        final result = await repository.getNoticeDetails(id: tId);

        verify(() => mockRemoteDataSource.getNoticeDetails(id: tId));
        verify(() => mockLocalDataSource.cacheNoticeDetails(
            noticeDetails: tNoticeDetails));
        expect(result, equals(Right(tNoticeDetails)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        setUpFunctions();

        await repository.getNoticeDetails(id: tId);

        verify(() => mockRemoteDataSource.getNoticeDetails(id: tId));
        verify(() => mockLocalDataSource.cacheNoticeDetails(
            noticeDetails: tNoticeDetails));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(() => mockRemoteDataSource.getNoticeDetails(id: tId))
            .thenThrow(ServerException());

        final result = await repository.getNoticeDetails(id: tId);

        verify(() => mockRemoteDataSource.getNoticeDetails(id: tId));
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
        when(() => mockLocalDataSource.getCachedNoticeDetails(id: tId))
            .thenAnswer((_) async => tNoticeDetails);

        final result = await repository.getNoticeDetails(id: tId);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getCachedNoticeDetails(id: tId));
        expect(result, equals(Right(tNoticeDetails)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(() => mockLocalDataSource.getCachedNoticeDetails(id: tId))
            .thenThrow(CacheException());

        final result = await repository.getNoticeDetails(id: tId);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getCachedNoticeDetails(id: tId));
        expect(result, equals(const Left(CacheFailure())));
      });
    });
  });
}
