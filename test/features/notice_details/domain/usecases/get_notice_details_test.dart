import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/notice_details/domain/entities/notice_details.dart';
import 'package:lokalio/features/notice_details/domain/repositories/notice_details_repository.dart';
import 'package:lokalio/features/notice_details/domain/usecases/get_notice_details.dart';
import 'package:mocktail/mocktail.dart';

class MockNoticeDetailsRepository extends Mock
    implements NoticeDetailsRepository {}

void main() {
  late MockNoticeDetailsRepository mockNoticeDetailsRepository;
  late GetNoticeDetails getNoticeDetails;

  setUp(() {
    mockNoticeDetailsRepository = MockNoticeDetailsRepository();
    getNoticeDetails =
        GetNoticeDetails(noticeDetailsRepository: mockNoticeDetailsRepository);
  });

  const tNoticeId = '1';
  const NoticeDetails tNoticeDetails = NoticeDetails(
    id: tNoticeId,
    title: 'title',
    description: 'description',
    userId: '1',
  );

  test('should get NoticeDetails from the repository', () async {
    when(() => mockNoticeDetailsRepository.getNoticeDetails(
            noticeId: any(named: 'noticeId')))
        .thenAnswer((_) async => const Right(tNoticeDetails));

    final result = await getNoticeDetails(const Params(noticeId: tNoticeId));

    expect(result, const Right(tNoticeDetails));
    verify(() =>
        mockNoticeDetailsRepository.getNoticeDetails(noticeId: tNoticeId));
    verifyNoMoreInteractions(mockNoticeDetailsRepository);
  });
}
