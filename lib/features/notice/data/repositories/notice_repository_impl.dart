import 'package:fpdart/fpdart.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/notice/data/datasources/notice_remote_data_source.dart';

import 'package:lokalio/features/notice/domain/entities/notice_details.dart';
import 'package:lokalio/features/notice/domain/repositories/notice_repository.dart';

class NoticeRepositoryImpl implements NoticeRepository {
  final NoticeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const NoticeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NoticeDetails>> readNotice(
      {required String noticeId}) async {
    if (await networkInfo.isConnected) {
      try {
        final noticeDetails =
            await remoteDataSource.getNotice(noticeId: noticeId);

        return Right(noticeDetails);
      } on NoDataException {
        return const Left(NoDataFailure());
      } on Exception {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NoConnectionFailure());
    }
  }
}
