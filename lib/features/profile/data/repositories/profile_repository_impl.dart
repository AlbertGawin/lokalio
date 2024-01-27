import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';
import 'package:lokalio/features/profile/domain/repositories/profile_repository.dart';

typedef _Chooser = Future<Profile> Function();

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  final NetworkInfo networkInfo;

  const ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Profile>> readMyProfile() {
    return _readProfile(
      chooserFunction: () async {
        return await remoteDataSource.readMyProfile();
      },
    );
  }

  @override
  Future<Either<Failure, Profile>> readProfile({required String profileId}) {
    return _readProfile(
      chooserFunction: () async {
        return await remoteDataSource.readProfile(profileId: profileId);
      },
    );
  }

  Future<Either<Failure, Profile>> _readProfile({
    required _Chooser chooserFunction,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final profile = await chooserFunction();

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
