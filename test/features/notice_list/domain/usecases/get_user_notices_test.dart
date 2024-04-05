import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/domain/repositories/notice_list_repository.dart';
import 'package:lokalio/features/notice_list/domain/usecases/get_user_notices.dart';
import 'package:mocktail/mocktail.dart';

class MockNoticeListRepository extends Mock implements NoticeListRepository {}

void main() {
  late MockNoticeListRepository mockNoticeListRepository;
  late GetUserNotices usecase;

  setUp(() {
    mockNoticeListRepository = MockNoticeListRepository();
    usecase = GetUserNotices(noticeListRepository: mockNoticeListRepository);
  });

  const List<Notice> tNoticeList = [];
  const tuserId = '8ab7sdt';

  test('should get List<Notice> for the user from the repository', () async {
    when(() => mockNoticeListRepository.getUserNotices(
        userId: any(named: 'userId'))).thenAnswer(
      (_) async => const Right(tNoticeList),
    );

    final result = await usecase(const Params(userId: tuserId));

    expect(result, const Right(tNoticeList));
    verify(() => mockNoticeListRepository.getUserNotices(userId: tuserId));
    verifyNoMoreInteractions(mockNoticeListRepository);
  });
}
