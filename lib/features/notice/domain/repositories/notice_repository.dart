import 'package:lokalio/features/notice/domain/entities/notice_details.dart';

abstract class NoticeRepository {
  Future<NoticeDetails> readNotice({required String noticeId});
}
