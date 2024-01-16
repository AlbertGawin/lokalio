import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';
import 'package:lokalio/features/read_notice/domain/repositories/read_notice_repository.dart';
import 'package:lokalio/features/read_notice/domain/usecases/get_notice_details.dart';
import 'package:mocktail/mocktail.dart';

class MockReadNoticeRepository extends Mock implements ReadNoticeRepository {}

void main() {
  late MockReadNoticeRepository mockNoticeDetailsRepository;
  late GetNoticeDetails getNoticeDetails;

  setUp(() {
    mockNoticeDetailsRepository = MockReadNoticeRepository();
    getNoticeDetails =
        GetNoticeDetails(repository: mockNoticeDetailsRepository);
  });

  const tNoticeId = '1';
  final NoticeDetails tNoticeDetails = NoticeDetails(
    id: '1',
    userId: '1',
    title: 'Test',
    category: 1,
    amountInCash: 0,
    dateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 1))),
    description: 'Test',
    location: 'Test',
    amountInKind: 0,
  );

  test('should get NoticeDetails from the repository', () async {
    when(() => mockNoticeDetailsRepository.readNotice(
            noticeId: any(named: 'noticeId')))
        .thenAnswer((_) async => Right(tNoticeDetails));

    final result = await getNoticeDetails(const Params(noticeId: tNoticeId));

    expect(result, Right(tNoticeDetails));
    verify(() => mockNoticeDetailsRepository.readNotice(noticeId: tNoticeId));
    verifyNoMoreInteractions(mockNoticeDetailsRepository);
  });
}
