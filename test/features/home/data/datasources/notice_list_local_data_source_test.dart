import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/home/data/datasources/notice_list_local_data_source.dart';
import 'package:lokalio/features/home/data/models/notice.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NoticeListLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NoticeListLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getAllCachedNotices', () {
    final tNoticeModelList = List<NoticeModel>.from(json
            .decode(fixture(name: 'notice_list_cached.json'))
            .map<NoticeModel>((e) => NoticeModel.fromJson(json: e)))
        .where((element) => element.userId != '1')
        .toList();

    test('should return List<NoticeModel> from SharedPreferences', () async {
      when(() => mockSharedPreferences.getString(cachedNoticeList))
          .thenReturn(fixture(name: 'notice_list_cached.json'));
      when(() => mockSharedPreferences.getString(cachedUserId)).thenReturn('1');

      final result = await dataSource.getAllCachedNotices();

      verify(() => mockSharedPreferences.getString(cachedNoticeList));
      expect(result, equals(tNoticeModelList));
    });

    test('should throw a CacheException when there is no cached value',
        () async {
      when(() => mockSharedPreferences.getString(cachedNoticeList))
          .thenReturn(null);

      final call = dataSource.getAllCachedNotices;

      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('getUserCachedNotices', () {
    final tNoticeModelList = List<NoticeModel>.from(json
            .decode(fixture(name: 'notice_list_cached.json'))
            .map<NoticeModel>((e) => NoticeModel.fromJson(json: e)))
        .where((element) => element.userId == '3')
        .toList();

    test('should return List<NoticeModel> from SharedPreferences', () async {
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture(name: 'notice_list_cached.json'));

      final result = await dataSource.getUserCachedNotices(userId: '3');

      verify(() => mockSharedPreferences.getString(cachedNoticeList));
      expect(result, equals(tNoticeModelList));
    });

    test('should throw a CacheException when there is no cached value',
        () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      final call = dataSource.getUserCachedNotices;

      expect(() => call(userId: '1'), throwsA(isA<CacheException>()));
    });
  });

  group('cacheNoticeList', () {
    final tNoticeModelList = List<NoticeModel>.from(json
            .decode(fixture(name: 'notice_list_cached.json'))
            .map<NoticeModel>((e) => NoticeModel.fromJson(json: e)))
        .where((element) => element.userId != '1')
        .toList();

    test('should call SharedPreferences to cache the data', () async {
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);

      dataSource.cacheNoticeList(noticeList: tNoticeModelList);

      final expectedJsonString = json.encode(
        tNoticeModelList.map((e) => e.toJson()).toList(),
      );

      verify(() => mockSharedPreferences.setString(
            cachedNoticeList,
            expectedJsonString,
          ));
    });
  });
}
