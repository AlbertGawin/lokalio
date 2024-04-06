import 'package:fpdart/fpdart.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/create_notice/data/datasources/create_notice_remote_data_source.dart';
import 'package:lokalio/features/create_notice/domain/repositories/create_notice_repository.dart';
import 'package:lokalio/features/read_notice/data/models/notice_details.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';

class CreateNoticeRepositoryImpl implements CreateNoticeRepository {
  final CreateNoticeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const CreateNoticeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> createNotice({
    required NoticeDetails noticeDetails,
  }) async {
    final noticeDetailsModel =
        NoticeDetailsModel.fromNoticeDetails(noticeDetails: noticeDetails);

    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.createNotice(noticeDetails: noticeDetailsModel);

        return const Right(null);
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
