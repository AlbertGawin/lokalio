import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:lokalio/features/chat/domain/entities/chat.dart';
import 'package:lokalio/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> sendMessage(
      {required String receiverId, required String message}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendMessage(
          receiverId: receiverId,
          message: message,
        );
        return const Right(null);
      } on Exception {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<Chat>>> getAllChats() async {
    if (await networkInfo.isConnected) {
      try {
        final chatList = await remoteDataSource.getAllChats();

        return Right(chatList);
      } on Exception {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NoConnectionFailure());
    }
  }
}
