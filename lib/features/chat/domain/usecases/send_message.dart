import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/chat/domain/repositories/chat_repository.dart';

class SendMessage implements UseCase<void, Params> {
  final ChatRepository repository;

  const SendMessage({required this.repository});

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.sendMessage(
      receiverId: params.receiverId,
      message: params.message,
    );
  }
}

class Params {
  final String receiverId;
  final String message;

  const Params({required this.receiverId, required this.message});
}
