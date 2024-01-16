// ignore_for_file: subtype_of_sealed_class

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/read_notice/data/datasources/read_notice_local_data_source.dart';
import 'package:lokalio/features/read_notice/data/models/notice_details.dart';

import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ReadNoticeLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        ReadNoticeLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  const tNoticeId = '1';
  final tNoticeDetailsModel = NoticeDetailsModel.fromJson(
      json: json.decode(fixture(name: 'notice_details_cached.json')));

  test('should return NoticeDetailsModel from SharedPreferences', () async {
    when(() => mockSharedPreferences.getString(cachedLastSeenNotice))
        .thenReturn(fixture(name: 'notice_details_cached.json'));

    final result = await dataSource.readCachedNotice(noticeId: tNoticeId);

    verify(() => mockSharedPreferences.getString(cachedLastSeenNotice));
    expect(result, equals(tNoticeDetailsModel));
  });

  test('should throw CacheException when there is no cached data present',
      () async {
    when(() => mockSharedPreferences.getString(cachedLastSeenNotice))
        .thenReturn(null);

    final call = dataSource.readCachedNotice;

    expect(() => call(noticeId: tNoticeId), throwsA(isA<CacheException>()));
  });
}
