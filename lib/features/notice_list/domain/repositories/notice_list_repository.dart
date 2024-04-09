import 'package:lokalio/features/notice_list/domain/entities/notice.dart';

abstract class NoticeListRepository {
  Future<List<Notice>> getAllNotices();
  Future<List<Notice>> getUserNotices({required String userId});
}
