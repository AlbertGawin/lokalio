import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/chat/domain/repositories/chat_repository.dart';
import 'package:lokalio/features/chat/domain/usecases/get_all_chats.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository repository;
  late GetChats usecase;

  setUp(() {
    repository = MockChatRepository();
    usecase = GetChats(repository: repository);
  });

  test('should get bool from the repository', () async {
    when(() => repository.getAllChats())
        .thenAnswer((_) async => const Right(null));

    final result = await usecase(NoParams());

    expect(result, const Right(null));
    verify(() => repository.getAllChats());
    verifyNoMoreInteractions(repository);
  });
}
