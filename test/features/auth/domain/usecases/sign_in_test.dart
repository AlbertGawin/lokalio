import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignIn usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignIn(authRepository: mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password';

  test('should get bool from the repository', () async {
    when(() => mockAuthRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => const Right(true));

    final result =
        await usecase(const SignInParams(email: tEmail, password: tPassword));

    expect(result, const Right(true));
    verify(() => mockAuthRepository.signIn(email: tEmail, password: tPassword));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
