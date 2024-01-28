import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';
import 'package:lokalio/features/auth/domain/usecases/set_profile_info.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late SetProfileInfo usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SetProfileInfo(authRepository: mockAuthRepository);
  });

  test('should get bool from the repository', () async {
    when(() =>
            mockAuthRepository.setProfileInfo(name: '', phone: '', smsCode: ''))
        .thenAnswer((_) async => const Right(null));

    final result =
        await usecase(const ProfileParams(name: '', phone: '', smsCode: ''));

    expect(result, const Right(null));
    verify(() =>
        mockAuthRepository.setProfileInfo(name: '', phone: '', smsCode: ''));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
