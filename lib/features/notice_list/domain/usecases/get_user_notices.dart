import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/domain/repositories/notice_list_repository.dart';

class GetUserNotices implements UseCase<List<Notice>, Params> {
  final NoticeListRepository noticeListRepository;

  const GetUserNotices({required this.noticeListRepository});

  @override
  Future<Either<Failure, List<Notice>>> call(Params params) async {
    return await noticeListRepository.getUserNotices(userId: params.userId);
  }
}

class Params extends Equatable {
  final String userId;

  const Params({required this.userId});

  @override
  List<Object?> get props => [userId];
}
