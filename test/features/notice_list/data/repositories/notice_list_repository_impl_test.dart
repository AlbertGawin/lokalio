import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/notice_list/data/datasources/notice_list_remote_data_source.dart';
import 'package:lokalio/features/notice_list/data/models/notice.dart';
import 'package:lokalio/features/notice_list/data/repositories/notice_list_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock implements NoticeListRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NoticeListRepositoryImpl repository;

  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = NoticeListRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
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
        expect(result, equals(Right(tNoticeModelList)));
      });

      test(
          'should return ServerFailure when the call to remote data source is unsuccessful',
          () async {
        when(() => mockRemoteDataSource.getAllNotices())
            .thenThrow(ServerException());

        final result = await repository.getAllNotices();

        verify(() => mockRemoteDataSource.getAllNotices());
        expect(result, equals(const Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return ServerFailure when the call to remote data source is unsuccessful',
          () async {
        when(() => mockRemoteDataSource.getAllNotices())
            .thenThrow(ServerException());

        final result = await repository.getAllNotices();

        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(const Left(ServerFailure())));
      });
    });
  });

  group('getMyNotices', () {
    final tNoticeModelList = List<NoticeModel>.from(json
            .decode(fixture(name: 'notice_list.json'))
            .map<NoticeModel>((e) => NoticeModel.fromJson(json: e)))
        .where((element) => element.userId == '1')
        .toList();

    void setUpFunctions() {
      when(() => mockRemoteDataSource.getMyNotices())
          .thenAnswer((_) async => tNoticeModelList);
    }

    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      setUpFunctions();

      await repository.getMyNotices();

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

        final result = await repository.getMyNotices();

        verify(() => mockRemoteDataSource.getMyNotices());
        expect(result, equals(Right(tNoticeModelList)));
      });

      test(
          'should return ServerFailure when the call to remote data source is unsuccessful',
          () async {
        when(() => mockRemoteDataSource.getMyNotices())
            .thenThrow(ServerException());

        final result = await repository.getMyNotices();

        verify(() => mockRemoteDataSource.getMyNotices());
        expect(result, equals(const Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return ServerFailure when the call to remote data source is unsuccessful',
          () async {
        when(() => mockRemoteDataSource.getMyNotices())
            .thenThrow(ServerException());

        final result = await repository.getMyNotices();

        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(const Left(ServerFailure())));
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

        expect(result, equals(Right(tNoticeModelList)));
      });

      test(
          'should return ServerFailure when the call to remote data source is unsuccessful',
          () async {
        when(() => mockRemoteDataSource.getUserNotices(userId: tUserId))
            .thenThrow(ServerException());

        final result = await repository.getUserNotices(userId: tUserId);

        verify(() => mockRemoteDataSource.getUserNotices(userId: tUserId));

        expect(result, equals(const Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return ServerFailure when the call to remote data source is unsuccessful',
          () async {
        when(() => mockRemoteDataSource.getUserNotices(userId: tUserId))
            .thenThrow(ServerException());

        final result = await repository.getUserNotices(userId: tUserId);

        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(const Left(ServerFailure())));
      });
    });
  });
}
