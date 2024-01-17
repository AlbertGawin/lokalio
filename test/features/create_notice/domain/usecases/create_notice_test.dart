import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/create_notice/domain/repositories/create_notice_repository.dart';
import 'package:lokalio/features/create_notice/domain/usecases/create_notice.dart';
import 'package:lokalio/features/read_notice/data/models/notice_details.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockCreateNoticeRepository extends Mock
    implements CreateNoticeRepository {}

class MockNoticeDetails extends Mock implements NoticeDetails {}

void main() {
  late MockCreateNoticeRepository mockCreateNoticeRepository;
  late CreateNotice createNotice;

  setUp(() {
    mockCreateNoticeRepository = MockCreateNoticeRepository();
    createNotice = CreateNotice(repository: mockCreateNoticeRepository);
  });

  setUpAll(() {
    registerFallbackValue(NoticeDetailsModel.fromJson(
      json: json.decode(fixture(name: 'notice_details.json')),
    ));
  });

  final tNoticeDetails = NoticeDetailsModel.fromJson(
    json: json.decode(fixture(name: 'notice_details.json')),
  );

  test('should get bool from the repository', () async {
    when(() => mockCreateNoticeRepository.createNotice(
            noticeDetails: any(named: 'noticeDetails')))
        .thenAnswer((_) async => const Right(null));

    final result = await createNotice(Params(noticeDetails: tNoticeDetails));

    expect(result, const Right(true));
    verify(() =>
        mockCreateNoticeRepository.createNotice(noticeDetails: tNoticeDetails));
    verifyNoMoreInteractions(mockCreateNoticeRepository);
  });
}
