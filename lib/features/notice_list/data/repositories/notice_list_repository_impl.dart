import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/notice_list/data/datasources/notice_list_local_data_source.dart';
import 'package:lokalio/features/notice_list/data/datasources/notice_list_remote_data_source.dart';
import 'package:lokalio/features/notice_list/data/models/notice.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/domain/repositories/notice_list_repository.dart';

typedef _AllOrUserChooser = Future<List<NoticeModel>> Function();

class NoticeListRepositoryImpl implements NoticeListRepository {
  final NoticeListRemoteDataSource remoteDataSource;
  final NoticeListLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const NoticeListRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Notice>>> getAllNotices() async {
    return await _getNoticeList(
      remoteAllOrUser: () async {
        return await remoteDataSource.getAllNotices();
      },
      localAllOrUser: () async {
        return await localDataSource.getAllCachedNotices();
      },
    );
  }

  @override
  Future<Either<Failure, List<Notice>>> getUserNotices(
      {required String userId}) async {
    return await _getNoticeList(
      remoteAllOrUser: () async {
        return await remoteDataSource.getUserNotices(userId: userId);
      },
      localAllOrUser: () async {
        return await localDataSource.getUserCachedNotices(userId: userId);
      },
    );
  }

  Future<Either<Failure, List<Notice>>> _getNoticeList({
    required _AllOrUserChooser remoteAllOrUser,
    required _AllOrUserChooser localAllOrUser,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final noticeList = await remoteAllOrUser();
        await localDataSource.cacheNoticeList(noticeList: noticeList);

        return Right(noticeList);
      } on Exception {
        return const Left(ServerFailure());
      }
    } else {
      try {
        final localNotices = await localAllOrUser();
        return Right(localNotices);
      } on Exception {
        return const Left(CacheFailure());
      }
    }
  }
}
