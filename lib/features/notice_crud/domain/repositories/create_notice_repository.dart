import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/features/notice_crud/domain/entities/notice_details.dart';

abstract class NoticeCRUDRepository {
  Future<Either<Failure, bool>> createNotice({
    required NoticeDetails noticeDetails,
  });
  Future<Either<Failure, NoticeDetails>> readNotice({
    required String noticeId,
  });
  Future<Either<Failure, bool>> updateNotice({
    required NoticeDetails noticeDetails,
  });
  Future<Either<Failure, bool>> deleteNotice({
    required String noticeId,
  });
  Future<Either<Failure, bool>> saveNotice({
    required NoticeDetails noticeDetails,
  });
}
