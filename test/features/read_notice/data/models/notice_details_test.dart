import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/read_notice/data/models/notice_details.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNoticeDetailsModel = NoticeDetailsModel.fromJson(
    json: json.decode(fixture(name: 'notice_details.json')),
  );

  test('should be a subclass of NoticeDetails entity', () async {
    expect(tNoticeDetailsModel, isA<NoticeDetails>());
  });

  group('fromJson', () {
    test('should return a valid model when JSON is provided', () async {
      final result = NoticeDetailsModel.fromJson(
        json: json.decode(fixture(name: 'notice_details.json')),
      );

      expect(result, equals(tNoticeDetailsModel));
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final result = tNoticeDetailsModel.toJson();

      expect(result, equals(json.decode(fixture(name: 'notice_details.json'))));
    });
  });
}
