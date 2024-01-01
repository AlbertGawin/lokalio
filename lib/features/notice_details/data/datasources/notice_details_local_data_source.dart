import 'package:lokalio/features/notice_details/data/models/notice_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NoticeDetailsLocalDataSource {
  Future<NoticeDetailsModel> getMyCachedNoticeDetails({required String id});
  Future<NoticeDetailsModel> getCachedNoticeDetails({required String id});
  Future<void> cacheNoticeDetails({required NoticeDetailsModel noticeDetails});
}

const cachedUserId = 'CACHED_USER_ID';
const cachedNoticeDetails = 'CACHED_NOTICE_DETAILS';

class NoticeDetailsLocalDataSourceImpl implements NoticeDetailsLocalDataSource {
  final SharedPreferences sharedPreferences;

  const NoticeDetailsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheNoticeDetails({required NoticeDetailsModel noticeDetails}) {
    // TODO: implement cacheNoticeDetails
    throw UnimplementedError();
  }

  @override
  Future<NoticeDetailsModel> getCachedNoticeDetails({required String id}) {
    // TODO: implement getCachedNoticeDetails
    throw UnimplementedError();
  }

  @override
  Future<NoticeDetailsModel> getMyCachedNoticeDetails({required String id}) {
    // TODO: implement getMyCachedNoticeDetails
    throw UnimplementedError();
  }
}
