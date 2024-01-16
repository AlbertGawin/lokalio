import 'dart:convert';

import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/read_notice/data/models/notice_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ReadNoticeLocalDataSource {
  Future<NoticeDetailsModel> readCachedNotice({required String noticeId});
  Future<void> cacheNotice({required NoticeDetailsModel noticeDetails});
}

const cachedUserId = 'CACHED_USER_ID';
const cachedLastSeenNotice = 'CACHED_LAST_SEEN_NOTICE';

class ReadNoticeLocalDataSourceImpl implements ReadNoticeLocalDataSource {
  final SharedPreferences sharedPreferences;

  const ReadNoticeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NoticeDetailsModel> readCachedNotice(
      {required String noticeId}) async {
    final jsonString = sharedPreferences.getString(cachedLastSeenNotice);

    if (jsonString != null) {
      final dynamic jsonData = json.decode(jsonString);
      final NoticeDetailsModel noticeDetails =
          NoticeDetailsModel.fromJson(json: jsonData);

      return noticeDetails;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNotice({required NoticeDetailsModel noticeDetails}) async {
    final jsonString = json.encode(noticeDetails.toJson());
    try {
      await sharedPreferences.setString(cachedLastSeenNotice, jsonString);
    } catch (e) {
      throw CacheException();
    }
  }
}
