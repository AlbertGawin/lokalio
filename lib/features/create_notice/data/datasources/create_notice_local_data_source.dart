import 'dart:convert';

import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/read_notice/data/models/notice_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CreateNoticeLocalDataSource {
  Future<void> cacheCreateNotice({required NoticeDetailsModel noticeDetails});
  Future<NoticeDetailsModel> readCacheCreateNotice();
}

const cachedCreatedNotice = 'CACHED_CREATED_NOTICE';

class CreateNoticeLocalDataSourceImpl implements CreateNoticeLocalDataSource {
  final SharedPreferences sharedPreferences;

  const CreateNoticeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheCreateNotice(
      {required NoticeDetailsModel noticeDetails}) async {
    final jsonString = json.encode(noticeDetails.toJson());
    try {
      await sharedPreferences.setString(cachedCreatedNotice, jsonString);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<NoticeDetailsModel> readCacheCreateNotice() async {
    final jsonString = sharedPreferences.getString(cachedCreatedNotice);

    if (jsonString != null) {
      final dynamic jsonData = json.decode(jsonString);
      final NoticeDetailsModel noticeDetails =
          NoticeDetailsModel.fromJson(json: jsonData);

      return noticeDetails;
    } else {
      throw CacheException();
    }
  }
}
