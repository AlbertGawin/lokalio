import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/create_notice/domain/repositories/create_notice_repository.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';

class CreateNotice implements UseCase<void, Params> {
  final CreateNoticeRepository repository;

  const CreateNotice({required this.repository});

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.createNotice(noticeDetails: params.noticeDetails);
  }
}

class Params extends Equatable {
  final NoticeDetails noticeDetails;

  const Params({required this.noticeDetails});

  @override
  List<Object?> get props => [noticeDetails];
}
