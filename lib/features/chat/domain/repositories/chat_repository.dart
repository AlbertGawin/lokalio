import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/failures.dart';

abstract class ChatRepository {
  Future<Either<Failure, void>> getAllChats();
  Future<Either<Failure, void>> sendMessage({
    required String receiverId,
    required String message,
  });
}
