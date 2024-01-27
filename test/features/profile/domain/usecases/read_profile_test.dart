import 'package:dartz/dartz.dart';
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

  const tProfileId = '1';
  const Profile tProfile = Profile(
    id: tProfileId,
    name: 'Albert',
    email: 'albertg952@gmail.com',
    phoneNumber: '+48881657238',
  );

  test('should get NoticeDetails from the repository', () async {
    when(() => mockProfileRepository.readProfile(
            profileId: any(named: 'profileId')))
        .thenAnswer((_) async => const Right(tProfile));

    final result = await usecase(const Params(profileId: tProfileId));

    expect(result, const Right(tProfile));
    verify(() => mockProfileRepository.readProfile(profileId: tProfileId));
    verifyNoMoreInteractions(mockProfileRepository);
  });
}
