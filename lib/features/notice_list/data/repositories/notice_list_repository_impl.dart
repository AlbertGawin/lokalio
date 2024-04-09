import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/notice_list/data/datasources/notice_list_remote_data_source.dart';
import 'package:lokalio/features/notice_list/data/models/notice.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/domain/repositories/notice_list_repository.dart';

typedef _Chooser = Future<List<NoticeModel>> Function();

class NoticeListRepositoryImpl implements NoticeListRepository {
  final NoticeListRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const NoticeListRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Notice>> getAllNotices() async {
    return await _getNoticeList(
      remoteFunction: () async {
        return await remoteDataSource.getAllNotices();
      },
    );
  }

  @override
  Future<List<Notice>> getUserNotices({required String userId}) async {
    return await _getNoticeList(
      remoteFunction: () async {
        return await remoteDataSource.getUserNotices(userId: userId);
      },
    );
  }

  Future<List<Notice>> _getNoticeList({
    required _Chooser remoteFunction,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final noticeList = await remoteFunction();

        return noticeList;
      } on Exception {
        throw const ServerFailure();
      }
    } else {
      throw const NoConnectionFailure();
    }
  }
}
