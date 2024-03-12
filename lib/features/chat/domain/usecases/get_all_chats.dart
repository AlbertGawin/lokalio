import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/chat/domain/repositories/chat_repository.dart';

class GetChats implements UseCase<void, NoParams> {
  final ChatRepository repository;

  const GetChats({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.getAllChats();
  }
}
