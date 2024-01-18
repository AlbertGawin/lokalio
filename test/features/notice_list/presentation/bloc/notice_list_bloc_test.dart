import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/domain/usecases/get_all_notices.dart';
import 'package:lokalio/features/notice_list/domain/usecases/get_user_notices.dart';
import 'package:lokalio/features/notice_list/presentation/bloc/notice_list_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllNotices extends Mock implements GetAllNotices {}

class MockGetUserNotices extends Mock implements GetUserNotices {}

void main() {
  late NoticeListBloc bloc;
  late MockGetAllNotices mockGetAllNotices;
  late MockGetUserNotices mockGetUserNotices;

  setUp(() {
    mockGetAllNotices = MockGetAllNotices();
    mockGetUserNotices = MockGetUserNotices();

    bloc = NoticeListBloc(
      getAllNotices: mockGetAllNotices,
      getUserNotices: mockGetUserNotices,
    );
  });

  setUpAll(() {
    registerFallbackValue(const Params(userId: '1'));
    registerFallbackValue(NoParams());
  });

  test('initialState should be NoticeListInitial', () {
    expect(bloc.state, equals(NoticeListInitial()));
  });

  final tNoticesList = [
    Notice(
      id: '1',
      title: 'title',
      userId: '1',
      category: 1,
      cashAmount: 10,
      location: Position(
        longitude: 50.5,
        latitude: 50.5,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 1.0,
        altitudeAccuracy: 1.0,
        heading: 1.0,
        headingAccuracy: 1.0,
        speed: 1.0,
        speedAccuracy: 1.0,
      ),
      dateTimeRange: DateTimeRange(
        start: DateTime(2021, 1, 1),
        end: DateTime(2021, 1, 2),
      ),
      thumbnailUrl: '',
    )
  ];

  group('GetAllNotices', () {
    void setUpMockGetAllNoticesSuccess() {
      when(() => mockGetAllNotices(any()))
          .thenAnswer((_) async => Right(tNoticesList));
    }

    test('should get data from the GetAllNotices use case', () async {
      setUpMockGetAllNoticesSuccess();

      bloc.add(GetAllNoticesEvent());
      await untilCalled(() => mockGetAllNotices(any()));

      verify(() => mockGetAllNotices(NoParams()));
    });

    test(
        'should emit [Loading, Done] when data is gotten successfully from the use case',
        () async {
      setUpMockGetAllNoticesSuccess();

      final expected = [Loading(), Done(noticeList: tNoticesList)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(GetAllNoticesEvent());
    });

    test(
        'should emit [Loading, Error] when getting data fails from the use case',
        () async {
      when(() => mockGetAllNotices(any()))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final expected = [
        Loading(),
        Error(message: failureMessages[FailureType.serverFailure]!)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(GetAllNoticesEvent());
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails from the use case',
        () async {
      when(() => mockGetAllNotices(any()))
          .thenAnswer((_) async => const Left(CacheFailure()));

      final expected = [
        Loading(),
        Error(message: failureMessages[FailureType.cacheFailure]!)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(GetAllNoticesEvent());
    });
  });

  group('GetUserNotices', () {
    const tUserId = '1';

    void setUpMockGetUserNoticesSuccess() {
      when(() => mockGetUserNotices(any()))
          .thenAnswer((_) async => Right(tNoticesList));
    }

    test('should get data from the GetUserNotices use case', () async {
      setUpMockGetUserNoticesSuccess();

      bloc.add(const GetUserNoticesEvent(userId: tUserId));
      await untilCalled(() => mockGetUserNotices(any()));

      verify(() => mockGetUserNotices(const Params(userId: tUserId)));
    });

    test(
        'should emit [Loading, Done] when data is gotten successfully from the use case',
        () async {
      setUpMockGetUserNoticesSuccess();

      final expected = [Loading(), Done(noticeList: tNoticesList)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetUserNoticesEvent(userId: tUserId));
    });

    test(
        'should emit [Loading, Error] when getting data fails from the use case',
        () async {
      when(() => mockGetUserNotices(any()))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final expected = [
        Loading(),
        Error(message: failureMessages[FailureType.serverFailure]!)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetUserNoticesEvent(userId: tUserId));
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails from the use case',
        () async {
      when(() => mockGetUserNotices(any()))
          .thenAnswer((_) async => const Left(CacheFailure()));

      final expected = [
        Loading(),
        Error(message: failureMessages[FailureType.cacheFailure]!)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetUserNoticesEvent(userId: tUserId));
    });
  });
}
