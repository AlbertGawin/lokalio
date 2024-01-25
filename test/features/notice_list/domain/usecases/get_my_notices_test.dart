import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/domain/repositories/notice_list_repository.dart';
import 'package:lokalio/features/notice_list/domain/usecases/get_my_notices.dart';
import 'package:mocktail/mocktail.dart';

class MockNoticeListRepository extends Mock implements NoticeListRepository {}

void main() {
  late MockNoticeListRepository mockNoticeListRepository;
  late GetMyNotices usecase;

  setUp(() {
    mockNoticeListRepository = MockNoticeListRepository();
    usecase = GetMyNotices(noticeListRepository: mockNoticeListRepository);
  });

  const List<Notice> tNoticeList = [];

  test('should get List<Notice> from the repository', () async {
    when(() => mockNoticeListRepository.getMyNotices()).thenAnswer(
      (_) async => const Right(tNoticeList),
    );

    final result = await usecase(NoParams());

    expect(result, const Right(tNoticeList));
    verify(() => mockNoticeListRepository.getMyNotices());
    verifyNoMoreInteractions(mockNoticeListRepository);
  });
}
