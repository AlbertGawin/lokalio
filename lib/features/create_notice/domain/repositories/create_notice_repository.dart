import 'package:fpdart/fpdart.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/features/notice/domain/entities/notice_details.dart';

abstract class CreateNoticeRepository {
  Future<Either<Failure, void>> createNotice({
    required NoticeDetails noticeDetails,
  });
}
