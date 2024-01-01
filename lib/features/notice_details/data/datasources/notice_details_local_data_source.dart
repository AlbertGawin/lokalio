import 'dart:convert';

import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/notice_details/data/models/notice_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NoticeDetailsLocalDataSource {
  Future<NoticeDetailsModel> getCachedNoticeDetails({required String id});
  Future<void> cacheNoticeDetails({required NoticeDetailsModel noticeDetails});
}

const cachedUserId = 'CACHED_USER_ID';
const cachedNoticeDetails = 'CACHED_NOTICE_DETAILS';

class NoticeDetailsLocalDataSourceImpl implements NoticeDetailsLocalDataSource {
  final SharedPreferences sharedPreferences;

  const NoticeDetailsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NoticeDetailsModel> getCachedNoticeDetails(
      {required String id}) async {
    final jsonString = sharedPreferences.getString(cachedNoticeDetails);

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
  Future<void> cacheNoticeDetails(
      {required NoticeDetailsModel noticeDetails}) async {
    final jsonString = json.encode(noticeDetails.toJson());
    await sharedPreferences.setString(cachedNoticeDetails, jsonString);
  }
}
