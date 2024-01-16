import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/read_notice/data/datasources/read_notice_local_data_source.dart';
import 'package:lokalio/features/read_notice/data/datasources/read_notice_remote_data_source.dart';
import 'package:lokalio/features/read_notice/data/models/notice_details.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';
import 'package:lokalio/features/read_notice/domain/repositories/read_notice_repository.dart';

typedef _MyOrUserChooser = Future<NoticeDetailsModel> Function();

class ReadNoticeRepositoryImpl implements ReadNoticeRepository {
  final ReadNoticeRemoteDataSource remoteDataSource;
  final ReadNoticeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const ReadNoticeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NoticeDetails>> readNotice(
      {required String noticeId}) async {
    return await _getNoticeDetails(
      remoteMyOrUser: () async {
        return await remoteDataSource.readNotice(noticeId: noticeId);
      },
      localMyOrUser: () async {
        return await localDataSource.readCachedNotice(noticeId: noticeId);
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
        await localDataSource.cacheNotice(noticeDetails: noticeDetails);

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
