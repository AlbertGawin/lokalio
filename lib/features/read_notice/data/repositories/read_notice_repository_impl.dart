import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';

import 'package:lokalio/features/read_notice/data/datasources/read_notice_remote_data_source.dart';
import 'package:lokalio/features/read_notice/data/models/notice_details.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';
import 'package:lokalio/features/read_notice/domain/repositories/read_notice_repository.dart';

typedef _Chooser = Future<NoticeDetailsModel> Function();

class ReadNoticeRepositoryImpl implements ReadNoticeRepository {
  final ReadNoticeRemoteDataSource remoteDataSource;

  final NetworkInfo networkInfo;

  const ReadNoticeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<NoticeDetails> readNotice({required String noticeId}) async {
    return await _readNoticeDetails(
      chooserFunction: () async {
        return await remoteDataSource.readNotice(noticeId: noticeId);
      },
    );
  }

  Future<NoticeDetails> _readNoticeDetails({
    required _Chooser chooserFunction,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final noticeDetails = await chooserFunction();

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
