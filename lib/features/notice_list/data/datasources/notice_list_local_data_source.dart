import 'dart:convert';

import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/notice_list/data/models/notice.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NoticeListLocalDataSource {
  Future<List<NoticeModel>> getAllCachedNotices();
  Future<List<NoticeModel>> getUserCachedNotices({required String userId});
  Future<void> cacheNoticeList({required List<NoticeModel> noticeList});
}

const cachedUserId = 'CACHED_USER_ID';
const cachedNoticeList = 'CACHED_NOTICE_LIST';

class NoticeListLocalDataSourceImpl implements NoticeListLocalDataSource {
  final SharedPreferences sharedPreferences;

  const NoticeListLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<NoticeModel>> getAllCachedNotices() async {
    final jsonString = sharedPreferences.getString(cachedNoticeList);
    final userId = sharedPreferences.getString(cachedUserId);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<NoticeModel> notices = jsonList.map((json) {
        return NoticeModel.fromJson(json: json);
      }).where((element) {
        return element.userId != userId;
      }).toList();

      return notices;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<NoticeModel>> getUserCachedNotices(
      {required String userId}) async {
    final jsonString = sharedPreferences.getString(cachedNoticeList);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<NoticeModel> notices = jsonList.map((json) {
        return NoticeModel.fromJson(json: json);
      }).where((element) {
        return element.userId == userId;
      }).toList();

      return notices;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNoticeList({required List<NoticeModel> noticeList}) async {
    final List<dynamic> jsonList = noticeList.map((notice) {
      return notice.toJson();
    }).toList();

    await sharedPreferences.setString(
      cachedNoticeList,
      json.encode(jsonList),
    );
  }
}
