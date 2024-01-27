import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_up.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignUp usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignUp(authRepository: mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password';

  test('should get bool from the repository', () async {
    when(() => mockAuthRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => const Right(null));

    final result =
        await usecase(const SignUpParams(email: tEmail, password: tPassword));

    expect(result, const Right(true));
    verify(() => mockAuthRepository.signUp(email: tEmail, password: tPassword));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
