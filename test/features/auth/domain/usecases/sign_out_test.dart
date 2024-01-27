import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_out.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignOut usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignOut(authRepository: mockAuthRepository);
  });

  test('should get bool from the repository', () async {
    when(() => mockAuthRepository.signOut())
        .thenAnswer((_) async => const Right(null));

    final result = await usecase(NoParams());

    expect(result, const Right(true));
    verify(() => mockAuthRepository.signOut());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
