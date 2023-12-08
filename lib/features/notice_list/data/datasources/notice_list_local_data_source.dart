import 'dart:convert';

import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/notice_list/data/models/notice.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NoticeListLocalDataSource {
  Future<List<NoticeModel>> getCachedNotices();
  Future<List<NoticeModel>> getUserCachedNotices({required String userId});
}

const cachedNoticeList = 'CACHED_NOTICE_LIST';

class NoticeListLocalDataSourceImpl implements NoticeListLocalDataSource {
  final SharedPreferences sharedPreferences;

  const NoticeListLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<NoticeModel>> getCachedNotices() async {
    final jsonString = sharedPreferences.getString(cachedNoticeList);

    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final List<NoticeModel> notices = jsonList.map((json) {
        return NoticeModel.fromJson(json: json);
      }).toList();

      return notices;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<NoticeModel>> getUserCachedNotices({required String userId}) {
    // TODO: implement getUserNotices
    throw UnimplementedError();
  }
}
