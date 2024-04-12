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
  Future<NoticeDetails> readNotice({required String noticeId}) async {
    if (await networkInfo.isConnected) {
      try {
        final noticeDetails =
            await remoteDataSource.readNotice(noticeId: noticeId);

        return noticeDetails;
      } on NoDataException {
        throw const NoDataFailure();
      } on Exception {
        throw const ServerFailure();
      }
    } else {
      throw const NoConnectionFailure();
    }
  }
}
