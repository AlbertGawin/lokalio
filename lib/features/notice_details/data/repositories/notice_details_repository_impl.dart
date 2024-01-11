import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/notice_CRUD/domain/repositories/create_notice_repository.dart';
import 'package:lokalio/features/notice_crud/data/datasources/notice_crud_local_data_source.dart';
import 'package:lokalio/features/notice_crud/domain/entities/notice_details.dart';
import 'package:lokalio/features/notice_crud/data/datasources/notice_crud_remote_data_source.dart';
import 'package:lokalio/features/notice_crud/data/models/notice_details.dart';

typedef _MyOrUserChooser = Future<NoticeDetailsModel> Function();

class NoticeCRUDRepositoryImpl implements NoticeCRUDRepository {
  final NoticeCRUDRemoteDataSource remoteDataSource;
  final NoticeCRUDLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const NoticeCRUDRepositoryImpl({
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

  @override
  Future<Either<Failure, bool>> createNotice(
      {required NoticeDetails noticeDetails}) {
    // TODO: implement createNotice
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteNotice({required String noticeId}) {
    // TODO: implement deleteNotice
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> saveNotice(
      {required NoticeDetails noticeDetails}) {
    // TODO: implement saveNotice
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> updateNotice(
      {required NoticeDetails noticeDetails}) {
    // TODO: implement updateNotice
    throw UnimplementedError();
  }
}
