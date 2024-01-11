import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/notice_crud/domain/entities/notice_details.dart';
import 'package:lokalio/features/notice_details/domain/repositories/notice_details_repository.dart';

class GetNoticeDetails implements UseCase<NoticeDetails, Params> {
  final NoticeDetailsRepository noticeDetailsRepository;

  const GetNoticeDetails({required this.noticeDetailsRepository});

  @override
  Future<Either<Failure, NoticeDetails>> call(Params params) async {
    return await noticeDetailsRepository.getNoticeDetails(
      noticeId: params.noticeId,
    );
  }
}

class Params extends Equatable {
  final String noticeId;

  const Params({required this.noticeId});

  @override
  List<Object?> get props => [noticeId];
}
