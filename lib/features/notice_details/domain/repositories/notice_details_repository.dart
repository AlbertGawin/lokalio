import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/features/notice_crud/domain/entities/notice_details.dart';

abstract class NoticeDetailsRepository {
  Future<Either<Failure, NoticeDetails>> getNoticeDetails({
    required String noticeId,
  });
}
