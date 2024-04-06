import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/create_notice/domain/usecases/create_notice.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/read_notice/data/models/notice_details.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockCreateNotice extends Mock implements CreateNotice {}

void main() {
  late CreateNoticeBloc bloc;
  late MockCreateNotice mockCreateNotice;

  setUp(() {
    mockCreateNotice = MockCreateNotice();

    bloc = CreateNoticeBloc(createNotice: mockCreateNotice);
  });

  final tNoticeDetails = NoticeDetailsModel.fromJson(
    json: json.decode(fixture(name: 'notice_details.json')),
  );

  setUpAll(() {
    registerFallbackValue(Params(noticeDetails: tNoticeDetails));
    registerFallbackValue(NoParams());
  });

  test('initialState should be CreateNoticeInitial', () {
    expect(bloc.state, equals(CreateNoticeInitial()));
  });

  group('CreateNotice', () {
    void setUpMockCreateNoticeSuccess() {
      when(() => mockCreateNotice(any()))
          .thenAnswer((_) async => const Right(null));
    }

    test('should get data from the CreateNotice use case', () async {
      setUpMockCreateNoticeSuccess();

      bloc.add(CreateNoticeDetailsEvent(noticeDetails: tNoticeDetails));
      await untilCalled(() => mockCreateNotice(any()));

      verify(() => mockCreateNotice(Params(noticeDetails: tNoticeDetails)));
    });

    test(
        'should emit [Loading, Done] when data is gotten successfully from the use case',
        () async {
      setUpMockCreateNoticeSuccess();

      final expected = [Loading(), Done()];

      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(CreateNoticeDetailsEvent(noticeDetails: tNoticeDetails));
    });

    test(
        'should emit [Loading, Error] when getting data fails from the use case',
        () async {
      when(() => mockCreateNotice(any()))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final expected = [
        Loading(),
        Error(message: const ServerFailure().message),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(CreateNoticeDetailsEvent(noticeDetails: tNoticeDetails));
    });
  });
}
