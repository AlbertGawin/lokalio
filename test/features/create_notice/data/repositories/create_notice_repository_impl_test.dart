import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/create_notice/data/datasources/create_notice_remote_data_source.dart';
import 'package:lokalio/features/create_notice/data/repositories/create_notice_repository_impl.dart';
import 'package:lokalio/features/notice/data/models/notice_details.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock
    implements CreateNoticeRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late CreateNoticeRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = CreateNoticeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tNoticeDetails = NoticeDetailsModel.fromJson(
    json: json.decode(fixture(name: 'notice_details.json')),
  );

  void setUpFunctions() {
    when(() => mockRemoteDataSource.createNotice(noticeDetails: tNoticeDetails))
        .thenAnswer((_) async => true);
  }

  test('should check if the device is online', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    setUpFunctions();

    await repository.createNotice(noticeDetails: tNoticeDetails);

    verify(() => mockNetworkInfo.isConnected);
  });

  group('device is online', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      setUpFunctions();
    });

    test('should return true when the remote data source is successful',
        () async {
      final result =
          await repository.createNotice(noticeDetails: tNoticeDetails);

      verify(() =>
          mockRemoteDataSource.createNotice(noticeDetails: tNoticeDetails));
      expect(result, equals(const Right(null)));
    });

    test(
        'should return ServerFailure when the remote data source is unsuccessful',
        () async {
      when(() =>
              mockRemoteDataSource.createNotice(noticeDetails: tNoticeDetails))
          .thenThrow(ServerException());

      final result =
          await repository.createNotice(noticeDetails: tNoticeDetails);

      verify(() =>
          mockRemoteDataSource.createNotice(noticeDetails: tNoticeDetails));
      expect(result, equals(const Left(ServerFailure())));
    });
  });

  group('device is offline', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      setUpFunctions();
    });

    test('should return NoConnectionFailure when the device is offline',
        () async {
      final result =
          await repository.createNotice(noticeDetails: tNoticeDetails);

      verifyZeroInteractions(mockRemoteDataSource);
      expect(result, equals(const Left(NoConnectionFailure())));
    });
  });
}
