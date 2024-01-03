import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/notice_details/domain/entities/notice_details.dart';
import 'package:lokalio/features/notice_details/domain/usecases/get_notice_details.dart';
import 'package:lokalio/features/notice_details/presentation/bloc/notice_details_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNoticeDetails extends Mock implements GetNoticeDetails {}

void main() {
  late NoticeDetailsBloc bloc;
  late MockGetNoticeDetails mockGetNoticeDetails;

  setUp(() {
    mockGetNoticeDetails = MockGetNoticeDetails();

    bloc = NoticeDetailsBloc(getNoticeDetails: mockGetNoticeDetails);
  });

  const tId = '1';
  setUpAll(() {
    registerFallbackValue(const Params(noticeId: tId));
    registerFallbackValue(NoParams());
  });

  test('initialState should be NoticeListInitial', () {
    expect(bloc.state, equals(NoticeDetailsInitial()));
  });

  group('GetNoticeDetails', () {
    const tNoticeDetails = NoticeDetails(
      id: tId,
      title: 'title',
      description: 'description',
      userId: '1',
    );

    void setUpMockGetNoticeDetailsSuccess() {
      when(() => mockGetNoticeDetails(any()))
          .thenAnswer((_) async => const Right(tNoticeDetails));
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

      final expected = [Loading(), const Done(noticeDetails: tNoticeDetails)];
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
