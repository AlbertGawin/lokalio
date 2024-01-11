import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/notice_crud/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/domain/repositories/notice_list_repository.dart';
import 'package:lokalio/features/notice_list/domain/usecases/get_all_notices.dart';
import 'package:mocktail/mocktail.dart';

class MockNoticeListRepository extends Mock implements NoticeListRepository {}

void main() {
  late MockNoticeListRepository mockNoticeListRepository;
  late GetAllNotices getAllNotices;

  setUp(() {
    mockNoticeListRepository = MockNoticeListRepository();
    getAllNotices = GetAllNotices(
      noticeListRepository: mockNoticeListRepository,
    );
  });

  const List<Notice> tNoticeList = [];

  test('should get List<Notice> from the repository', () async {
    when(() => mockNoticeListRepository.getAllNotices()).thenAnswer(
      (_) async => const Right(tNoticeList),
    );

    final result = await getAllNotices(NoParams());

    expect(result, const Right(tNoticeList));
    verify(() => mockNoticeListRepository.getAllNotices());
    verifyNoMoreInteractions(mockNoticeListRepository);
  });
}
