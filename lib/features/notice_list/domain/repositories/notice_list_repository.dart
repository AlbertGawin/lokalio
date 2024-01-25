import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';

abstract class NoticeListRepository {
  Future<Either<Failure, List<Notice>>> getAllNotices();
  Future<Either<Failure, List<Notice>>> getMyNotices();
  Future<Either<Failure, List<Notice>>> getUserNotices({
    required String userId,
  });
}
