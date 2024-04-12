import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/create_notice/domain/repositories/create_notice_repository.dart';
import 'package:lokalio/features/create_notice/domain/usecases/create_notice.dart';
import 'package:lokalio/features/notice/data/models/notice_details.dart';
import 'package:lokalio/features/notice/domain/entities/notice_details.dart';
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

  test('should get null from the repository', () async {
    when(() => mockCreateNoticeRepository.createNotice(
            noticeDetails: any(named: 'noticeDetails')))
        .thenAnswer((_) async => const Right(null));

    final result = await createNotice(Params(noticeDetails: tNoticeDetails));

    expect(result, const Right(null));
    verify(() =>
        mockCreateNoticeRepository.createNotice(noticeDetails: tNoticeDetails));
    verifyNoMoreInteractions(mockCreateNoticeRepository);
  });
}
