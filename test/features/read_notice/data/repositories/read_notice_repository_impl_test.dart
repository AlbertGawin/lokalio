import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/notice/data/datasources/notice_remote_data_source.dart';
import 'package:lokalio/features/notice/data/models/notice_details.dart';
import 'package:lokalio/features/notice/data/repositories/notice_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock implements ReadNoticeRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ReadNoticeRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;

  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();

    repository = ReadNoticeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
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
      setUpFunctions();
    });

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      final result = await repository.readNotice(noticeId: tNoticeId);

      verify(() => mockRemoteDataSource.readNotice(noticeId: tNoticeId));

      expect(result, equals(Right(tNoticeDetails)));
    });

    test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
      when(() => mockRemoteDataSource.readNotice(noticeId: tNoticeId))
          .thenThrow(ServerException());

      final result = await repository.readNotice(noticeId: tNoticeId);

      verify(() => mockRemoteDataSource.readNotice(noticeId: tNoticeId));
      expect(result, equals(const Left(ServerFailure())));
    });

    test(
        'should return NoDataFailure when there is no data present in the remote data source',
        () async {
      when(() => mockRemoteDataSource.readNotice(noticeId: tNoticeId))
          .thenThrow(NoDataException());

      final result = await repository.readNotice(noticeId: tNoticeId);

      verify(() => mockRemoteDataSource.readNotice(noticeId: tNoticeId));
      expect(result, equals(const Left(NoDataFailure())));
    });
  });

  group('device is offline', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('should return NoConnectionFailure when the device is offline',
        () async {
      final result = await repository.readNotice(noticeId: tNoticeId);

      verifyZeroInteractions(mockRemoteDataSource);
      expect(result, equals(const Left(NoConnectionFailure())));
    });
  });
}
