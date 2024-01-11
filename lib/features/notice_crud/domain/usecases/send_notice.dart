import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/notice_crud/domain/entities/notice_details.dart';
import 'package:lokalio/features/notice_crud/domain/repositories/create_notice_repository.dart';

class CreateNotice implements UseCase<bool, Params> {
  final NoticeCRUDRepository repository;

  CreateNotice(this.repository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await repository.createNotice(noticeDetails: params.noticeDetails);
  }
}

class Params extends Equatable {
  final NoticeDetails noticeDetails;

  const Params(this.noticeDetails);

  @override
  List<Object?> get props => [noticeDetails];
}
