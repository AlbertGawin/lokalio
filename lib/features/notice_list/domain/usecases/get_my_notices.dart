import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/domain/repositories/notice_list_repository.dart';

class GetMyNotices implements UseCase<List<Notice>, NoParams> {
  final NoticeListRepository noticeListRepository;

  const GetMyNotices({required this.noticeListRepository});

  @override
  Future<Either<Failure, List<Notice>>> call(NoParams params) async {
    return await noticeListRepository.getMyNotices();
  }
}
