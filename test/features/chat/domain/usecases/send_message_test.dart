import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/chat/domain/repositories/chat_repository.dart';
import 'package:lokalio/features/chat/domain/usecases/send_message.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository repository;
  late SendMessage usecase;

  setUp(() {
    repository = MockChatRepository();
    usecase = SendMessage(repository: repository);
  });

  const tReceiverId = 'receiverId';
  const tMessage = 'message';

  test('should get bool from the repository', () async {
    when(() => repository.sendMessage(
          message: tMessage,
          receiverId: tReceiverId,
        )).thenAnswer((_) async => const Right(null));

    final result = await usecase(const Params(
      receiverId: tReceiverId,
      message: tMessage,
    ));

    expect(result, const Right(null));
    verify(() => repository.sendMessage(
          message: tMessage,
          receiverId: tReceiverId,
        ));
    verifyNoMoreInteractions(repository);
  });
}
