import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/create_notice/data/datasources/create_notice_local_data_source.dart';
import 'package:lokalio/features/read_notice/data/models/notice_details.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late CreateNoticeLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = CreateNoticeLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  final tNoticeDetailsModel = NoticeDetailsModel.fromJson(
      json: json.decode(fixture(name: 'notice_details_cached.json')));

  test('should cache NoticeDetailsModel to SharedPreferences', () async {
    when(() => mockSharedPreferences.setString(
            cachedCreatedNotice, json.encode(tNoticeDetailsModel.toJson())))
        .thenAnswer((_) async => true);

    await dataSource.cacheCreateNotice(noticeDetails: tNoticeDetailsModel);

    verify(() => mockSharedPreferences.setString(
        cachedCreatedNotice, json.encode(tNoticeDetailsModel.toJson())));
  });

  test('should return NoticeDetailsModel from SharedPreferences', () async {
    when(() => mockSharedPreferences.getString(cachedCreatedNotice))
        .thenReturn(fixture(name: 'notice_details_cached.json'));

    final result = await dataSource.readCacheCreateNotice();

    verify(() => mockSharedPreferences.getString(cachedCreatedNotice));
    expect(result, equals(tNoticeDetailsModel));
  });

  test('should throw CacheException when there is no cached data present',
      () async {
    when(() => mockSharedPreferences.getString(cachedCreatedNotice))
        .thenReturn(null);

    final call = dataSource.readCacheCreateNotice;

    expect(() => call(), throwsA(isA<CacheException>()));
  });
}
