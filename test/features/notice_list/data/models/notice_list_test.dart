import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/notice_list/data/models/notice.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNoticeModelList = List<NoticeModel>.from(json
      .decode(fixture(name: 'notice_list.json'))
      .map<NoticeModel>((e) => NoticeModel.fromJson(json: e)));

  test('should be a subclass of List<Notice> entity', () async {
    expect(tNoticeModelList, isA<List<Notice>>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is valid', () async {
      for (NoticeModel tNoticeModel in tNoticeModelList) {
        final result =
            NoticeModel.fromJson(json: jsonDecode(jsonEncode(tNoticeModel)));

        expect(result, equals(tNoticeModel));
      }
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      for (NoticeModel tNoticeModel in tNoticeModelList) {
        final result = tNoticeModel.toJson();
        final tNoticeJson = jsonDecode(jsonEncode(tNoticeModel));

        expect(result, equals(tNoticeJson));
      }
    });
  });
}
