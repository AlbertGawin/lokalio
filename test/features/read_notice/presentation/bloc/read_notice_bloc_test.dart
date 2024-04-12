import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/notice/data/models/notice_details.dart';
import 'package:lokalio/features/notice/domain/usecases/read_notice.dart';
import 'package:lokalio/features/notice/presentation/bloc/notice_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockReadNotice extends Mock implements ReadNotice {}

void main() {
  late ReadNoticeBloc bloc;
  late MockReadNotice mockReadNotice;

  setUp(() {
    mockReadNotice = MockReadNotice();

    bloc = ReadNoticeBloc(readNotice: mockReadNotice);
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
    final tNoticeDetails = NoticeDetailsModel.fromJson(
      json: json.decode(fixture(name: 'notice_details.json')),
    );

    void setUpMockGetNoticeDetailsSuccess() {
      when(() => mockReadNotice(any()))
          .thenAnswer((_) async => Right(tNoticeDetails));
    }

    test('should get data from the GetNoticeDetails use case', () async {
      setUpMockGetNoticeDetailsSuccess();

      bloc.add(const ReadNoticeDetailsEvent(noticeId: tId));
      await untilCalled(() => mockReadNotice(any()));

      verify(() => mockReadNotice(const Params(noticeId: tId)));
    });

    test(
        'should emit [Loading, Done] when data is gotten successfully from the use case',
        () async {
      setUpMockGetNoticeDetailsSuccess();

      final expected = [Loading(), Done(noticeDetails: tNoticeDetails)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const ReadNoticeDetailsEvent(noticeId: tId));
    });

    test(
        'should emit [Loading, Error] when getting data fails from the use case',
        () async {
      when(() => mockReadNotice(any()))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final expected = [
        Loading(),
        Error(message: failureMessages[FailureType.serverFailure]!),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const ReadNoticeDetailsEvent(noticeId: tId));
    });
  });
}
