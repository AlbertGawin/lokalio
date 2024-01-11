import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/enums/notice_category.dart';
import 'package:lokalio/features/notice_crud/domain/repositories/create_notice_repository.dart';
import 'package:lokalio/features/notice_crud/domain/entities/notice_details.dart';
import 'package:lokalio/features/notice_crud/domain/usecases/read_notice.dart';
import 'package:mocktail/mocktail.dart';

class MockNoticeCRUDRepository extends Mock implements NoticeCRUDRepository {}

void main() {
  late MockNoticeCRUDRepository repository;
  late ReadNotice usecase;

  setUp(() {
    repository = MockNoticeCRUDRepository();
    usecase = ReadNotice(repository: repository);
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
    when(() => repository.readNotice(noticeId: any(named: 'noticeId')))
        .thenAnswer((_) async => Right(tNoticeDetails));

    final result = await usecase(const Params(noticeId: tNoticeId));

    expect(result, Right(tNoticeDetails));
    verify(() => repository.readNotice(noticeId: tNoticeId));
    verifyNoMoreInteractions(repository);
  });
}
