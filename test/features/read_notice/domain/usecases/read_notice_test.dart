import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';
import 'package:lokalio/features/read_notice/domain/repositories/read_notice_repository.dart';
import 'package:lokalio/features/read_notice/domain/usecases/read_notice.dart';
import 'package:mocktail/mocktail.dart';

class MockReadNoticeRepository extends Mock implements ReadNoticeRepository {}

void main() {
  late MockReadNoticeRepository mockNoticeDetailsRepository;
  late ReadNotice readNotice;

  setUp(() {
    mockNoticeDetailsRepository = MockReadNoticeRepository();
    readNotice = ReadNotice(repository: mockNoticeDetailsRepository);
  });

  const tNoticeId = '1';
  final NoticeDetails tNoticeDetails = NoticeDetails(
    id: '1',
    userId: '1',
    title: 'Test',
    category: 1,
    moneyAmount: 0,
    location: const LatLng(0, 0),
    description: 'Test',
    peopleAmount: 0,
    imagesUrl: List.empty(),
    createdAt: Timestamp.now(),
  );

  test('should get NoticeDetails from the repository', () async {
    when(() => mockNoticeDetailsRepository.readNotice(
            noticeId: any(named: 'noticeId')))
        .thenAnswer((_) async => Right(tNoticeDetails));

    final result = await readNotice(const Params(noticeId: tNoticeId));

    expect(result, Right(tNoticeDetails));
    verify(() => mockNoticeDetailsRepository.readNotice(noticeId: tNoticeId));
    verifyNoMoreInteractions(mockNoticeDetailsRepository);
  });
}
