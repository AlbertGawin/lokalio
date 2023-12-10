import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/notice_list/data/datasources/notice_list_local_data_source.dart';
import 'package:lokalio/features/notice_list/data/datasources/notice_list_remote_data_source.dart';
import 'package:lokalio/features/notice_list/data/models/notice.dart';
import 'package:lokalio/features/notice_list/data/repositories/notice_list_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock implements NoticeListRemoteDataSource {}

class MockLocalDataSource extends Mock implements NoticeListLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NoticeListRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = NoticeListRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getAllNotices', () {
    final tNoticeModelList = List<NoticeModel>.from(json
            .decode(fixture(name: 'notice_list.json'))
            .map<NoticeModel>((e) => NoticeModel.fromJson(json: e)))
        .where((element) => element.userId != '1')
        .toList();

    void setUpFunctions() {
      when(() => mockRemoteDataSource.getAllNotices())
          .thenAnswer((_) async => tNoticeModelList);
      when(() =>
              mockLocalDataSource.cacheNoticeList(noticeList: tNoticeModelList))
          .thenAnswer((_) async => {});
    }

    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      setUpFunctions();

      await repository.getAllNotices();

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

        final result = await repository.getAllNotices();

        verify(() => mockRemoteDataSource.getAllNotices());
        verify(() =>
            mockLocalDataSource.cacheNoticeList(noticeList: tNoticeModelList));
        expect(result, equals(Right(tNoticeModelList)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        setUpFunctions();

        await repository.getAllNotices();

        verify(() => mockRemoteDataSource.getAllNotices());
        verify(() =>
            mockLocalDataSource.cacheNoticeList(noticeList: tNoticeModelList));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(() => mockRemoteDataSource.getAllNotices())
            .thenThrow(ServerException());

        final result = await repository.getAllNotices();

        verify(() => mockRemoteDataSource.getAllNotices());
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
        when(() => mockLocalDataSource.getAllCachedNotices())
            .thenAnswer((_) async => tNoticeModelList);

        final result = await repository.getAllNotices();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getAllCachedNotices());
        expect(result, equals(Right(tNoticeModelList)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(() => mockLocalDataSource.getAllCachedNotices())
            .thenThrow(CacheException());

        final result = await repository.getAllNotices();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getAllCachedNotices());
        expect(result, equals(const Left(CacheFailure())));
      });
    });
  });

  group('getUserNotices', () {
    const tUserId = '3';
    final tNoticeModelList = List<NoticeModel>.from(json
            .decode(fixture(name: 'notice_list.json'))
            .map<NoticeModel>((e) => NoticeModel.fromJson(json: e)))
        .where((element) => element.userId == '3')
        .toList();

    void setUpFunctions() {
      when(() => mockRemoteDataSource.getUserNotices(userId: tUserId))
          .thenAnswer((_) async => tNoticeModelList);
      when(() =>
              mockLocalDataSource.cacheNoticeList(noticeList: tNoticeModelList))
          .thenAnswer((_) async => {});
    }

    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      setUpFunctions();

      await repository.getUserNotices(userId: tUserId);

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

        final result = await repository.getUserNotices(userId: tUserId);

        verify(() => mockRemoteDataSource.getUserNotices(userId: tUserId));
        verify(() =>
            mockLocalDataSource.cacheNoticeList(noticeList: tNoticeModelList));
        expect(result, equals(Right(tNoticeModelList)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        setUpFunctions();

        await repository.getUserNotices(userId: tUserId);

        verify(() => mockRemoteDataSource.getUserNotices(userId: tUserId));
        verify(() =>
            mockLocalDataSource.cacheNoticeList(noticeList: tNoticeModelList));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(() => mockRemoteDataSource.getUserNotices(userId: tUserId))
            .thenThrow(ServerException());

        final result = await repository.getUserNotices(userId: tUserId);

        verify(() => mockRemoteDataSource.getUserNotices(userId: tUserId));
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
        when(() => mockLocalDataSource.getUserCachedNotices(userId: tUserId))
            .thenAnswer((_) async => tNoticeModelList);

        final result = await repository.getUserNotices(userId: tUserId);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getUserCachedNotices(userId: tUserId));
        expect(result, equals(Right(tNoticeModelList)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(() => mockLocalDataSource.getUserCachedNotices(userId: tUserId))
            .thenThrow(CacheException());

        final result = await repository.getUserNotices(userId: tUserId);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getUserCachedNotices(userId: tUserId));
        expect(result, equals(const Left(CacheFailure())));
      });
    });
  });
}
