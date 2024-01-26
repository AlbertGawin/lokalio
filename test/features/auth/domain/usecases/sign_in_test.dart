import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockAuthCredential mockAuthCredential;
  late SignIn usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockAuthCredential = MockAuthCredential();
    usecase = SignIn(authRepository: mockAuthRepository);
  });

  test('should get bool from the repository', () async {
    when(() => mockAuthRepository.signIn(
          credential: mockAuthCredential,
        )).thenAnswer((_) async => const Right(null));

    final result = await usecase(SignInParams(credential: mockAuthCredential));

    expect(result, const Right(null));
    verify(() => mockAuthRepository.signIn(credential: mockAuthCredential));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
