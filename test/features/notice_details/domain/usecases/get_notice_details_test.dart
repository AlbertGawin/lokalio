import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/enums/notice_category.dart';
import 'package:lokalio/features/notice_crud/domain/entities/notice_details.dart';
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

  test('should get NoticeDetails from the repository', () async {
    when(() => mockNoticeDetailsRepository.getNoticeDetails(
            noticeId: any(named: 'noticeId')))
        .thenAnswer((_) async => Right(tNoticeDetails));

    final result = await getNoticeDetails(const Params(noticeId: tNoticeId));

    expect(result, Right(tNoticeDetails));
    verify(() =>
        mockNoticeDetailsRepository.getNoticeDetails(noticeId: tNoticeId));
    verifyNoMoreInteractions(mockNoticeDetailsRepository);
  });
}
