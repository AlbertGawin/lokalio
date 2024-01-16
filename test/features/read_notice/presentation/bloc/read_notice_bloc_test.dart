import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/enums/notice_category.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';
import 'package:lokalio/features/read_notice/domain/usecases/get_notice_details.dart';
import 'package:lokalio/features/read_notice/presentation/bloc/read_notice_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNoticeDetails extends Mock implements GetNoticeDetails {}

void main() {
  late ReadNoticeBloc bloc;
  late MockGetNoticeDetails mockGetNoticeDetails;

  setUp(() {
    mockGetNoticeDetails = MockGetNoticeDetails();

    bloc = ReadNoticeBloc(getNoticeDetails: mockGetNoticeDetails);
  });

  const tId = '1';
  setUpAll(() {
    registerFallbackValue(const Params(noticeId: tId));
    registerFallbackValue(NoParams());
  });

  test('initialState should be NoticeListInitial', () {
    expect(bloc.state, equals(ReadNoticeInitial()));
  });

  group('GetNoticeDetails', () {
    final NoticeDetails tNoticeDetails = NoticeDetails(
      id: '1',
      userId: '1',
      title: 'Test',
      category: NoticeCategory.HELP.index,
      amountInCash: 0,
      dateRange: DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 1))),
      description: 'Test',
      location: 'Test',
      amountInKind: 0,
    );

    void setUpMockGetNoticeDetailsSuccess() {
      when(() => mockGetNoticeDetails(any()))
          .thenAnswer((_) async => Right(tNoticeDetails));
    }

    test('should get data from the GetNoticeDetails use case', () async {
      setUpMockGetNoticeDetailsSuccess();

      bloc.add(const GetNoticeDetailsEvent(noticeId: tId));
      await untilCalled(() => mockGetNoticeDetails(any()));

      verify(() => mockGetNoticeDetails(const Params(noticeId: tId)));
    });

    test(
        'should emit [Loading, Done] when data is gotten successfully from the use case',
        () async {
      setUpMockGetNoticeDetailsSuccess();

      final expected = [Loading(), Done(noticeDetails: tNoticeDetails)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetNoticeDetailsEvent(noticeId: tId));
    });

    test(
        'should emit [Loading, Error] when getting data fails from the use case',
        () async {
      when(() => mockGetNoticeDetails(any()))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final expected = [
        Loading(),
        Error(message: failureMessages[FailureType.serverFailure]!),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetNoticeDetailsEvent(noticeId: tId));
    });
  });
}
