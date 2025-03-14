import 'package:fpdart/fpdart.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/profile/data/models/profile.dart';
import 'package:lokalio/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:lokalio/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProfileModel>> getProfile(
      {required String userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final profile = await remoteDataSource.getProfile(userId: userId);

        return Right(profile);
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
