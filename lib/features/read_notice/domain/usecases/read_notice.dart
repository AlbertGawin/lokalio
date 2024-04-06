import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';
import 'package:lokalio/features/read_notice/domain/repositories/read_notice_repository.dart';

class ReadNotice implements UseCase<NoticeDetails, Params> {
  final ReadNoticeRepository repository;

  const ReadNotice({required this.repository});

  @override
  Future<Either<Failure, NoticeDetails>> call(Params params) async {
    return await repository.readNotice(noticeId: params.noticeId);
  }
}

class Params extends Equatable {
  final String noticeId;

  const Params({required this.noticeId});

  @override
  List<Object?> get props => [noticeId];
}
