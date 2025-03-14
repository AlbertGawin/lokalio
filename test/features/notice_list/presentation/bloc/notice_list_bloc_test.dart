import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
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

  final List<Notice> tNoticesList = [];

  group('GetAllNotices', () {
    void setUpMockGetAllNoticesSuccess() {
      when(() => mockGetAllNotices(any()))
          .thenAnswer((_) async => Right(tNoticesList));
    }

    test('should get data from the GetAllNotices usecase', () async {
      setUpMockGetAllNoticesSuccess();

      bloc.add(const GetAllNoticesEvent());
      await untilCalled(() => mockGetAllNotices(any()));

      verify(() => mockGetAllNotices(NoParams()));
    });

    test(
        'should emit [Loading, Done] when data is gotten successfully from the usecase',
        () async {
      setUpMockGetAllNoticesSuccess();

      final expected = [Loading(), Done(noticeList: tNoticesList)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetAllNoticesEvent());
    });

    test(
        'should emit [Loading, Error] when getting data fails from the usecase',
        () async {
      when(() => mockGetAllNotices(any()))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final expected = [
        Loading(),
        Error(message: failureMessages[FailureType.serverFailure]!)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetAllNoticesEvent());
    });
  });

  group('GetUserNotices', () {
    const tuserId = '1';

    void setUpMockGetUserNoticesSuccess() {
      when(() => mockGetUserNotices(any()))
          .thenAnswer((_) async => Right(tNoticesList));
    }

    test('should get data from the GetUserNotices usecase', () async {
      setUpMockGetUserNoticesSuccess();

      bloc.add(const GetUserNoticesEvent(userId: tuserId));
      await untilCalled(() => mockGetUserNotices(any()));

      verify(() => mockGetUserNotices(const Params(userId: tuserId)));
    });

    test(
        'should emit [Loading, Done] when data is gotten successfully from the usecase',
        () async {
      setUpMockGetUserNoticesSuccess();

      final expected = [Loading(), Done(noticeList: tNoticesList)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetUserNoticesEvent(userId: tuserId));
    });

    test(
        'should emit [Loading, Error] when getting data fails from the usecase',
        () async {
      when(() => mockGetUserNotices(any()))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final expected = [
        Loading(),
        Error(message: failureMessages[FailureType.serverFailure]!)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetUserNoticesEvent(userId: tuserId));
    });
  });
}
