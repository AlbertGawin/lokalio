import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';

abstract class ReadNoticeRepository {
  Future<NoticeDetails> readNotice({required String noticeId});
}
