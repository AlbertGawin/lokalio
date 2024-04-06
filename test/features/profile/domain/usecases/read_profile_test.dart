import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';
import 'package:lokalio/features/profile/domain/repositories/profile_repository.dart';
import 'package:lokalio/features/profile/domain/usecases/read_profile.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockProfileRepository;
  late ReadProfile usecase;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    usecase = ReadProfile(repository: mockProfileRepository);
  });

  const tuserId = '1';
  Profile tProfile = Profile(
    id: tuserId,
    username: 'Albert Gawin',
    email: 'albertg952@gmail.com',
    phoneNumber: '+48881657238',
    city: 'Rzeszów',
    createdAt: Timestamp.now(),
  );

  test('should get NoticeDetails from the repository', () async {
    when(() => mockProfileRepository.readProfile(userId: any(named: 'userId')))
        .thenAnswer((_) async => Right(tProfile));

    final result = await usecase(const Params(userId: tuserId));

    expect(result, Right(tProfile));
    verify(() => mockProfileRepository.readProfile(userId: tuserId));
    verifyNoMoreInteractions(mockProfileRepository);
  });
}
