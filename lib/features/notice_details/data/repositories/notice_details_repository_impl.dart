import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/notice_details/data/datasources/notice_details_local_data_source.dart';
import 'package:lokalio/features/notice_details/data/datasources/notice_details_remote_data_source.dart';
import 'package:lokalio/features/notice_details/data/models/notice_details.dart';
import 'package:lokalio/features/notice_details/domain/entities/notice_details.dart';
import 'package:lokalio/features/notice_details/domain/repositories/notice_details_repository.dart';

typedef _MyOrUserChooser = Future<NoticeDetailsModel> Function();

class NoticeDetailsRepositoryImpl implements NoticeDetailsRepository {
  final NoticeDetailsRemoteDataSource remoteDataSource;
  final NoticeDetailsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const NoticeDetailsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NoticeDetails>> getNoticeDetails(
      {required String noticeId}) async {
    return await _getNoticeDetails(
      remoteMyOrUser: () async {
        return await remoteDataSource.getNoticeDetails(noticeId: noticeId);
      },
      localMyOrUser: () async {
        return await localDataSource.getCachedNoticeDetails(noticeId: noticeId);
      },
    );
  }

  Future<Either<Failure, NoticeDetails>> _getNoticeDetails({
    required _MyOrUserChooser remoteMyOrUser,
    required _MyOrUserChooser localMyOrUser,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final noticeDetails = await remoteMyOrUser();
        await localDataSource.cacheNoticeDetails(noticeDetails: noticeDetails);

        return Right(noticeDetails);
      } on NoDataException {
        return const Left(NoDataFailure());
      } on Exception {
        return const Left(ServerFailure());
      }
    } else {
      try {
        final localNoticeDetails = await localMyOrUser();
        return Right(localNoticeDetails);
      } on Exception {
        return const Left(CacheFailure());
      }
    }
  }
}
